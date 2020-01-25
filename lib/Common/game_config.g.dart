// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameConfig _$GameConfigFromJson(Map<String, dynamic> json) {
  return GameConfig(
    json['withBot'] as bool,
    json['boardSize'] as int,
    json['wantsToStart'] as bool,
  );
}

Map<String, dynamic> _$GameConfigToJson(GameConfig instance) =>
    <String, dynamic>{
      'withBot': instance.withBot,
      'boardSize': instance.boardSize,
      'wantsToStart': instance.wantsToStart,
    };
