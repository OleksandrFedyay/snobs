import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kingfishertom/core/data/api/models/recommendations/track.dart';
import 'package:kingfishertom/features/presentation/common_pages/subgenres/view/subgenre_songs_global_charts/cubit/subgenre_songs_chart_cubit.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';
import 'package:kingfishertom/features/utils/snackbar_views.dart';
import 'package:kingfishertom/features/widgets/track_widget.dart';

///Constants variables for this widget
const double _kSingleChildScrollViewPaddingLeft = 10;
const double _kSingleChildScrollViewPaddingRight = 10;
const double _kSingleChildScrollViewPaddingBottom = 20;
const double _kSingleChildScrollViewPaddingTop = 0;
const double _kSizedBoxHeight = 40;

///Shows global charts songs
class SubgenreSongsGlobalChart extends StatelessWidget {
  const SubgenreSongsGlobalChart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SubgenreSongsGlobalChartCubit,
        SubgenreSongsGlobalChartState>(
      listener:
          (BuildContext context, SubgenreSongsGlobalChartState state) {
        if (state
            case SubgenreSongsGlobalChartsContentError(
              :final String errorMessage
            )) {
          showSuccessSnackBar(context, errorMessage);
        }
      },
      builder:
          (BuildContext context, SubgenreSongsGlobalChartState state) {
        switch (state) {
          case SubgenreSongsGlobalChartsContentLoading():
            return const Center(
              child: CircularProgressIndicator(),
            );
          case SubgenreSongsGlobalChartsContentError():
            return const SizedBox();
          case SubgenreSongsGlobalChartsContentData(
              :final List<Track> songsCharts,
              :final String currentArtist,
              :final List<Track>? searchedSongsCharts,
            ):
            return songsCharts.isEmpty && currentArtist.isEmpty
                ? Center(
                    child: Text(
                      context.i10n.noItems,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    ),
                  )
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
                        if (searchedSongsCharts == null)
                          for (int i = 0; i < songsCharts.length; i++)
                            TrackWidget(
                              active:
                                  songsCharts[i].id.toString() == currentArtist,
                              track: songsCharts[i],
                              trackIndex: i,
                              withBubble: true,
                            ),
                        const SizedBox(height: _kSizedBoxHeight),
                        //if searching was performed but there is no result
                        if (searchedSongsCharts != null &&
                            searchedSongsCharts.isEmpty)
                          Center(
                            child: Text(context.i10n.noResult),
                          ),
                        //if searching was performed and it was successful
                        if (searchedSongsCharts != null &&
                            searchedSongsCharts.isNotEmpty)
                          for (int i = 0; i < searchedSongsCharts.length; i++)
                            TrackWidget(
                              active: searchedSongsCharts[i].id.toString() ==
                                  currentArtist,
                              track: searchedSongsCharts[i],
                              trackIndex: i,
                              withBubble: true,
                            ),
                        const SizedBox(height: _kSizedBoxHeight),
                      ],
                    ),
                  );
        }
      },
    );
  }
}
