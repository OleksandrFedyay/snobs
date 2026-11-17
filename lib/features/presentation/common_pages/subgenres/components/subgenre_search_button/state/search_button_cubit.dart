import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:kingfishertom/core/services/base/base_cubit.dart';
import 'package:kingfishertom/features/presentation/common_pages/subgenres/cubit/subgenres_page_cubit.dart';
import 'package:kingfishertom/features/presentation/common_pages/subgenres/enums/genres_enum.dart';
import 'package:kingfishertom/features/utils/extensions/cubit_stream_with_current_state.dart';

part 'search_button_state.dart';

class SearchButtonCubit extends BaseCubit<SearchFieldState> {
  SearchButtonCubit({required SubgenrePageCubit subgenrePageCubit})
      : _subgenreCubit = subgenrePageCubit,
        super(const SearchFieldLoadingState()) {
    _parentStateSubscription = _subgenreCubit.streamWithCurrentState.listen(
      (SubgenrePageState e) => _onParentStateChange(
        subgenrePageSate: e,
      ),
    );
  }

  final SubgenrePageCubit _subgenreCubit;
  late final StreamSubscription<SubgenrePageState> _parentStateSubscription;

  ///Listens to its parent's state: [SubgenrePageState]
  Future<void> _onParentStateChange({
    required SubgenrePageState subgenrePageSate,
  }) async {
    if (subgenrePageSate.status != SubgenrePageStatus.initial) {
      if (subgenrePageSate.status == SubgenrePageStatus.loading) {
        emit(const SearchFieldLoadingState());
      }
      if (subgenrePageSate.status == SubgenrePageStatus.error) {
        emit(SearchFieldErrorState(error: subgenrePageSate.errorMessage));
      }
      return;
    }

    if (subgenrePageSate.toggleButtonIndex == 0 &&
        subgenrePageSate.chosenResource == ChosenResource.myLiked) {
      emit(const SearchFieldForMyLikedArtists());
    } else if (subgenrePageSate.toggleButtonIndex == 0 &&
        subgenrePageSate.chosenResource == ChosenResource.global) {
      emit(const SearchFieldForArtistGlobalCharts());
    } else if (subgenrePageSate.toggleButtonIndex == 1 &&
        subgenrePageSate.chosenResource == ChosenResource.myLiked) {
      emit(const SearchFieldForMyLikedSongs());
    } else if (subgenrePageSate.toggleButtonIndex == 1 &&
        subgenrePageSate.chosenResource == ChosenResource.global) {
      emit(const SearchFieldForGlobalChartsSong());
    } else if (subgenrePageSate.toggleButtonIndex == 2) {
      emit(const SearchFieldForTopSnobsState());
    }
  }

  @override
  Future<void> close() async {
    await _parentStateSubscription.cancel();
    await super.close();
  }

  @override
  void handleError(String errorMessage) {
    emit(SearchFieldErrorState(error: errorMessage));
  }
}
