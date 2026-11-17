import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'subgenre.g.dart';

/// Subgenre Model
@JsonSerializable()
class Subgenre extends Equatable {
  const Subgenre({
    required this.id,
    required this.genreId,
    required this.name,
    required this.description,
    required this.enabled,
  });

  factory Subgenre.fromJson(Map<String, dynamic> json) {
    /// Performing validation on the key fields and the data types of their values.
    /// If the desired key is not found in the Map<String, dynamic>,
    /// it will return null, which will not pass the subsequent check.
    if (json
        case {
          'id': int _,
          'genreId': int _,
          'name': String _,
          'description': String _,
          'enabled': bool _,
        }) {
      return _$SubgenreFromJson(json);
    } else {
      throw FormatException('Invalid JSON: $json');
    }
  }

  Map<String, dynamic> toJson() => _$SubgenreToJson(this);

  final int id;
  final int genreId;
  final String name;
  final String description;
  final bool enabled;

  @override
  List<Object?> get props => <Object?>[
        id,
        genreId,
        name,
        description,
        enabled,
      ];

  @override
  String toString() {
    final StringBuffer sb = StringBuffer()
      ..write('Subgenre id: $id, genreId: $genreId, name: $name, ')
      ..write('description: $description, ')
      ..write('enabled: $enabled, ');
    return sb.toString();
  }
}
