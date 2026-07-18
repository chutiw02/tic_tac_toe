class MoveModel {
  final String player;
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
      'player': player,
      'row': row,
      'col': col,
      'moveNumber': moveNumber,
    };
  }

  factory MoveModel.fromMap(Map<String, dynamic> map) {
    return MoveModel(
      player: map['player'],
      row: map['row'],
      col: map['col'],
      moveNumber: map['moveNumber'],
    );
  }
}