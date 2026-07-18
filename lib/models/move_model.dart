import '../utils/player.dart';

class MoveModel {
  final Player player;
  final int row;
  final int col;
  final int moveNumber;

  const MoveModel({
    required this.player,
    required this.row,
    required this.col,
    required this.moveNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      'player': player.symbol,
      'row': row,
      'col': col,
      'moveNumber': moveNumber,
    };
  }

  factory MoveModel.fromMap(Map<String, dynamic> map) {
    return MoveModel(
      player: _playerFromString(map['player'] as String),
      row: map['row'] as int,
      col: map['col'] as int,
      moveNumber: map['moveNumber'] as int,
    );
  }

  static Player _playerFromString(String value) {
    switch (value) {
      case 'X':
        return Player.x;
      case 'O':
        return Player.o;
      default:
        return Player.none;
    }
  }
}
