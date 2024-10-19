import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sdl_hackathon/dice_game.dart';
import 'package:sdl_hackathon/firebase.dart';
import 'package:sdl_hackathon/game_widget.dart';
import 'package:sdl_hackathon/state.dart';

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

  String? _name;
  bool _isHost = false;
  bool _hasJoined = false;

  void _hostGame() async {
    await hostGame(_name!);
    setState(() {
      _isHost = true;
      _hasJoined = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final game = ref.watch(gameProvider).value;

    if (_name == null) {
      return Column(
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(hintText: 'Enter your name'),
          ),
          ElevatedButton(
            onPressed: () {
              if (game != null && game.players.contains(_controller.text)) return;
              setState(() {
                _name = _controller.text;
              });
            },
            child: const Text('Submit'),
          ),
        ],
      );
    }

    if (game?.status == GameStatus.playing && _hasJoined) {
      return GameWidget(name: _name!, isHost: _isHost);
    }
    if (game != null && game.status != GameStatus.waiting) {
      return Center(
          child: Column(children: [
        Text('Game is in progress'),
        ElevatedButton(onPressed: _hostGame, child: Text('Host new game'))
      ]));
    }
    int playerNum = (game?.players.indexWhere((p) => p == _name) ?? -1) + 1;
    return Column(
      children: [
        Text('Player count: ${game?.players.length ?? 0}'),
        if (game != null) Text('Status: ${game.status}'),
        if (!_hasJoined)
          ElevatedButton(
            onPressed: _hostGame,
            child: const Text('Host Game'),
          ),
        if (!_isHost && !_hasJoined)
          ElevatedButton(
            onPressed: () async {
              await joinGame(_name!);
              setState(() {
                _hasJoined = true;
              });
            },
            child: const Text('Join Game'),
          ),
        if (_hasJoined) Text('You are player #${playerNum}'),
        if (_isHost)
          ElevatedButton(
            onPressed: () async {
              final newGame = game!.copyWith(status: GameStatus.playing);
              await updateGame(newGame);
            },
            child: const Text('Start Game'),
          ),
      ],
    );
  }
}
