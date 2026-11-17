import 'package:json_annotation/json_annotation.dart';
import 'package:kingfishertom/core/data/api/models/dtos/artist_subgenres_status.dart';

part 'artist_subgenres.g.dart';

@JsonSerializable()
class ArtistSubgenres {
  const ArtistSubgenres({
    this.artistId = '',
    this.subgenres = const <String>[],
    this.status = ArtistSubgenresStatus.newStatus,
    this.userId = '',
  });

  factory ArtistSubgenres.fromJson(Map<String, dynamic> json) =>
      _$ArtistSubgenresFromJson(json);
  final String artistId;
  final List<String> subgenres;
  @JsonKey(
    fromJson: ArtistSubgenresStatus.fromJson,
    toJson: ArtistSubgenresStatus.toJson,
  )
  final ArtistSubgenresStatus status;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final String userId;

  Map<String, dynamic> toJson() => _$ArtistSubgenresToJson(this);

  ArtistSubgenres copyWith({
    String? artistId,
    List<String>? subgenres,
    ArtistSubgenresStatus? status,
    String? userId,
  }) {
    return ArtistSubgenres(
      artistId: artistId ?? this.artistId,
      subgenres: subgenres ?? this.subgenres,
      status: status ?? this.status,
      userId: userId ?? this.userId,
    );
  }
}
