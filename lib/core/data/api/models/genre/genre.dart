import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:kingfishertom/core/data/api/models/subgenre/subgenre.dart';

part 'genre.g.dart';

///Genre Model
@JsonSerializable(explicitToJson: true)
class Genre extends Equatable {
  const Genre({
    required this.id,
    required this.name,
    required this.description,
    required this.enabled,
    required this.subgenres,
  });

  factory Genre.fromJson(Map<String, dynamic> json) {
    /// Performing validation on the key fields and the data types of their values.
    /// If the desired key is not found in the Map<String, dynamic>,
    /// it will return null, which will not pass the subsequent check.
    if (json
        case {
          'id': int _,
          'name': String _,
          'description': String _,
          'enabled': bool _,
          'subgenres': List<dynamic> _,
        }) {
      return _$GenreFromJson(json);
    } else {
      throw FormatException('Invalid JSON: $json');
    }
  }

  Map<String, dynamic> toJson() => _$GenreToJson(this);

  final int id;
  final String name;
  final String description;
  final bool enabled;
  final List<Subgenre> subgenres;

  @override
  List<Object?> get props => <Object?>[
        enabled,
        id,
        name,
        description,
        subgenres,
      ];

  @override
  String toString() {
    final StringBuffer sb = StringBuffer()
      ..write('Genre id: $id, name: $name, ')
      ..write('description: $description, ')
      ..write('enabled: $enabled, subgenres: $subgenres');
    return sb.toString();
  }
}
