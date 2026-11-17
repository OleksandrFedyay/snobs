import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:kingfishertom/core/data/api/models/dtos/user_like_dto.dart';
import 'package:kingfishertom/core/services/base/base_cubit.dart';
import 'package:kingfishertom/features/presentation/common_pages/subgenres/cubit/subgenres_page_cubit.dart';
import 'package:kingfishertom/features/presentation/common_pages/subgenres/enums/genres_enum.dart';
import 'package:kingfishertom/features/utils/extensions/cubit_stream_with_current_state.dart';

part 'subgenre_fans_global_chart_state.dart';

class SubgenreFansGlobalChartCubit
    extends BaseCubit<SubgenreFansGlobalChartState> {
  SubgenreFansGlobalChartCubit({
    required SubgenrePageCubit subgenrePageCubit,
  })  : _subgenrePageCubit = subgenrePageCubit,
        super(const SubgenreTopSnobsLoading()) {
    _parentStateSubscription = _subgenrePageCubit.streamWithCurrentState.listen(
      (SubgenrePageState e) => _onParentStateChange(
        subgenrePageState: e,
      ),
    );
  }

  final SubgenrePageCubit _subgenrePageCubit;
  late final StreamSubscription<SubgenrePageState> _parentStateSubscription;

  Future<void> _onParentStateChange({
    required SubgenrePageState subgenrePageState,
  }) async {
    if (subgenrePageState.statusFans != SubgenreFansPageStatus.initial) {
      if (subgenrePageState.statusFans == SubgenreFansPageStatus.loading) {
        emit(const SubgenreTopSnobsLoading());
      }
      if (subgenrePageState.statusFans == SubgenreFansPageStatus.error) {
        emit(
          SubgenreTopSnobsError(errorMessage: subgenrePageState.errorMessage),
        );
      }
      return;
    }
    emit(SubgenreTopSnobsData(
        topSnobsUsersData: subgenrePageState.topSnobsUsers));
  }

  Future<void> searchTopSnobs(String? query) async {
    if (query == null || query.isEmpty) {
      emit(
        SubgenreTopSnobsData(
          topSnobsUsersData: _subgenrePageCubit.state.topSnobsUsers,
        ),
      );
    } else {
      final SubgenreTopSnobsData initialData = state as SubgenreTopSnobsData;
      final List<UserLikeDto> searchedMyLikedArtist =
          initialData.topSnobsUsersData.where((UserLikeDto e) {
        if (e.user.name != null) {
          final bool result = e.user.name!.toLowerCase().startsWith(
                query.toLowerCase(),
              );
          if (result) {
            return result;
          } else {
            if (e.user.lastName != null) {
              return e.user.lastName!.toLowerCase().startsWith(
                    query.toLowerCase(),
                  );
            }
          }
        }
        return false;
      }).toList();

      emit(
        SubgenreTopSnobsData(
          searchedTopSnobsUsersData: searchedMyLikedArtist,
          topSnobsUsersData: _subgenrePageCubit.state.topSnobsUsers,
        ),
      );
    }
  }

  Future<void> cancelTopSnobsSearching() async {
    emit(
      SubgenreTopSnobsData(
        topSnobsUsersData: _subgenrePageCubit.state.topSnobsUsers,
      ),
    );
  }

  @override
  Future<void> close() async {
    await _parentStateSubscription.cancel();
    await super.close();
  }

  @override
  void handleError(String errorMessage) {
    emit(SubgenreTopSnobsError(errorMessage: errorMessage));
  }
}
