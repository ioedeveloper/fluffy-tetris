import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shammo/utils.dart';
import 'package:tetris/shapes.dart';
import 'package:tetris/utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double bottom = 0;
  bool isRotated = false;
  double? right;
  double screendimension = 0;
  int screenGridHeight = 0;
  List<String> filledPositions = [];
  int gridNumber = 0;
  late Map currentBrickShape;

  List bricks = const [
    Square(),
    Line(),
    Three(),
    Cross(),
    RightBrick(),
    LeftBrick()
  ];

  List<Map<String, int>> dimensions = [
    {"width": 2, "rotated_width": 2, "rotated_height": 2, "height": 2},
    {"width": 1, "rotated_width": 4, "rotated_height": 2, "height": 4},
    {"width": 2, "rotated_width": 3, "rotated_height": 3, "height": 3},
    {"width": 4, "rotated_width": 3, "rotated_height": 3, "height": 3},
    {"width": 4, "rotated_width": 3, "rotated_height": 3, "height": 2},
    {"width": 4, "rotated_width": 3, "rotated_height": 3, "height": 2},
  ];

  List<Piece> pieces = [];

  void _getPieces() {
    final brickIndex = randomize(pieces.length)?.toInt() ?? 1;
    setState(() {
      pieces = [
        ...pieces,
        Piece(
            child: bricks[brickIndex],
            onDone: () {
              _getPieces();
            },
            bottom: bottom,
            filledPositions: filledPositions,
            gridNumber: gridNumber,
            shape: dimensions[brickIndex],
            isRotated: isRotated,
            updateBottom: (positions) {
              setState(() {
                filledPositions = [...filledPositions, ...positions];
              });
            }),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    if (bottom.toInt() == 0) {
      screendimension = width(context);
      gridNumber = (height(context) - 140) ~/ 20;
      setState(() {
        bottom = height(context) - 140;
      });
    }

    if (pieces.isEmpty && bottom != 0) {
      _getPieces();
    }

    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          SizedBox(
            height: height(context) - 100,
            width: width(context),
            child: GestureDetector(
                onHorizontalDragUpdate: (details) {
                  setState(() {
                    right = details.globalPosition.dx;
                  });
                },
                child: SizedBox(
                  height: height(context) - 100,
                  width: width(context),
                  child: Stack(
                    children: [
                      for (final child in pieces) child,
                    ],
                  ),
                )),
          )
        ],
      ),
    ));
  }
}

class Piece extends StatefulWidget {
  const Piece(
      {Key? key,
      required this.child,
      required this.bottom,
      required this.onDone,
      required this.updateBottom,
      required this.filledPositions,
      required this.gridNumber,
      required this.shape,
      required this.isRotated})
      : super(key: key);
  final Widget child;
  final double bottom;
  final Function() onDone;
  final Function(List) updateBottom;
  final List<String> filledPositions;
  final int gridNumber;
  final Map shape;
  final bool isRotated;

  @override
  State<Piece> createState() => _PieceState();
}

class _PieceState extends State<Piece> {
  double top = 0, turn = 0;
  double left = 0;
  double right = 0;
  bool landed = false, isRotated = false;
  int xpos = 0, ypos = 0;
  late List<String> filledPositions;
  int duration = 300;
  late StreamSubscription interval;
  List returnSlots() {
    final slots = [];

    interval.cancel();
    widget.onDone();
    landed = true;
    for (int i = 0; i < widget.shape["height"] + xpos; i++) {
      for (int index = 0;
          index <
              (isRotated
                  ? widget.shape["rotated_width"]
                  : widget.shape["width"]);
          index++) {
        slots.add("${xpos + i}${ypos + index}");
      }
    }
    return slots;
  }

  void moveDown(comp) {
    // This checks if the brick hits the top of another brick

    if (widget.filledPositions.contains("$xpos$ypos")) {
      widget.updateBottom(returnSlots());

      return;
    }

    // This conditional moves the brick down if it has not reach the bottom
    if ((xpos +
            (isRotated
                ? widget.shape["rotated_height"]
                : widget.shape["height"])) <=
        widget.gridNumber) {
      setState(() {
        top += 20;
        xpos += 1;
        if (duration != 300) duration = 300;
      });

      return;
    } else {
      print({xpos, widget.gridNumber});

      print(widget.filledPositions.contains("$xpos$ypos"));

      // This checks if the brick is at the bottom
      widget.updateBottom(returnSlots());
      return;
    }
  }

  @override
  void initState() {
    left = randomize(250) ?? 20;
    ypos = left ~/ 20;
    interval = Stream.periodic(const Duration(seconds: 1), moveDown)
        .listen((event) {});
    filledPositions = widget.filledPositions;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
        curve: Curves.ease,
        child: GestureDetector(
            onHorizontalDragUpdate: (details) {
              double position = details.globalPosition.dx;
              int brickWidth = (widget.isRotated
                      ? widget.shape["rotated"]
                      : widget.shape["width"]) *
                  20;

              setState(() {
                duration = 150;
                if (landed) {
                  return;
                }
                if (position % 20 <= 1 &&
                    position > 20 &&
                    width(context) - position >= brickWidth) {
                  left = position;
                  ypos = left ~/ 20;
                }
              });
            },
            onVerticalDragUpdate: (details) {
              double position = details.globalPosition.dy;
              if (landed == false && top < position) {
                moveDown(null);

                setState(() {
                  top = position;
                });
              }
            },
            onTap: () {
              setState(() {
                if (turn == 1) {
                  turn = 0;
                } else {
                  turn += .25;
                }
                if (turn == .25 || turn == .75) {
                  isRotated = true;
                } else {
                  isRotated = false;
                }
              });
            },
            child: AnimatedRotation(
                duration: const Duration(microseconds: 500),
                turns: turn,
                child: widget.child)),
        top: top,
        left: left,
        duration: Duration(milliseconds: duration));
  }
}
