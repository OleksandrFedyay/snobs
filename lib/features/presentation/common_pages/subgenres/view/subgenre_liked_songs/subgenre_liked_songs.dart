import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kingfishertom/core/data/api/models/recommendations/track.dart';
import 'package:kingfishertom/features/presentation/common_pages/subgenres/view/subgenre_liked_songs/cubit/subgenre_liked_songs_cubit.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';
import 'package:kingfishertom/features/utils/extensions/string_ext.dart';
import 'package:kingfishertom/features/utils/snackbar_views.dart';
import 'package:kingfishertom/features/widgets/track_widget.dart';
import 'package:kingfishertom/gen/fonts.gen.dart';

///Constants variables for this widget
const double _kSingleChildScrollViewPaddingLeft = 10;
const double _kSingleChildScrollViewPaddingRight = 10;
const double _kSingleChildScrollViewPaddingBottom = 20;
const double _kSingleChildScrollViewPaddingTop = 0;
const double _kSizedBoxHeight = 40;

///Shows liked subgenre's songs
class SubgenreLikedSongs extends StatelessWidget {
  const SubgenreLikedSongs({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SubgenreLikedSongsCubit, SubgenreLikedSongsState>(
      listener: (BuildContext context, SubgenreLikedSongsState state) {
        if (state
            case SubgenreLikedSongsContentError(:final String errorMessage)) {
          showSuccessSnackBar(context, errorMessage);
        }
      },
      builder: (BuildContext context, SubgenreLikedSongsState state) {
        switch (state) {
          case SubgenreLikedSongsContentLoading():
            return const Center(
              child: CircularProgressIndicator(),
            );
          case SubgenreLikedSongsContentError():
            return const SizedBox.shrink();
          case SubgenreLikedSongsContentData(
              :final List<Track> likedSongs,
              :final String currentArtist,
              :final List<Track>? searchedLikedSongs,
              :final String subgenre,
            ):
            return SizedBox(
              child: searchedLikedSongs == null && likedSongs.isEmpty
                  ? _noItems(context, subgenre)
                  : SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(
                        _kSingleChildScrollViewPaddingLeft,
                        _kSingleChildScrollViewPaddingTop,
                        _kSingleChildScrollViewPaddingRight,
                        _kSingleChildScrollViewPaddingBottom,
                      ),
                      child: Column(
                        children: <Widget>[
                          //initial list of songs
                          if (searchedLikedSongs == null &&
                              likedSongs.isNotEmpty)
                            for (int i = 0; i < likedSongs.length; i++)
                              TrackWidget(
                                trackIndex: i,
                                track: likedSongs[i],
                                active: likedSongs[i].id.toString() ==
                                    currentArtist,
                              ),
                          //if searching was performed but there is no result
                          if (searchedLikedSongs != null &&
                              searchedLikedSongs.isEmpty)
                            Center(
                              child: Text(context.i10n.noResult),
                            ),
                          //if searching was performed and it was successful
                          if (searchedLikedSongs != null &&
                              searchedLikedSongs.isNotEmpty)
                            for (int i = 0; i < searchedLikedSongs.length; i++)
                              TrackWidget(
                                trackIndex: i,
                                track: searchedLikedSongs[i],
                                active: searchedLikedSongs[i].id.toString() ==
                                    currentArtist,
                              ),
                          const SizedBox(height: _kSizedBoxHeight),
                        ],
                      ),
                    ),
            );
        }
      },
    );
  }

  Widget _noItems(BuildContext context, String subgenre) => Align(
        alignment: Alignment.topCenter,
        child: Container(
          height: 90,
          width: double.infinity,
          margin: const EdgeInsets.only(top: 48),
          decoration: BoxDecoration(
            border: Border.all(
              color: lightColorScheme.backgroundGrey,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            spacing: 16,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                context.i10n.noLikedSongs(subgenre.toTitleCase()),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontFamily: FontFamily.nunitoSans,
                ),
              ),
              Text(
                context.i10n.visitArtistPagesToLikeSongs,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                  fontFamily: FontFamily.nunitoSans,
                ),
              ),
            ],
          ),
        ),
      );
}
