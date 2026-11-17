import 'package:flutter/material.dart';

import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';

enum TagType {
  newArtist,
  hot,
  emerging;

  static TagType? getTag(int likes, int dislikes) {
    final int totalCount = likes + dislikes;

    if (totalCount < 20) return TagType.newArtist;
    if (totalCount < 100 && likes / totalCount > 0.1) return TagType.emerging;
    if (likes / totalCount > 0.2) return TagType.hot;
    if (likes / totalCount > 0.02) return TagType.emerging;

    return null;
  }

  String getString(BuildContext context) {
    switch (this) {
      case TagType.newArtist:
        return context.i10n.newWord;
      case TagType.hot:
        return context.i10n.hot;
      case TagType.emerging:
        return context.i10n.emerging;
    }
  }

  String getEmoji() {
    switch (this) {
      case TagType.newArtist:
        return '🌟';
      case TagType.hot:
        return '🔥';
      case TagType.emerging:
        return '🌱';
    }
  }
}
