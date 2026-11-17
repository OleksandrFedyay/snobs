import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kingfishertom/core/data/api/models/dtos/user_like_dto.dart';
import 'package:kingfishertom/features/presentation/common_pages/subgenres/view/subgenre_fans_global_chart/components/top_snob_tile.dart';
import 'package:kingfishertom/features/presentation/common_pages/subgenres/view/subgenre_fans_global_chart/cubit/subgenre_fans_global_chart_cubit.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';
import 'package:kingfishertom/features/utils/snackbar_views.dart';

class SubgenreFansGlobalChart extends StatelessWidget {
  const SubgenreFansGlobalChart({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SubgenreFansGlobalChartCubit,
        SubgenreFansGlobalChartState>(
      listener: (BuildContext context, SubgenreFansGlobalChartState state) {
        if (state case SubgenreTopSnobsError(:final String errorMessage)) {
          showSuccessSnackBar(context, errorMessage);
        }
      },
      builder: (BuildContext context, SubgenreFansGlobalChartState state) {
        switch (state) {
          case SubgenreTopSnobsLoading():
            return const Center(
              child: CircularProgressIndicator(),
            );
          case SubgenreTopSnobsError():
            return const SizedBox();
          case SubgenreTopSnobsData(
              :final List<UserLikeDto> topSnobsUsersData,
              :final List<UserLikeDto>? searchedTopSnobsUsersData,
            ):
            return topSnobsUsersData.isEmpty
                ? Center(
                    child: Text(
                      context.i10n.noItems,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                    child: Column(
                      children: <Widget>[
                        if (searchedTopSnobsUsersData == null)
                          for (final UserLikeDto snobUserData
                              in topSnobsUsersData)
                            TopSnobTile(snobUserData: snobUserData),
                        if (searchedTopSnobsUsersData != null &&
                            searchedTopSnobsUsersData.isEmpty)
                          Center(
                            child: Text(context.i10n.noResult),
                          ),
                        if (searchedTopSnobsUsersData != null &&
                            searchedTopSnobsUsersData.isNotEmpty)
                          for (final UserLikeDto snobUserData
                              in searchedTopSnobsUsersData)
                            TopSnobTile(snobUserData: snobUserData),
                      ],
                    ),
                  );
        }
      },
    );
  }
}
