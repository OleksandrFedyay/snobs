import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'track.g.dart';

@JsonSerializable()
class Track extends Equatable {
  const Track({
    required this.displayArtists,
    required this.title,
    required this.id,
    required this.url,
    this.art = '',
    this.likes = const <String>[],
    this.artists = const <int>[],
  });

  factory Track.fromJson(Map<String, dynamic> json) {
    return _$TrackFromJson(json);
  }
  final int id;
  final String displayArtists;
  final String title;
  final String url;
  final List<String> likes;
  final List<int> artists;
  final String art;

  Map<String, dynamic> toJson() => _$TrackToJson(this);

  @override
  List<Object> get props {
    return <Object>[
      id,
      displayArtists,
      title,
      url,
      likes,
      artists,
      art,
    ];
  }

  Track copyWith({
    int? id,
    String? displayArtists,
    String? title,
    String? url,
    List<String>? likes,
    List<int>? artists,
    String? art,
  }) {
    return Track(
      id: id ?? this.id,
      displayArtists: displayArtists ?? this.displayArtists,
      title: title ?? this.title,
      url: url ?? this.url,
      likes: likes ?? this.likes,
      artists: artists ?? this.artists,
      art: art ?? this.art,
    );
  }
}
