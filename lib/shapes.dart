import 'package:flutter/material.dart';

class _ColumnBricks extends StatelessWidget {
  const _ColumnBricks({required this.color, required this.numberofbricks});
  final Color color;
  final int numberofbricks;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < numberofbricks; i++)
          Container(
            height: 20,
            width: 20,
            color: color,
            margin: const EdgeInsets.all(1),
          )
      ],
    );
  }
}

class _RowBricks extends StatelessWidget {
  const _RowBricks({required this.color, required this.numberofbricks});
  final Color color;
  final int numberofbricks;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < numberofbricks; i++)
          Container(
            height: 20,
            width: 20,
            color: color,
            margin: const EdgeInsets.all(1),
          )
      ],
    );
  }
}

class Square extends StatelessWidget {
  const Square({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const color = Colors.brown;

    return SizedBox(
      height: 80,
      width: 80,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          _RowBricks(color: color, numberofbricks: 2),
          _RowBricks(color: color, numberofbricks: 2)
        ],
      ),
    );
  }
}

class Line extends StatelessWidget {
  const Line({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const color = Colors.orange;

    return const SizedBox(
      height: 88,
      width: 20,
      child: _ColumnBricks(color: color, numberofbricks: 4),
    );
  }
}

class Three extends StatelessWidget {
  const Three({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const color = Colors.amber;

    return SizedBox(
      height: 66,
      width: 80,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          _ColumnBricks(color: color, numberofbricks: 3),
          _RowBricks(color: color, numberofbricks: 1)
        ],
      ),
    );
  }
}

class Cross extends StatelessWidget {
  const Cross({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const color = Colors.purple;

    return SizedBox(
      height: 66,
      width: 80,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          _RowBricks(color: color, numberofbricks: 1),
          _ColumnBricks(color: color, numberofbricks: 3),
          _RowBricks(color: color, numberofbricks: 1)
        ],
      ),
    );
  }
}

class RightBrick extends StatelessWidget {
  const RightBrick({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const color = Colors.green;

    return SizedBox(
      height: 66,
      width: 80,
      child: Row(
        children: [
          const _ColumnBricks(color: color, numberofbricks: 3),
          Container(
              height: 66,
              alignment: Alignment.topLeft,
              child: const _RowBricks(color: color, numberofbricks: 1))
        ],
      ),
    );
  }
}


class LeftBrick extends StatelessWidget {
  const LeftBrick({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const color = Colors.red;

    return SizedBox(
      height: 66,
      width: 80,
      child: Row(
        children: [
          Container(
              height: 66,
              alignment: Alignment.topRight,
              child: const _RowBricks(color: color, numberofbricks: 1)),
          const _ColumnBricks(color: color, numberofbricks: 3),

        ],
      ),
    );
  }
}