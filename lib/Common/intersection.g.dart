// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'intersection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Intersection _$IntersectionFromJson(Map<String, dynamic> json) {
  return Intersection(
    json['xCoordinate'] as int,
    json['yCoordinate'] as int,
  )
    ..isStoneBlack = json['isStoneBlack'] as bool
    ..hasStone = json['hasStone'] as bool
    ..isStoneDead = json['isStoneDead'] as bool;
}

Map<String, dynamic> _$IntersectionToJson(Intersection instance) =>
    <String, dynamic>{
      'xCoordinate': instance.xCoordinate,
      'yCoordinate': instance.yCoordinate,
      'isStoneBlack': instance.isStoneBlack,
      'hasStone': instance.hasStone,
      'isStoneDead': instance.isStoneDead,
    };
