import 'package:flutter/material.dart';
import 'package:sdl_hackathon/dice_game.dart';

String _statusToLabel(RoundStatus status) {
  switch (status) {
    case RoundStatus.busted:
      return 'round over';
    case RoundStatus.doubled:
      return 'x2';
    case RoundStatus.allBanked:
      return 'all banked';
    case RoundStatus.plusSeventy:
      return '+70';
  }
}

Color _statusToColor(RoundStatus status) {
  switch (status) {
    case RoundStatus.busted:
      return Colors.red;
    case RoundStatus.doubled:
    case RoundStatus.plusSeventy:
      return Colors.green;
    case RoundStatus.allBanked:
      return Colors.blue;
  }
}

class StatusText extends StatelessWidget {
  const StatusText({super.key, required this.status});

  final RoundStatus status;

  @override
  Widget build(BuildContext context) {
    return Text(
      _statusToLabel(status),
      style: TextStyle(
        color: _statusToColor(status),
        fontSize: 32,
        shadows: [
          Shadow(
            blurRadius: 16,
            color: _statusToColor(status).withAlpha(255),
            offset: Offset(0, 0),
          ),
        ],
      ),
    );
  }
}
