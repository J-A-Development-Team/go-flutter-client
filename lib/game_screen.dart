import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/html.dart';

import 'Common/data_package.dart';
import 'Common/intersection.dart';
import 'game_communication_helper.dart';

class GameScreen extends StatefulWidget {
  final int boardSize;

  GameScreen({this.boardSize});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool whitesTurn = false;
  bool isYourTurn = false;
  bool playerColor = false;
  String turn = "";
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
  void processMessage (Map<String,dynamic> message){

  }


  void cellClicked(int x, int y) {
    if(boardState[x][y].hasStone==false){
      Intersection intersection = new Intersection.withStone(x, y, true, playerColor);
      DataPackage dataPackage = new DataPackage(intersection, Info.Stone);
      String message = jsonEncode(dataPackage);
      game.send(message);
    }
    setState(() {
      boardState[x][y].hasStone = true;
      boardState[x][y].isStoneBlack = whitesTurn;
    });
    if (whitesTurn) {
      whitesTurn = false;
    } else {
      whitesTurn = true;
    }
    print("$x $y");
  }

  void updateTable(DataPackage dataPackage) {

    boardState =  jsonDecode(dataPackage.data);

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
  _onGameDataReceived(message) {
    DataPackage data;
    data = new DataPackage.fromJson(message);
    print("TO jest info: $data.info");
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

        if(data.data=="black"){
          playerColor=true;
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
        if (turn == "Your turn") {
          isYourTurn = true;
        }
        break;
      case Info.Points:
      // TODO: Handle this case.
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
  @override
  void initState() {
    game.addListener(_onGameDataReceived);
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
                Text("Prisoners: "),
                Text(turn),
                OutlineButton(
                  child: Text("Pass"),
                  onPressed: () {
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
