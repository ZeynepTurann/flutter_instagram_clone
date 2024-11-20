import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_instagram_clone/app/view/app.dart';
import 'package:flutter_instagram_clone/l10n/l10n.dart';
import 'package:flutter_instagram_clone/selector/locale/view/locale_selector.dart';
import 'package:flutter_instagram_clone/user_profile/view/user_profile_page.dart';
import 'package:go_router/go_router.dart';
import 'package:posts_repository/posts_repository.dart';
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
        canPop: canPop,
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

    try {
      toggleLoadingIndeterminate(); //progress line is visible

      final postId = uuid.v4(); //Generate random id based on [Uuid] library

      //TODO(CREATE_POST): create post with details (backend issues)
            //  context.read<PostsRepository>().createPost(id: postId, userId: userId, caption: caption, media: media)


      goHome.call();
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
        body: const SingleChildScrollView(
          padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.sm, vertical: AppSpacing.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //TODO(post_media) : display_post_media
              const Gap.v(AppSpacing.md),
              //TODO(caption_text_field) : display_caption_text_field
            ],
          ),
        ));
  }
}
