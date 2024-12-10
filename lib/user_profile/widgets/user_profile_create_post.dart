import 'dart:convert';
import 'dart:typed_data';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_instagram_clone/app/view/app.dart';
import 'package:flutter_instagram_clone/l10n/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:posts_repository/posts_repository.dart';
import 'package:powersync_repository/powersync_repository.dart';
import 'package:shared/shared.dart';

class UserProfileCreatePost extends StatelessWidget {
  const UserProfileCreatePost(
      {super.key,
      this.canPop = true,
      this.imagePickerKey,
      this.onBackButtonTap,
      this.onPopInvoked});

  final bool canPop;
  final Key? imagePickerKey;
  final VoidCallback? onBackButtonTap;
  final VoidCallback? onPopInvoked; //void function()

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: canPop, //canPop false => blocks the current route
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          onPopInvoked?.call();
        },
        child: PickImage().customMediaPicker(
          context: context,
          source: ImageSource.both,
          pickerSource: PickerSource.both,
          onMediaPicked: (details) {
            //just before sharing the post
            context.pushNamed('publish_post',
                extra: CreatePostProps(details: details));
          },
          onBackButtonTap:
              onBackButtonTap != null ? () => onBackButtonTap?.call() : null,
        ));
  }
}

//pop scope is a powerful widget that allows you to control how your app behaves

class CreatePostProps {
  const CreatePostProps(
      {required this.details, this.isReel = false, this.context});

  final SelectedImagesDetails details;
  final bool isReel;
  final BuildContext? context;
}

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key, required this.props});

  final CreatePostProps props;

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  late TextEditingController _captionController;
  late List<Media> _media;

  List<SelectedByte> get selectedFiles => widget.props.details.selectedFiles;

  @override
  void initState() {
    super.initState();

    _captionController = TextEditingController();
    _media = selectedFiles //choosen files turned into media
        .map(
          (e) => e.isThatImage
              ? MemoryImageMedia(bytes: e.selectedByte, id: uuid.v4())
              : MemoryVideoMedia(id: uuid.v4(), file: e.selectedFile),
        )
        .toList();
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  Future<void> _onShareTap(String caption) async {
    void goHome() {
      if (widget.props.isReel) {
        context
          ..pop()
          ..pop();
      } else {
        //TODO(home_page_view) :navigate to home page (FEED)
      }
    }

    final bool navigateToReelPage = widget.props.isReel ||
        (selectedFiles.length == 1 &&
            selectedFiles.every((e) => !e.isThatImage));

    StatefulNavigationShell.maybeOf(context)
        ?.goBranch(navigateToReelPage ? 3 : 0, initialLocation: true);

    try {
      toggleLoadingIndeterminate(); //progress line is visible

      final postId = uuid.v4(); //Generate random id based on [Uuid] library

      //TODO(CREATE_POST): create post with details (backend issues)
      //remowed userId prop because user is authenticated in this step

      //now, we have list of media , but post includes media as a string
      void uploadPost({required List<Map<String, dynamic>> media}) => context
          .read<PostsRepository>()
          .createPost(id: postId, caption: caption, media: jsonEncode(media));

      if (widget.props.isReel) {
        try {
          late final postId = uuid.v4();
          late final storage = Supabase.instance.client.storage.from('posts');

          late final mediaPath = '$postId/video_0';

          final selectedFile = selectedFiles.first;

          final firstFrame =
              await VideoPlus.getVideoThumbnail(selectedFile.selectedFile);

          final blurHash = firstFrame == null
              ? ''
              : await BlurHashPlus.blurHashEncode(firstFrame);

          final compressedVideo = (await VideoPlus.compressVideo(
                selectedFile.selectedFile,
              ))
                  ?.file ??
              selectedFile.selectedFile;

          final compressedVideoBytes =
              await PickImage().imageBytes(file: compressedVideo);

          final attachment = AttachmentFile(
              size: compressedVideoBytes.length,
              bytes: compressedVideoBytes,
              path: compressedVideo.path);

          await storage.uploadBinary(mediaPath, attachment.bytes!,
              fileOptions: FileOptions(
                  contentType: attachment.mediaType!.mimeType,
                  cacheControl: '9000000'));

          final mediaUrl = storage.getPublicUrl(mediaPath);
          String? firstFrameUrl;

          if (firstFrame != null) {
            late final firstFramePath = '$postId/video_first_frame_0';
            await storage.uploadBinary(firstFramePath, firstFrame,
                fileOptions: FileOptions(
                    contentType: attachment.mediaType!.mimeType,
                    cacheControl: '9000000'));
            firstFrameUrl = storage.getPublicUrl(firstFramePath);
          }


          final media = [
            {
              'media_id': uuid.v4(),
              'url': mediaUrl,
              'type': VideoMedia.identifier,
              'blur_hash': blurHash,
              'first_frame_url': firstFrameUrl
            }
          ];

          uploadPost(media: media);
        } catch (error, stackTrace) {
          logE('Filed to create reel!', error: error, stackTrace: stackTrace);
        }
      } else {
        final storage = Supabase.instance.client.storage.from('posts');

        final media = <Map<String, dynamic>>[];

        for (var i = 0; i < selectedFiles.length; i++) {
          late final selectedByte = selectedFiles[i].selectedByte;
          late final selectedFile = selectedFiles[i].selectedFile;
          late final isVideo = selectedFile.isVideo;
          String blurHash;
          Uint8List? convertedBytes;
          if (isVideo) {
            convertedBytes = await VideoPlus.getVideoThumbnail(selectedFile);
            blurHash = convertedBytes == null
                ? ''
                : await BlurHashPlus.blurHashEncode(convertedBytes);
          } else {
            blurHash = await BlurHashPlus.blurHashEncode(selectedByte);
          }
          late final mediaExtension =
              selectedFile.path.split('.').last.toLowerCase(); //.jpeg

          late final mediaPath =
              '$postId/${!isVideo ? 'image_$i' : 'video_$i'}';

          Uint8List bytes;

          if (isVideo) {
            try {
              final compressedVideo =
                  await VideoPlus.compressVideo(selectedFile);
              bytes =
                  await PickImage().imageBytes(file: compressedVideo!.file!);
            } catch (error, stackTrace) {
              logE('Error compressing viode',
                  error: error, stackTrace: stackTrace);
              bytes = selectedByte;
            }
          } else {
            bytes = selectedByte;
          }

          await storage.uploadBinary(mediaPath, bytes,
              fileOptions: FileOptions(
                  contentType:
                      '${!isVideo ? 'image' : 'video'}/$mediaExtension',
                  cacheControl: '9000000'));
          final mediaUrl = storage.getPublicUrl(mediaPath);

          String? firstFrameUrl;

          if (convertedBytes != null) {
            late final firstFramePath = '$postId/video_first_frame_$i';
            await storage.uploadBinary(firstFramePath, convertedBytes,
                fileOptions: FileOptions(
                    contentType: 'video/$mediaExtension',
                    cacheControl: '9000000'));
            firstFrameUrl = storage.getPublicUrl(firstFramePath);
          }
          //video_first_frame => preview of the video without playing 
          final mediaType =
              isVideo ? VideoMedia.identifier : ImageMedia.identifier;

          if (isVideo) {
            media.add({
              'media_id': uuid.v4(),
              'url': mediaUrl,
              'type': mediaType,
              'blur_hash': blurHash,
              'first_frame_url': firstFrameUrl
            });
          } else {
            media.add({
              'media_id': uuid.v4(),
              'url': mediaUrl,
              'type': mediaType,
              'blur_hash': blurHash
            });
          }
        }

        uploadPost(media: media);
      }

      goHome.call();
      toggleLoadingIndeterminate(enable: false);
      openSnackbar(
          const SnackbarMessage.success(title: 'Successfully created post!'));
    } catch (error, stackTrace) {
      toggleLoadingIndeterminate(enable: false); //invisible
      logE("Failed to create post", error: error, stackTrace: stackTrace);
      openSnackbar(
          const SnackbarMessage.error(title: 'Failed to create post!'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        releaseFocus: true,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          centerTitle: false,
          title: Text(context.l10n.newPostText),
        ),
        bottomNavigationBar: PublishPostButton(
            onShareTap: () => _onShareTap(_captionController.text.trim())),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.sm, vertical: AppSpacing.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //TODO(post_media) : display_post_media
              Gap.v(AppSpacing.md),
              CaptionInputField(
                caption: _captionController.text.trim(),
                captionController: _captionController,
                onSubmitted: _onShareTap,
              )
            ],
          ),
        ));
  }
}

class PublishPostButton extends StatelessWidget {
  const PublishPostButton({required this.onShareTap, super.key});

  final VoidCallback onShareTap;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      elevation: 0,
      color: context.reversedAdaptiveColor,
      padding: EdgeInsets.zero,
      height: 90,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AppDivider(),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            child: Tappable.faded(
              onTap: onShareTap,
              borderRadius: BorderRadius.circular(6),
              backgroundColor: AppColors.blue,
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.md,
                horizontal: AppSpacing.sm,
              ),
              child: Align(
                child: Text(
                  context.l10n.sharePostText,
                  style: context.labelLarge,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CaptionInputField extends StatefulWidget {
  const CaptionInputField(
      {super.key,
      required this.captionController,
      required this.caption,
      required this.onSubmitted});

  final TextEditingController captionController;
  final String caption;
  final ValueSetter<String> onSubmitted;

  @override
  State<CaptionInputField> createState() => _CaptionInputFieldState();
}

class _CaptionInputFieldState extends State<CaptionInputField> {
  late String _initialCaption;

  @override
  void initState() {
    super.initState();
    _initialCaption = widget.caption;
  }

  @override
  void didUpdateWidget(covariant CaptionInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.caption != _initialCaption) {
      setState(() {
        _initialCaption = widget.caption;
      });
    }
  }

  String _effectiveValue(String? value) =>
      value ?? widget.captionController.text.trim();

  bool _equals(String? value) => _initialCaption == _effectiveValue(value);

  @override
  Widget build(BuildContext context) {
    return AppTextField(
        border: InputBorder.none,
        textController: widget.captionController,
        contentPadding: EdgeInsets.zero,
        textInputType: TextInputType.text,
        textInputAction: TextInputAction.newline,
        textCapitalization: TextCapitalization
            .sentences, //open uppercase keyboard for the first letter of each sentence
        hintText: context.l10n.writeCaptionText,
        onFieldSubmitted: (value) =>
            _equals(value) ? null : widget.onSubmitted(_effectiveValue(value)));
  }
}
