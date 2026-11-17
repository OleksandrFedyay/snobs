import 'package:injectable/injectable.dart';
import 'package:kingfishertom/core/data/api/models/dtos/badge.dto.dart';
import 'package:kingfishertom/core/data/data_sources/remote.badge.data_source.dart';
import 'package:kingfishertom/core/domain/exception/base_exception_service.dart';

@injectable
class GetBadgesUseCase extends BaseExceptionService {
  GetBadgesUseCase(this.remoteBadgeDataSource);

  final RemoteBadgeDataSource remoteBadgeDataSource;

  Future<List<BadgeDto>> call() async {
    return makeErrorParsedCall(() async {
      return remoteBadgeDataSource.getBadges();
    });
  }
}
