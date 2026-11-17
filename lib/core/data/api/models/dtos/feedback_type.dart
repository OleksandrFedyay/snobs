import 'package:flutter/material.dart';

import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';

enum FeedbackType {
  reportIssue,
  feature,
  artistIssue,
  missingArtist,
  support,
  subgenreRequest;

  static String toJson(FeedbackType type) => type.name;

  String getTitle(BuildContext context) {
    switch (this) {
      case FeedbackType.feature:
        return context.i10n.requestFeature;
      case FeedbackType.reportIssue:
        return context.i10n.reportAnIssue;
      case FeedbackType.artistIssue:
        return context.i10n.artistIssue;
      case FeedbackType.missingArtist:
        return context.i10n.missingArtist;
      case FeedbackType.support:
        return context.i10n.support;
      case FeedbackType.subgenreRequest:
        return context.i10n.subgenreRequest;
    }
  }
}
