enum GameStatus { waiting, playing, finished }

enum RoundStatus { busted, doubled, allBanked, plusSeventy }

class PlayerData {
  final String name;
  final int score;
  final bool hasBanked;

  PlayerData({
    required this.name,
    required this.score,
    required this.hasBanked,
  });

  factory PlayerData.fromJson(Map<dynamic, dynamic> json) {
    return PlayerData(
      name: json['name'],
      score: json['score'],
      hasBanked: json['hasBanked'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'score': score,
      'hasBanked': hasBanked,
    };
  }

  PlayerData copyWith({
    String? name,
    int? score,
    bool? hasBanked,
  }) {
    return PlayerData(
      name: name ?? this.name,
      score: score ?? this.score,
      hasBanked: hasBanked ?? this.hasBanked,
    );
  }
}

class DiceGame {
  final String gameId;
  final List<PlayerData> players;
  final GameStatus status;
  final int dieA;
  final int dieB;
  final int currentRoll;
  final int currentPot;
  final int currentRound;
  final int totalRounds;
  final RoundStatus? roundStatus;
  final String currentPlayer;

  DiceGame({
    required this.players,
    required this.status,
    this.gameId = '',
    this.currentRoll = 0,
    this.dieA = 0,
    this.dieB = 0,
    this.currentPot = 0,
    this.currentRound = 0,
    this.totalRounds = 3,
    this.currentPlayer = '',
    this.roundStatus,
  });

  factory DiceGame.fromJson(Map<dynamic, dynamic> json) {
    return DiceGame(
      gameId: json['gameId'] ?? '',
      players: json['players'] == null
          ? []
          : (json['players'] as List).map((e) => PlayerData.fromJson(e)).toList(),
      status: GameStatus.values.firstWhere((e) => e.toString() == 'GameStatus.${json['status']}'),
      currentRoll: json['currentRoll'] ?? 0,
      dieA: json['diceA'] ?? 0,
      dieB: json['diceB'] ?? 0,
      currentPot: json['currentPot'] ?? 0,
      currentRound: json['currentRound'] ?? 0,
      totalRounds: json['totalRounds'] ?? 10,
      roundStatus: json['roundStatus'] != null
          ? RoundStatus.values
              .firstWhere((e) => e.toString() == 'RoundStatus.${json['roundStatus']}')
          : null,
      currentPlayer: json['currentPlayer'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gameId': gameId,
      'players': players.map((e) => e.toJson()).toList(),
      'status': status.toString().split('.').last,
      'currentRoll': currentRoll,
      'diceA': dieA,
      'diceB': dieB,
      'currentPot': currentPot,
      'currentRound': currentRound,
      'totalRounds': totalRounds,
      'roundStatus': roundStatus?.toString().split('.').last,
      'currentPlayer': currentPlayer,
    };
  }

  DiceGame copyWith({
    String? gameId,
    List<PlayerData>? players,
    GameStatus? status,
    int? currentRoll,
    int? dieA,
    int? dieB,
    int? currentPot,
    int? currentRound,
    int? totalRounds,
    RoundStatus? roundStatus,
    String? currentPlayer,
    bool overrideRoundStatus = false,
  }) {
    return DiceGame(
      gameId: gameId ?? this.gameId,
      players: players ?? this.players,
      status: status ?? this.status,
      currentRoll: currentRoll ?? this.currentRoll,
      dieA: dieA ?? this.dieA,
      dieB: dieB ?? this.dieB,
      currentPot: currentPot ?? this.currentPot,
      currentRound: currentRound ?? this.currentRound,
      totalRounds: totalRounds ?? this.totalRounds,
      roundStatus: roundStatus ?? (overrideRoundStatus ? roundStatus : this.roundStatus),
      currentPlayer: currentPlayer ?? this.currentPlayer,
    );
  }
}
