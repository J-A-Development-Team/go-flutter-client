import 'dart:convert';

import 'package:dialog/dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_flutter/Common/territory_states.dart';
import 'package:web_socket_channel/html.dart';
import 'Common/data_package.dart';
import 'Common/intersection.dart';

class GameScreen extends StatefulWidget {
  final int boardSize;
  final HtmlWebSocketChannel channel;

  GameScreen({this.boardSize, this.channel});

  @override
  GameScreenState createState() => GameScreenState();
}

class GameScreenState extends State<GameScreen> {
  bool isYourTurn = false;
  bool playerColor = false;
  String turn = "";
  int points = 0;
  List<List<Intersection>> boardState = List.generate(
    19,
    (i) => List<Intersection>.generate(
        19, (j) => new Intersection.withStone(i, j, false, false)),
  );
  List<List<TerritoryStates>> territoryStates = List.generate(
    19,
    (i) => List<TerritoryStates>.generate(19, (j) => TerritoryStates.Unknown),
  );
  var media;

  void generateBoardState() {
    for (int i = 0; i < widget.boardSize; i++) {
      for (int j = 0; j < widget.boardSize; j++) {
        boardState[i][j] = new Intersection.withStone(i, j, false, false);
      }
    }
  }

  void cellClicked(int x, int y) {
    if (isYourTurn) {
      Intersection intersection =
          new Intersection.withStone(x, y, true, playerColor);
      DataPackage dataPackage = new DataPackage(intersection, Info.Stone);
      String message = jsonEncode(dataPackage);
      widget.channel.sink.add(message);
    }
  }

  void updateTable(DataPackage dataPackage) {
    for (int i = 0; widget.boardSize > i; i++) {
      for (int j = 0; widget.boardSize > j; j++) {
        setState(() {
          boardState[j][i] =
              Intersection.fromJson(jsonDecode(dataPackage.data)[j][i]);
        });
      }
    }
  }

  void showInfoDialog(String info) {
    alert(info);
  }

  Widget getRowItem(int x, int y) {
    return GestureDetector(
      onTap: () {
        cellClicked(x, y);
      },
      child: Container(
        constraints: new BoxConstraints(
          minHeight: media / (widget.boardSize + 1),
          minWidth: media / (widget.boardSize + 1),
          maxHeight: media / (widget.boardSize + 1),
          maxWidth: media / (widget.boardSize + 1),
        ),
        color: Color.fromRGBO(224, 172, 105, 100),
        //color: Colors.red,
        child: CustomPaint(
          size: Size(
              media / (widget.boardSize + 1), media / (widget.boardSize + 1)),
          painter: CellPainter(
              intersection: boardState[x][y],
              boardSize: widget.boardSize,
              territoryState: territoryStates[x][y]),
        ),
      ),
    );
  }

  TableRow getTableRow(int size, int y) {
    List<Widget> rowItems = new List(size);
    for (int i = 0; i < size; i++) {
      rowItems[i] = (getRowItem(i, y));
    }
    return TableRow(children: rowItems);
  }

  List<TableRow> getTableRowList(int size) {
    List<TableRow> rows = new List(size);
    for (int i = 0; i < size; i++) {
      rows[i] = getTableRow(size, i);
    }
    return rows;
  }

  Table generateGameBoard(int size) {
    return Table(
      children: getTableRowList(size),
      defaultColumnWidth: FixedColumnWidth(media / (widget.boardSize + 1)),
    );
  }

  _onGameDataReceived(serverMessage) {
    DataPackage data;
    Map message = json.decode(serverMessage);
    data = new DataPackage.fromJson(message);
    switch (data.info) {
      case Info.Stone:
        // TODO: Handle this case.
        break;
      case Info.StoneTable:
        updateTable(data);
        break;
      case Info.PlayerColor:
        if (data.data == "black") {
          playerColor = true;
        }
        break;
      case Info.InfoMessage:
        showInfoDialog(data.data);
        break;
      case Info.Pass:
        showInfoDialog(data.data);
        break;
      case Info.Turn:
        setState(() {
          turn = data.data;
        });
        if (turn == "Your turn" || turn == "Remove Dead Stones") {
          isYourTurn = true;
        } else {
          isYourTurn = false;
          print(turn);
        }
        break;
      case Info.Points:
        setState(() {
          points = data.data;
        });
        break;
      case Info.TerritoryTable:
        updateTerritory(data);
        break;
      case Info.GameConfig:
        // TODO: Handle this case.
        break;
      case Info.GameResult:
        showInfoDialog(data.data);

        break;
    }
  }

  void updateTerritory(DataPackage dataPackage) {
    for (int i = 0; widget.boardSize > i; i++) {
      for (int j = 0; widget.boardSize > j; j++) {
        setState(() {
          territoryStates[i][j] =
              decodeTerritory(territoryMap, jsonDecode(dataPackage.data)[i][j]);
        });
      }
    }
  }

  void sendPass() {
    if (isYourTurn) {
      DataPackage dataPackage = new DataPackage(0, Info.Pass);
      String message = jsonEncode(dataPackage);
      widget.channel.sink.add(message);
    }
  }

  @override
  void initState() {
    widget.channel.stream.listen(_onGameDataReceived);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    media = MediaQuery.of(context).size.height;
    if (MediaQuery.of(context).size.width < media) {
      media = MediaQuery.of(context).size.width;
    }
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Prisoners: $points"),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(turn),
                ),
                OutlineButton(
                  child: Text("Pass"),
                  onPressed: () {
                    sendPass();
                  },
                )
              ],
            ),
            Center(
              child: Container(
                child: generateGameBoard(widget.boardSize),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CellPainter extends CustomPainter {
  final Intersection intersection;
  final int boardSize;
  final TerritoryStates territoryState;

  CellPainter({this.intersection, this.boardSize, this.territoryState});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    Offset left;
    Offset right;
    Offset top;
    Offset bottom;
    if (intersection.xCoordinate == 0) {
      left = new Offset(size.width / 2, size.height / 2);
    } else {
      left = new Offset(0, size.height / 2);
    }
    if (intersection.yCoordinate == 0) {
      top = new Offset(size.width / 2, size.height / 2);
    } else {
      top = new Offset(size.width / 2, 0);
    }
    if (intersection.xCoordinate == boardSize - 1) {
      right = new Offset(size.width / 2, size.height / 2);
    } else {
      right = new Offset(size.width, size.height / 2);
    }
    if (intersection.yCoordinate == boardSize - 1) {
      bottom = new Offset(size.width / 2, size.height / 2);
    } else {
      bottom = new Offset(size.width / 2, size.height);
    }
    canvas.drawLine(top, bottom, paint);
    canvas.drawLine(left, right, paint);
    if (!intersection.isStoneBlack) {
      paint.color = Colors.white;
    }
    if (intersection.isStoneDead) {
      paint.color = paint.color.withAlpha(128);
    }
    if (intersection.hasStone) {
      canvas.drawCircle(Offset(size.width / 2, size.height / 2),
          (size.height / 2) - (size.height * 0.01), paint);
    }
    if (territoryState == TerritoryStates.BlackTerritory) {
      paint.color = Colors.black;
      canvas.drawRect(
          Rect.fromCenter(
              center: Offset(size.width / 2, size.height / 2),
              width: size.width / 2,
              height: size.height / 2),
          paint);
    } else if (territoryState == TerritoryStates.WhiteTerritory) {
      paint.color = Colors.white;
      canvas.drawRect(
          Rect.fromCenter(
              center: Offset(size.width / 2, size.height / 2),
              width: size.width / 2,
              height: size.height / 2),
          paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}
