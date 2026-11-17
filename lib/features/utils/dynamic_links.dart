import 'dart:developer';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_collection.dto.dart';
import 'package:kingfishertom/features/presentation/resources/routing/snobs_router.dart';

class DynamicLinkProvider {
  Future<String> createLink(String userId, String collectName) async {
    final String url =
        'https://com.kingfishertom.snobs?id=$userId&name=$collectName';

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      androidParameters: const AndroidParameters(
        packageName: 'com.kingfishertom.snobs',
      ),
      iosParameters: const IOSParameters(bundleId: 'com.kingfishertom.snobs'),
      link: Uri.parse(url),
      uriPrefix: 'https://kingfishertom.page.link',
    );

    // ignore_for_file: deprecated_member_use
    final FirebaseDynamicLinks link = FirebaseDynamicLinks.instance;
    final Uri refLink = await link.buildLink(parameters);
    return refLink.toString();
  }

  Future<void> initDynamicLink() async {
    final PendingDynamicLinkData? instanceLink = await FirebaseDynamicLinks.instance.getInitialLink();

    if (instanceLink != null) _handleLink(instanceLink.link);

    FirebaseDynamicLinks.instance.onLink.listen((PendingDynamicLinkData dynamicLinkData) {
      _handleLink(dynamicLinkData.link);
    }).onError((dynamic error) {
      log('This is exception >>> $error');
    });
  }

  void _handleLink(Uri link) {
    final Map<String, String> parameters = link.queryParameters;

    router.pushMyLikedArtistRoute(
      ArtistCollectionDto(name: parameters['name'] ?? ''),
      delete: false,
      userId: parameters['id'],
      exploreSubgenre: (_,__){},
    );
  }
}
