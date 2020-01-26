import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_flutter/customValueChooser.dart';
import 'package:web_socket_channel/html.dart';
import 'Common/data_package.dart';
import 'Common/game_config.dart';
import 'game_screen.dart';

class ConfigurationScreen extends StatefulWidget {
  ConfigurationScreen({Key key}) : super(key: key);

  @override
  _ConfigurationScreenState createState() => _ConfigurationScreenState();
}

class _ConfigurationScreenState extends State<ConfigurationScreen> {
  int boardSize = 0;
  List<String> values = ["5x5", "9x9", "13x13", "19x19"];
  String filePath = 'files/htpg.htm';
  String selectedSize = "5x5";
  var channel = HtmlWebSocketChannel.connect("ws://localhost:8888");

  void sendGameConfig(bool gameWithBot) {
    switch (selectedSize) {
      case "5x5":
        {
          boardSize = 5;
          break;
        }
      case "9x9":
        {
          boardSize = 9;
          break;
        }
      case "13x13":
        {
          boardSize = 13;
          break;
        }
      default:
        {
          boardSize = 19;
          break;
        }
    }
    GameConfig gameConfig = new GameConfig(gameWithBot, boardSize, false);
    DataPackage dataPackage = new DataPackage(gameConfig, Info.GameConfig);
    String gameConfigDataAsJson = jsonEncode(dataPackage);
    channel.sink.add(gameConfigDataAsJson);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomValueChooser(
                  values: values,
                  onSelectedParam: (String param) => {selectedSize = param},
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  constraints: BoxConstraints(maxWidth: 200, minWidth: 200),
                  child: RaisedButton(
                    child: Text("Play With Human"),
                    onPressed: () => {
                      sendGameConfig(false),
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => GameScreen(
                                  boardSize: boardSize, channel: channel)))
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  constraints: BoxConstraints(maxWidth: 200, minWidth: 200),
                  child: RaisedButton(
                    child: Text("Play With Bot"),
                    onPressed: () => {
                      sendGameConfig(true),
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => GameScreen(
                                  boardSize: boardSize, channel: channel)))
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
