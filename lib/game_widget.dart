import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  @override
  Widget build(BuildContext context) {
    final game = ref.watch(gameProvider).value!;
    final currentTurn = game.currentRoll % game.players.length;
    final currentPlayer = game.players[currentTurn];
    final isCurrentPlayer = currentPlayer == widget.name;
    final myPlayerData = game.players.where((p) => p == widget.name).first;
    return Column(
      children: [
        Text('Current player: $currentPlayer'),
        if (isCurrentPlayer)
          ElevatedButton(
              onPressed: () async {
                final a = Random().nextInt(6) + 1;
                final b = Random().nextInt(6) + 1;
                final sum = a + b;
                final shouldDouble = a == b && game.currentRoll > 3;
                final losePot = sum == 7 && game.currentRoll > 3;
                final newGame = game.copyWith(
                  diceA: a,
                  diceB: b,
                  currentRoll: game.currentRoll + 1,
                  currentPot:
                      losePot ? 0 : (shouldDouble ? game.currentPot * 2 : game.currentPot + sum),
                  roundStatus: losePot
                      ? RoundStatus.busted
                      : shouldDouble
                          ? RoundStatus.doubled
                          : null,
                );
                await updateGame(newGame);
              },
              child: const Text('Roll Dice')),
        if (game.dieA != 0) DieDisplay(value: game.dieA),
        if (game.dieB != 0) DieDisplay(value: game.dieB),
        Text('Current pot: ${game.currentPot}'),
        if (!myPlayerData.hasBanked)
          ElevatedButton(
            onPressed: () async {
              final newGame = game.copyWith(
                players: game.players.map((p) {
                  if (p == widget.name) {
                    return p.copyWith(hasBanked: true);
                  }
                  return p;
                }).toList(),
              );
              await updateGame(newGame);
            },
            child: const Text('Bank Dice'),
          ),
      ],
    );
  }
}
