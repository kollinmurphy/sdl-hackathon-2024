import 'package:flutter/material.dart';

const dotSize = 8.0;
const halfDotSize = dotSize / 2;

class DieDot extends StatelessWidget {
  const DieDot({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: dotSize,
      height: dotSize,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 4),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.white,
            blurRadius: 6,
            offset: const Offset(0, 0),
          ),
        ],
      ),
    );
  }
}

List<Widget> createDieDots(int value, double width, double height) {
  if (value == 0) return [];
  if (value == 1)
    return [
      Positioned(child: DieDot(), left: width / 2 - halfDotSize, top: height / 2 - halfDotSize),
    ];
  if (value == 2)
    return [
      Positioned(child: DieDot(), left: width / 4 - halfDotSize, top: height / 4 - halfDotSize),
      Positioned(
          child: DieDot(), left: 3 * width / 4 - halfDotSize, top: 3 * height / 4 - halfDotSize),
    ];
  if (value == 3)
    return [
      Positioned(child: DieDot(), left: width / 2 - halfDotSize, top: height / 2 - halfDotSize),
      Positioned(child: DieDot(), left: width / 4 - halfDotSize, top: height / 4 - halfDotSize),
      Positioned(
          child: DieDot(), left: 3 * width / 4 - halfDotSize, top: 3 * height / 4 - halfDotSize),
    ];
  if (value == 4)
    return [
      Positioned(child: DieDot(), left: width / 4 - halfDotSize, top: height / 4 - halfDotSize),
      Positioned(
          child: DieDot(), left: 3 * width / 4 - halfDotSize, top: 3 * height / 4 - halfDotSize),
      Positioned(child: DieDot(), left: 3 * width / 4 - halfDotSize, top: height / 4 - halfDotSize),
      Positioned(child: DieDot(), left: width / 4 - halfDotSize, top: 3 * height / 4 - halfDotSize),
    ];
  if (value == 5)
    return [
      Positioned(child: DieDot(), left: width / 2 - halfDotSize, top: height / 2 - halfDotSize),
      Positioned(child: DieDot(), left: width / 4 - halfDotSize, top: height / 4 - halfDotSize),
      Positioned(
          child: DieDot(), left: 3 * width / 4 - halfDotSize, top: 3 * height / 4 - halfDotSize),
      Positioned(child: DieDot(), left: 3 * width / 4 - halfDotSize, top: height / 4 - halfDotSize),
      Positioned(child: DieDot(), left: width / 4 - halfDotSize, top: 3 * height / 4 - halfDotSize),
    ];
  if (value == 6)
    return [
      Positioned(child: DieDot(), left: width / 4 - halfDotSize, top: height / 4 - halfDotSize),
      Positioned(
          child: DieDot(), left: 3 * width / 4 - halfDotSize, top: 3 * height / 4 - halfDotSize),
      Positioned(child: DieDot(), left: 3 * width / 4 - halfDotSize, top: height / 4 - halfDotSize),
      Positioned(child: DieDot(), left: width / 4 - halfDotSize, top: 3 * height / 4 - halfDotSize),
      Positioned(child: DieDot(), left: width / 4 - halfDotSize, top: height / 2 - halfDotSize),
      Positioned(child: DieDot(), left: 3 * width / 4 - halfDotSize, top: height / 2 - halfDotSize),
    ];
  return [];
}

class DieDisplay extends StatelessWidget {
  const DieDisplay({super.key, required this.value});

  final int value;

  @override
  Widget build(BuildContext context) {
    if (value == 0) return const SizedBox.shrink();
    const width = 100.0;
    const height = 100.0;
    return Stack(
      children: [
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 4),
            color: Colors.black,
            boxShadow: [
              BoxShadow(
                color: Colors.white,
                blurRadius: 6,
                offset: const Offset(0, 0),
              ),
            ],
          ),
        ),
        ...createDieDots(value, width, height),
      ],
    );
    // return Image(
    //   alignment: Alignment.center,
    //   image: AssetImage('assets/DicePack/die$value.png'),
    // );
  }
}
