import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/l10n/l10n.dart';
import 'package:shared/shared.dart';

void initUtilities(BuildContext context, Locale locale) {
  final isSameLocal = Localizations.localeOf(context).languageCode == locale;

  if (isSameLocal) return;

  final l10n = context.l10n;

  PickImage().init(
    tabsTexts: TabsTexts(
      photoText: l10n.photoText,
      videoText: l10n.videoText,
      acceptAllPermissions: l10n.acceptAllPermissionsText,
      clearImagesText: l10n.clearImagesText,
      deletingText: l10n.deletingText,
      galleryText: l10n.galleryText,
      holdButtonText: l10n.holdButtonText,
      noMediaFound: l10n.noMediaFound,
      notFoundingCameraText: l10n.notFoundingCameraText,
      noCameraFoundText: l10n.noCameraFoundText,
      newPostText: l10n.newPostText,
      newAvatarImageText: l10n.newAvatarImageText,
    ),
  );
}
