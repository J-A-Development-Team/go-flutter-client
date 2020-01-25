import 'package:json_annotation/json_annotation.dart';

part 'intersection.g.dart';

@JsonSerializable()
class Intersection{
  int xCoordinate;
  int yCoordinate;
  bool isStoneBlack;
  bool hasStone;
  bool isStoneDead = false;

  Intersection(this.xCoordinate, this.yCoordinate);
  factory Intersection.fromJson(Map<String, dynamic> json) => _$IntersectionFromJson(json);
  Map<String, dynamic> toJson() => _$IntersectionToJson(this);
  Intersection.withStone(this.xCoordinate, this.yCoordinate, this.hasStone,this.isStoneBlack);


}