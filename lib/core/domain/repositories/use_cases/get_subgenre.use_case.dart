import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/data/api/models/dtos/subgenre_liked.dart';
import 'package:kingfishertom/core/data/data_sources/remote.like_genre.data_source.dart';
import 'package:kingfishertom/core/data/local_data/local.genres_info.data_source.impl.dart';
import 'package:kingfishertom/core/domain/exception/base_exception_service.dart';

@injectable
class GetSubgenreUseCase extends BaseExceptionService {
  GetSubgenreUseCase(
    RemoteLikeGenreDataSource likeGenreDataSource,
    LocalGenresInfoDataSourceImpl localGenresInfoDataSourceImpl,
  )   : _likeGenreDataSource = likeGenreDataSource,
        _localGenresInfoDataSourceImpl = localGenresInfoDataSourceImpl;
  final RemoteLikeGenreDataSource _likeGenreDataSource;
  final LocalGenresInfoDataSourceImpl _localGenresInfoDataSourceImpl;

  Future<List<SubgenreLiked>> call({bool? updateInfo}) async {
    return makeErrorParsedCall(() async {
      if (updateInfo ?? false) {
        final List<SubgenreLiked> subgenres =
            await _likeGenreDataSource.getLikeGenreDto();
        await _localGenresInfoDataSourceImpl.setSubgenre(subgenres);
        return subgenres;
      }
      final List<SubgenreLiked> subgenres =
          _localGenresInfoDataSourceImpl.getSubgenres();
      if (subgenres.isEmpty) return _likeGenreDataSource.getLikeGenreDto();

      return subgenres;
    });
  }
}
