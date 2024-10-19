import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sdl_hackathon/arcade_button.dart';
import 'package:sdl_hackathon/arcade_text_input.dart';
import 'package:sdl_hackathon/dice_game.dart';
import 'package:sdl_hackathon/firebase.dart';
import 'package:sdl_hackathon/game_widget.dart';
import 'package:sdl_hackathon/state.dart';
import 'package:uuid/uuid.dart';

String _createGuid() {
  final String id = const Uuid().v4();
  return id;
}

String numberToWord(int number) {
  switch (number) {
    case 0:
      return 'zero';
    case 1:
      return 'one';
    case 2:
      return 'two';
    case 3:
      return 'three';
    case 4:
      return 'four';
    case 5:
      return 'five';
    case 6:
      return 'six';
    case 7:
      return 'seven';
    case 8:
      return 'eight';
    case 9:
      return 'nine';
    case 10:
      return 'ten';
    default:
      return number.toString();
  }
}

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String? _gameId;
  String? _name;
  bool _hasJoined = false;
  bool _isHost = false;

  void _hostGame() async {
    final gameId = _createGuid();
    await hostGame(_name!, gameId);
    setState(() {
      _gameId = gameId;
      _hasJoined = true;
      _isHost = true;
    });
  }

  void _joinGame(DiceGame game) async {
    await joinGame(_name!);
    setState(() {
      _gameId = game.gameId;
      _hasJoined = true;
    });
  }

  void _setName(DiceGame? game) {
    final text = _controller.text.trim().toUpperCase();
    if (text.isEmpty) return;
    if (game != null && game.players.contains(text)) return;
    setState(() {
      _name = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    final game = ref.watch(gameProvider).value;

    if (game != null && game.gameId != _gameId) {
      Future.delayed(Duration.zero, () {
        setState(() {
          _hasJoined = false;
          _isHost = false;
        });
      });
    }

    if (_name == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 16),
            ArcadeTextInput(controller: _controller, hint: 'player name'),
            ArcadeButton(
              onPressed: () => _setName(game),
              text: 'continue',
            ),
            const SizedBox(height: 16),
          ],
        ),
      );
    }

    if (game?.status == GameStatus.playing && _hasJoined) {
      return GameWidget(name: _name!, isHost: _isHost);
    }
    if (game != null && game.status != GameStatus.waiting) {
      return Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
            Text('in progress', style: const TextStyle(fontSize: 24), textAlign: TextAlign.center),
            if (_name == "KOLLIN")
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ArcadeButton(onPressed: _hostGame, text: 'Host new game'),
              )
          ]));
    }
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          if (!_hasJoined || !_isHost)
            Text(
              _hasJoined
                  ? "ready"
                  : 'ready\nplayer\n${numberToWord((game?.players.length ?? 0) + 1)}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 36),
            ),
          if ((!_hasJoined && game == null) || _name == "KOLLIN")
            ArcadeButton(
              onPressed: _hostGame,
              text: 'Host Game',
            ),
          if (!_isHost && !_hasJoined)
            ArcadeButton(
              onPressed: () => _joinGame(game!),
              text: 'insert token',
            ),
          if (_isHost)
            ArcadeButton(
              onPressed: () async {
                final newGame = game!.copyWith(status: GameStatus.playing);
                await updateGame(newGame);
              },
              text: 'play',
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
