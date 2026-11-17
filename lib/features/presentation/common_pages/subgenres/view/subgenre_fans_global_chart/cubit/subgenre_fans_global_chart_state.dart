part of 'subgenre_fans_global_chart_cubit.dart';

sealed class SubgenreFansGlobalChartState extends Equatable {
  const SubgenreFansGlobalChartState();
}

final class SubgenreTopSnobsLoading extends SubgenreFansGlobalChartState {
  const SubgenreTopSnobsLoading();

  @override
  List<Object?> get props => <Object?>[];
}

final class SubgenreTopSnobsData extends SubgenreFansGlobalChartState {
  const SubgenreTopSnobsData({
    required this.topSnobsUsersData,
    this.searchedTopSnobsUsersData,
  });

  final List<UserLikeDto> topSnobsUsersData;
  final List<UserLikeDto>? searchedTopSnobsUsersData;

  @override
  List<Object?> get props => <Object?>[
        topSnobsUsersData,
        searchedTopSnobsUsersData,
      ];
}

final class SubgenreTopSnobsError extends SubgenreFansGlobalChartState {
  const SubgenreTopSnobsError({
    required this.errorMessage,
  });

  final String errorMessage;

  @override
  List<Object?> get props => <Object?>[
        errorMessage,
      ];
}
