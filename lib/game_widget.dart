import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sdl_hackathon/arcade_button.dart';
import 'package:sdl_hackathon/dice_game.dart';
import 'package:sdl_hackathon/die_display.dart';
import 'package:sdl_hackathon/firebase.dart';
import 'package:sdl_hackathon/state.dart';

class GameWidget extends ConsumerStatefulWidget {
  const GameWidget({super.key, required this.name, required this.isHost});

  final String name;
  final bool isHost;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GameWidgetState();
}

class _GameWidgetState extends ConsumerState<GameWidget> {
  void _roll(DiceGame game) async {
    final a = Random().nextInt(6) + 1;
    final b = Random().nextInt(6) + 1;
    final sum = a + b;
    final shouldDouble = a == b && game.currentRoll > 3;
    final losePot = sum == 7 && game.currentRoll > 3;
    int myIndex = game.players.indexWhere((p) => p.name == widget.name);
    String nextUnbankedPlayer = game.players
        .skip(myIndex + 1)
        .firstWhere((p) => !p.hasBanked, orElse: () => game.players.firstWhere((p) => !p.hasBanked))
        .name;
    final newGame = game.copyWith(
      diceA: a,
      diceB: b,
      currentRoll: game.currentRoll + 1,
      currentPot: losePot ? 0 : (shouldDouble ? game.currentPot * 2 : game.currentPot + sum),
      currentPlayer: nextUnbankedPlayer,
      roundStatus: losePot
          ? RoundStatus.busted
          : shouldDouble
              ? RoundStatus.doubled
              : null,
    );
    await updateGame(newGame);
  }

  void _bank(DiceGame game) async {
    final newGame = game.copyWith(
      players: game.players.map((p) {
        if (p == widget.name) {
          return p.copyWith(hasBanked: true);
        }
        return p;
      }).toList(),
    );
    await updateGame(newGame);
  }

  @override
  Widget build(BuildContext context) {
    final game = ref.watch(gameProvider).value!;
    final currentTurn = game.currentRoll % game.players.length;
    final currentPlayer = game.players[currentTurn];
    final isCurrentPlayer = currentPlayer.name == widget.name;
    final myPlayerData = game.players.where((p) => p.name == widget.name).first;
    final points = currentPlayer.hasBanked ? currentPlayer.score : game.currentPot;
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: 16),
          Text('player ${currentPlayer.name}', style: const TextStyle(fontSize: 24)),
          if (isCurrentPlayer) ArcadeButton(onPressed: () => _roll(game), text: 'Roll Dice'),
          DieDisplay(value: game.dieA),
          DieDisplay(value: game.dieB),
          Text('high score ${game.currentPot}', style: const TextStyle(fontSize: 24)),
          Text('score $points', style: const TextStyle(fontSize: 24)),
          if (!myPlayerData.hasBanked)
            ArcadeButton(
              onPressed: () => _bank(game),
              text: 'Bank',
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
