import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sdl_hackathon/dice_game.dart';
import 'package:sdl_hackathon/firebase.dart';

final gameProvider = StreamProvider<DiceGame>((ref) {
  return getGameStream();
});
