import 'dart:core';

import 'package:json_annotation/json_annotation.dart';

part 'game_config.g.dart';

@JsonSerializable()

class GameConfig {
  bool withBot;
  int boardSize;
  bool wantsToStart;

  GameConfig(this.withBot, this.boardSize, this.wantsToStart);
  factory GameConfig.fromJson(Map<String, dynamic> json) => _$GameConfigFromJson(json);
  Map<String, dynamic> toJson() => _$GameConfigToJson(this);


  bool checkIfValid() {
    switch (boardSize) {
      case 5:
      case 9:
      case 13:
      case 19:
        return true;
      default:
        return false;
    }
  }
}
