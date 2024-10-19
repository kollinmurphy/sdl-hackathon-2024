import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sdl_hackathon/arcade_button.dart';
import 'package:sdl_hackathon/dice_game.dart';
import 'package:sdl_hackathon/die_display.dart';
import 'package:sdl_hackathon/firebase.dart';
import 'package:sdl_hackathon/glow_text.dart';
import 'package:sdl_hackathon/state.dart';
import 'package:sdl_hackathon/status_text.dart';

class GameWidget extends ConsumerStatefulWidget {
  const GameWidget({
    super.key,
    required this.name,
    required this.isHost,
    required this.onExit,
  });

  final String name;
  final bool isHost;
  final VoidCallback onExit;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GameWidgetState();
}

class _GameWidgetState extends ConsumerState<GameWidget> {
  DiceGame _nextTurn(DiceGame game) {
    int myIndex = game.players.indexWhere((p) => p.name == widget.name);
    String? nextUnbankedPlayer;
    bool roundOver = false;
    try {
      nextUnbankedPlayer = game.players
          .skip(myIndex + 1)
          .firstWhere((p) => !p.hasBanked,
              orElse: () => game.players.firstWhere((p) => !p.hasBanked))
          .name;
    } catch (e) {
      roundOver = true;
    }
    return game.copyWith(
      currentPlayer: nextUnbankedPlayer,
      roundStatus: roundOver ? RoundStatus.allBanked : null,
      overrideRoundStatus: true,
    );
  }

  void _roll(DiceGame game) async {
    final a = Random().nextInt(6) + 1;
    final b = Random().nextInt(6) + 1;
    final sum = a + b;
    final shouldDouble = a == b && game.currentRoll > 3;
    final losePot = sum == 7 && game.currentRoll > 3;
    final shouldAddSeventy = sum == 7 && game.currentRoll <= 3;
    final nextTurn = _nextTurn(game);
    final newGame = nextTurn.copyWith(
      dieA: a,
      dieB: b,
      currentRoll: game.currentRoll + 1,
      currentPot: shouldAddSeventy
          ? game.currentPot + 70
          : losePot
              ? 0
              : (shouldDouble ? game.currentPot * 2 : game.currentPot + sum),
      roundStatus: shouldAddSeventy
          ? RoundStatus.plusSeventy
          : losePot
              ? RoundStatus.busted
              : shouldDouble
                  ? RoundStatus.doubled
                  : nextTurn.roundStatus,
      overrideRoundStatus: true,
    );
    await updateGame(newGame);
  }

  void _bank(DiceGame game, bool isMyTurn) async {
    var newGame = (isMyTurn ? _nextTurn(game) : game).copyWith(
      players: game.players.map((p) {
        if (p.name == widget.name) {
          return p.copyWith(hasBanked: true, score: game.currentPot + p.score);
        }
        return p;
      }).toList(),
    );
    if (newGame.players.every((p) => p.hasBanked)) {
      newGame = newGame.copyWith(roundStatus: RoundStatus.allBanked);
    }
    await updateGame(newGame);
  }

  void _nextRound(DiceGame game) async {
    final newGame = game.copyWith(
      currentPot: 0,
      currentRoll: 0,
      dieA: 0,
      dieB: 0,
      currentPlayer: game.players.first.name,
      currentRound: game.currentRound + 1,
      roundStatus: null,
      players: game.players.map((p) => p.copyWith(hasBanked: false)).toList(),
      overrideRoundStatus: true,
    );
    await updateGame(newGame);
  }

  @override
  Widget build(BuildContext context) {
    final game = ref.watch(gameProvider).value!;
    final currentPlayer =
        game.players.where((p) => p.name == game.currentPlayer).firstOrNull ?? game.players.first;
    final myPlayerData = game.players.where((p) => p.name == widget.name).first;
    final points = myPlayerData.hasBanked ? myPlayerData.score : game.currentPot;
    final roundOver =
        game.roundStatus == RoundStatus.allBanked || game.roundStatus == RoundStatus.busted;
    final isCurrentPlayer = currentPlayer.name == widget.name && !roundOver;
    final highScore = game.players.map((p) => p.score).reduce(max);
    final gameOver = game.currentRound >= game.totalRounds ||
        (game.currentRound == game.totalRounds - 1 && roundOver);

    if (gameOver) {
      final didWin = myPlayerData.score == highScore;
      final winners = game.players.where((p) => p.score == highScore).map((p) => p.name).join('\n');
      return Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 16),
            GlowText(
              text: 'game over',
              color: Colors.red,
            ),
            GlowText(
              text: winners,
              color: didWin ? Colors.green : Colors.red,
            ),
            Text(
              'score ${myPlayerData.score}',
              style: TextStyle(
                fontSize: 24,
                color: didWin ? Colors.green : Colors.red,
              ),
            ),
            Text('high score $highScore', style: const TextStyle(fontSize: 24)),
            ArcadeButton(
              onPressed: widget.onExit,
              text: 'Exit',
            ),
            const SizedBox(height: 16),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: 16),
          Text(
            'player\n${currentPlayer.name}',
            style: const TextStyle(fontSize: 24),
            textAlign: TextAlign.center,
          ),
          if (isCurrentPlayer) ArcadeButton(onPressed: () => _roll(game), text: 'Roll Dice'),
          DieDisplay(value: game.dieA),
          DieDisplay(value: game.dieB),
          if (game.roundStatus != null) StatusText(status: game.roundStatus!),
          if (myPlayerData.hasBanked || roundOver)
            Text('score $points', style: const TextStyle(fontSize: 24))
          else ...[
            Text('current ${game.currentPot}', style: const TextStyle(fontSize: 24)),
            ArcadeButton(
              onPressed: () => _bank(game, isCurrentPlayer),
              text: 'Bank',
            ),
          ],
          if (roundOver) Text('high score $highScore', style: const TextStyle(fontSize: 24)),
          if (roundOver && widget.isHost)
            ArcadeButton(
              onPressed: () => _nextRound(game),
              text: 'continue',
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
