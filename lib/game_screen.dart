import 'dart:convert';

import 'package:flutter/material.dart';
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
  var media;

  void generateBoardState() {
    for (int i = 0; i < widget.boardSize; i++) {
      for (int j = 0; j < widget.boardSize; j++) {
        boardState[i][j] = new Intersection.withStone(i, j, false, false);
      }
    }
  }



  void cellClicked(int x, int y) {
      Intersection intersection = new Intersection.withStone(
          x, y, true, playerColor);
      DataPackage dataPackage = new DataPackage(intersection, Info.Stone);
      String message = jsonEncode(dataPackage);
      widget.channel.sink.add(message);
      print("$x $y");

  }

  void updateTable(DataPackage dataPackage) {
    print(dataPackage.data);
    for(int i=0;widget.boardSize>i;i++){
      for(int j=0;widget.boardSize>j;j++){
        boardState[j][i] = Intersection.fromJson(jsonDecode(dataPackage.data)[j][i]);
      }
    }
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
          painter: CellPainter(boardState[x][y]),
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

  _onGameDataReceived(servermessage) {
    DataPackage data;
    Map message = json.decode(servermessage);
    data = new DataPackage.fromJson(message);
    print("TO jest info: ${data.info}");
    switch (data.info) {
      case Info.Stone:
        // TODO: Handle this case.
        break;
      case Info.StoneTable:
        print("Got Table Info");

        {
          updateTable(data);
        }
        break;
      case Info.PlayerColor:
        print("Got Player COlor Info");

        if (data.data == "black") {
          playerColor = true;
        }
        break;
      case Info.InfoMessage:
        // TODO: Handle this case.
        break;
      case Info.Pass:
        // TODO: Handle this case.
        break;
      case Info.Turn:
        print("Got Turn Info");
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
      // TODO: Handle this case.
        break;
      case Info.GameConfig:
      // TODO: Handle this case.
        break;
      case Info.GameResult:
      // TODO: Handle this case.
        break;
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
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text("Prisoners: $points"),
                Text(turn),
                OutlineButton(
                  child: Text("Pass"),
                  onPressed: () {
                    sendPass();
                    print("pass");
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
  Intersection intersection;

  CellPainter(this.intersection);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
        Offset(size.width / 2, 0), Offset(size.width / 2, size.height), paint);
    canvas.drawLine(
        Offset(0, size.height / 2), Offset(size.width, size.height / 2), paint);
    if (!intersection.isStoneBlack) {
      paint.color = Colors.white;
    }
    if (intersection.isStoneDead) {
      paint.color = paint.color.withAlpha(128);
    }
    if (intersection.hasStone) {
      canvas.drawCircle(
          Offset(size.width / 2, size.height / 2), size.height / 2, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}
