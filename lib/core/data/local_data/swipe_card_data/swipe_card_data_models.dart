import 'package:kingfishertom/core/data/api/models/dtos/artist_chart.dto.dart';
import 'package:kingfishertom/features/presentation/resources/strings_res.dart';
import 'package:kingfishertom/gen/assets.gen.dart';

enum SwipeCardDataType {
  premium,
  product,
 ads,
  /*  tip,
  poll,
  giveaway,*/
}

///Global ArtistChartDto Premium Ad Card
const ArtistChartDto premiumAdCard = ArtistChartDto(
  id: StringsRes.premiumAdsId,
  name: StringsRes.snobsPremium,
);

///Global ArtistChartDto Product Ad Card
List<ArtistChartDto> productAdCards = <ArtistChartDto>[
  ///Sony WH-CH720N
  ArtistChartDto(
    id: StringsRes.productAdId,
    name: StringsRes.sonyWHCH720N,
    productLink: 'https://amzn.to/49SwiFR',
    image: Assets.images.sonyWhCh720n.path,
    bio: StringsRes.sonyWHCH720NDesc,
    productEventName: StringsRes.sonyWHCH720NEventName,
  ),
  ///Anker Soundcore 2
  ArtistChartDto(
    id: StringsRes.productAdId,
    name: StringsRes.ankeSoundcore2,
    productLink: 'https://amzn.to/4gDoFW6',
    image: Assets.images.ankerSoundcore2.path,
    bio: StringsRes.ankeSoundcore2Desc,
    productEventName: StringsRes.ankeSoundcore2EventName,
  ),
  ///AF Prod 3
  ArtistChartDto(
    id: StringsRes.productAdId,
    name: StringsRes.aFProd3,
    productLink: 'https://amzn.to/426EjF9',
    image: Assets.images.afProd3.path,
    bio: StringsRes.aFProd3Desc,
    productEventName: StringsRes.aFProd3EventName,
  ),
];

///Global ArtistChartDto native Ad Card
const ArtistChartDto nativeAdCard = ArtistChartDto(
  id: StringsRes.nativeAdItemId,
  name: 'Native Ad',
);
