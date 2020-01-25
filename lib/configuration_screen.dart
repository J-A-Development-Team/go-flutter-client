import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:web_socket_channel/html.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'Common/data_package.dart';
import 'Common/game_config.dart';
import 'game_screen.dart';

class ConfigurationScreen extends StatefulWidget {
  ConfigurationScreen({Key key}) : super(key: key);

  @override
  _ConfigurationScreenState createState() => _ConfigurationScreenState();
}

class _ConfigurationScreenState extends State<ConfigurationScreen> {
  bool wantsToPlayWithBot = false;
  int boardSize = 0;

  String filePath = 'files/htpg.htm';
  String selectedSize = "5x5";
  var channel = HtmlWebSocketChannel.connect("ws://localhost:8889");

  void sendGameConfig() {
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
    GameConfig gameConfig = new GameConfig(wantsToPlayWithBot, boardSize, false);
    DataPackage dataPackage = new DataPackage(gameConfig, Info.GameConfig);
    String gameConfigDataAsJson = jsonEncode(dataPackage);
    channel.sink.add(gameConfigDataAsJson);
    print(gameConfigDataAsJson);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  DropdownButton(
                    items: <DropdownMenuItem>[
                      new DropdownMenuItem(child: Text("5x5"),  value: "5x5"  ),
                      new DropdownMenuItem(child: Text("9x9"),  value: "9x9"  ),
                      new DropdownMenuItem(child: Text("13x13"),value: "13x13"),
                      new DropdownMenuItem(child: Text("19x19"),value: "19x19"),
                    ],
                    value: selectedSize,
                    onChanged: (value) {
                      setState(() {
                        selectedSize = value;

                      });
                      print(value);
                    },
                  ),
                  Text("Play with bot"),
                  Checkbox(
                      value: wantsToPlayWithBot,
                      onChanged: (bool value) {
                        setState(() {
                          wantsToPlayWithBot = value;
                        });
                      }),
                  OutlineButton(
                    child: Text("Start Game"),
                    onPressed: () => {
                      print("lets play"),
                      sendGameConfig(),
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => GameScreen(
                                    boardSize: boardSize,
                                channel: channel
                                  )))
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 9,
              child: Container(
              ),
            )
          ],
        ),
      ),
    );
  }
}
