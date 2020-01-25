import 'package:enum_to_string/enum_to_string.dart';
import 'package:json_annotation/json_annotation.dart';
part 'data_package.g.dart';
@JsonSerializable()

class DataPackage {
  Object data;
  Info info;

  DataPackage(this.data, this.info);
  factory DataPackage.fromJson(Map<String, dynamic> json) => _$DataPackageFromJson(json);
  Map<String, dynamic> toJson() => _$DataPackageToJson(this);
}
enum Info {
  Stone, StoneTable, PlayerColor, InfoMessage, Pass, Turn, Points, TerritoryTable, GameConfig, GameResult
}
