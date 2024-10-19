import 'package:firebase_database/firebase_database.dart';
import 'package:sdl_hackathon/dice_game.dart';

FirebaseDatabase database = FirebaseDatabase.instance;
DatabaseReference dbRef = FirebaseDatabase.instance.ref();

Future<void> initRootGame() async {
  final rootGame = await dbRef.child('game').get();
  if (rootGame.exists) return;
  await overwriteRootGame();
}

Future<void> overwriteRootGame() async {
  final newGame = DiceGame(players: [], status: GameStatus.waiting);
  await dbRef.child('game').set(newGame.toJson());
}

Stream<DiceGame> getGameStream() {
  return dbRef.child('game').onValue.map((event) {
    return DiceGame.fromJson(event.snapshot.value as Map<dynamic, dynamic>);
  });
}

Future<void> hostGame(String name, String gameId) async {
  final game = DiceGame(
      gameId: gameId,
      players: [
        new PlayerData(name: name, score: 0, hasBanked: false),
      ],
      status: GameStatus.waiting);
  await dbRef.child('game').set(game.toJson());
}

Future<void> joinGame(String name) async {
  final game = await dbRef.child('game').get();
  final currentGame = DiceGame.fromJson(game.value as Map<dynamic, dynamic>);
  final newGame = currentGame.copyWith(players: [
    ...currentGame.players,
    new PlayerData(name: name, score: 0, hasBanked: false),
  ]);
  await dbRef.child('game').update(newGame.toJson());
}

Future<void> updateGame(DiceGame game) async {
  await dbRef.child('game').update(game.toJson());
}
