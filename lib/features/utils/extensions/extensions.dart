import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:kingfishertom/core/constants/constants.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_chart.dto.dart';
import 'package:kingfishertom/core/data/api/models/dtos/genres.dto.dart';
import 'package:kingfishertom/core/data/api/models/dtos/subgenre_liked.dart';
import 'package:kingfishertom/core/data/api/models/dtos/vote_genre.dart';
import 'package:kingfishertom/core/data/api/models/genre/genre.dart';
import 'package:kingfishertom/core/data/api/models/subgenre/subgenre.dart';
import 'package:kingfishertom/core/data/api/models/user/user_model.dart';
import 'package:kingfishertom/core/data/local_data/swipe_card_data/swipe_card_data_models.dart';
import 'package:kingfishertom/core/domain/repositories/use_cases/get_total_genre_subgenres.use_case.dart';
import 'package:kingfishertom/features/presentation/common_pages/subgenres/enums/genres_enum.dart';
import 'package:kingfishertom/features/presentation/resources/strings_res.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';
import 'package:kingfishertom/features/utils/extensions/string_ext.dart';

extension ArtistsWithPremiumOffer on List<ArtistChartDto> {
  List<ArtistChartDto> artistsWithSwipeCardDataType(bool isHasPremium) {
    final List<ArtistChartDto> artistsWithAds = List<ArtistChartDto>.of(this);

    const List<SwipeCardDataType> cardTypes = SwipeCardDataType.values;

    int currentCardIndex = 0;
    int currentProductIndex = 0;

    /// Loop to insert a card every 20 items
    for (int i = 20; i < artistsWithAds.length; i += 21) {
      /// Get the current card type based on the index
      SwipeCardDataType cardType = cardTypes[currentCardIndex];

      /// Skip the premium and Ads card for premium user
      if (isHasPremium &&
          (cardType == SwipeCardDataType.premium ||
              cardType == SwipeCardDataType.ads)) {
        /// Move to the next card type and continue
        currentCardIndex = (currentCardIndex + 1) % cardTypes.length;
        cardType = cardTypes[currentCardIndex];
      }

      /// Create a new card based on the swipe card type
      final ArtistChartDto cardToInsert =
          _createCardForType(cardType, currentProductIndex);

      artistsWithAds.insert(i, cardToInsert);

      /// Move to the next card type (wrap around if at the end)
      currentCardIndex = (currentCardIndex + 1) % cardTypes.length;

      if (cardType == SwipeCardDataType.product) {
        /// Move to the next product
        currentProductIndex = (currentProductIndex + 1) % productAdCards.length;
      }

      /// Increment i to account for the newly inserted element
      /// The loop continues to calculate the next insertion point correctly, even with the shifting indices
      i++;
    }

    return artistsWithAds;
  }

  /// Method to create cards based on SwipeCardDataType
  ArtistChartDto _createCardForType(
      SwipeCardDataType type, int currentProductIndex) {
    switch (type) {
      case SwipeCardDataType.premium:
        return premiumAdCard;
      case SwipeCardDataType.product:
        return productAdCards[currentProductIndex];
      case SwipeCardDataType.ads:
        return nativeAdCard;
      //Todo(Issa): Will use these in future tasks
/*        case SwipeCardDataType.tip:
        return tipCard;
      case SwipeCardDataType.poll:
        return pollCard;
      case SwipeCardDataType.giveaway:
        return giveawayCard;*/
    }
  }

  /// To remove the premium card from the swipe songs list
  List<ArtistChartDto> get artistsWithOutPremiumOffer {
    final List<ArtistChartDto> artistsWithAds = List<ArtistChartDto>.of(this);

    artistsWithAds
        .removeWhere((ArtistChartDto model) => model == premiumAdCard);

    return artistsWithAds;
  }
}

extension IntegerMethods on int {
  BorderRadiusGeometry borderRadiusSubgenres(ChosenResource resource) {
    if (this == 0) {
      return const BorderRadius.only(
        topLeft: Radius.circular(12),
        bottomLeft: Radius.circular(12),
      );
    } else if (this == 1 && resource == ChosenResource.global) {
      return BorderRadius.zero;
    } else if (this == 1 && resource == ChosenResource.myLiked) {
      return const BorderRadius.only(
        topRight: Radius.circular(12),
        bottomRight: Radius.circular(12),
      );
    } else if (this == 2) {
      return const BorderRadius.only(
        topRight: Radius.circular(12),
        bottomRight: Radius.circular(12),
      );
    }

    return const BorderRadius.only(
      topLeft: Radius.circular(12),
      bottomLeft: Radius.circular(12),
    );
  }

  String get rankNextLevel {
    if (this == 75) {
      return StringsRes.rankFan;
    } else if (this == 500) {
      return StringsRes.rankScout;
    } else if (this == 2000) {
      return StringsRes.rankNerd;
    } else if (this == 5000) {
      return StringsRes.rankSnob;
    } else if (this == 10000) {
      return StringsRes.rankEliteSnob;
    }

    return StringsRes.rankNormie;
  }
}

extension GenresDesc on GenreEnum {
  String get genreDesc {
    switch (this) {
      case GenreEnum.rnb:
        return StringsRes.descRnB;
      case GenreEnum.blues:
        return StringsRes.descBlues;
      case GenreEnum.classical:
        return StringsRes.descClassical;
      case GenreEnum.country:
        return StringsRes.descCountry;
      case GenreEnum.electronic:
        return StringsRes.descElectronic;
      case GenreEnum.hipHop:
        return StringsRes.descHipHop;
      case GenreEnum.jazz:
        return StringsRes.descJazz;
      case GenreEnum.metal:
        return StringsRes.descMetal;
      case GenreEnum.punk:
        return StringsRes.descPunk;
      case GenreEnum.rock:
        return StringsRes.descRock;
      case GenreEnum.latin:
        return StringsRes.descLatin;
      case GenreEnum.worldMusic:
        return StringsRes.descWord;
    }
  }
}

extension TotalGenreSubgenres on List<GenreSubgenresTotal> {
  String genreType({
    required VoteGenre chart,
    required List<GenresDto> subgenresOfGenre,
  }) {
    final String genreString = firstWhereOrNull((GenreSubgenresTotal g) {
          return g.subgenres.any((SubgenreLiked s) {
            return subgenresOfGenre.any((GenresDto genre) {
              final bool isGenre =
                  genre.genre.toLowerCase() == g.genre.toLowerCase();
              final bool isSubgenre =
                  s.subGenre.toLowerCase() == chart.genre.toLowerCase() ||
                      genre.subgenres.contains(chart.genre.toLowerCase());
              return isGenre && isSubgenre;
            });
          });
        })?.genre ??
        '';

    return genreString.toLowerCase();
  }
}

extension GenresItems on List<Genre> {
  String getGenreBySubgenre(String subGenre) {
    final String genreString = firstWhereOrNull((Genre genre) {
          return genre.subgenres.any((Subgenre item) =>
              item.name.toLowerCase() == subGenre.toLowerCase());
        })?.name ??
        '';

    return genreString.toLowerCase();
  }
}

extension BoolValues on bool {
  String getPremiumDetailsText(BuildContext context) {
    if (Platform.isAndroid) {
      return this
          ? context.i10n.subscriptionTrailDetailsGoogle
          : context.i10n.subscriptionPremiumDetailsGoogle;
    }

    return context.i10n.subscriptionAvailableForJust;
  }
}

extension UserModelMethods on UserModel {
  int? get daysLeft => startTrialDate != null
      ? Constants.trialDays + startTrialDate!.difference(DateTime.now()).inDays
      : null;

  bool get isUnCompleteProfileInfo =>
      (name?.isEmpty ?? true) || (zipCode?.isEmpty ?? true);

  int get swipesCount => (skips.length) + (likes.length);

  Map<String, dynamic> toEmailJson() {
    return <String, dynamic>{
      'id': id,
      if (email != null) 'email': email,
      if (name != null) 'name': name,
      if (lastName != null) 'lastName': lastName,
      if (phone != null) 'phone': phone,
      if (imageUrl != null) 'imageUrl': imageUrl,
    };
  }
}

extension ArtistModelDTO on ArtistChartDto {
  ///When the Artis has an null/empty BIO
  String get artistDefaultBio {
    String genres = '';

    if (subgenres.length == 1) {
      genres = subgenres.first.toTitleCase();
    } else if (subgenres.length == 2) {
      genres = '${subgenres[0]} and ${subgenres[1]}'.toTitleCase();
    } else if (subgenres.length > 2) {
      /// Three or more genres
      final String lastGenre = subgenres.last.toTitleCase();
      final String otherGenres =
          subgenres.sublist(0, subgenres.length - 1).join(', ').toTitleCase();
      genres = '$otherGenres, and $lastGenre';
    }

    return '${name.toTitleCase()} is a $genres Artist. ';
  }
}

extension ConstraintsViewSize on BoxConstraints {
  double widthConstraint(double width) => maxWidth * (width / maxWidth);

  double heightConstraint(double height) => maxHeight * (height / maxHeight);
}
