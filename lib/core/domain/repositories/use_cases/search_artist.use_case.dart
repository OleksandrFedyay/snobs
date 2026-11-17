import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_chart.dto.dart';
import 'package:kingfishertom/core/data/data_sources/remote.artist_chart.data_source.dart';
import 'package:kingfishertom/core/domain/exception/base_exception_service.dart';

@injectable
class SearchArtistUseCase extends BaseExceptionService {
  SearchArtistUseCase(
    this.remoteArtistChartDataSource,
  );

  final RemoteArtistChartDataSource remoteArtistChartDataSource;

  Future<List<ArtistChartDto>> call(String query) async {
    return makeErrorParsedCall(() async {
      return remoteArtistChartDataSource.searchArtists(query);
    });
  }
}
