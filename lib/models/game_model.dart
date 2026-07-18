import 'package:cloud_firestore/cloud_firestore.dart';

class GameModel {
  final String? id;
  final int boardSize;
  final String winner;
  final Timestamp createdAt;

  const GameModel({
    this.id,
    required this.boardSize,
    required this.winner,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'boardSize': boardSize,
      'winner': winner,
      'createdAt': createdAt,
    };
  }

  factory GameModel.fromMap(
    Map<String, dynamic> map,
    String id,
  ) {
    return GameModel(
      id: id,
      boardSize: map['boardSize'],
      winner: map['winner'],
      createdAt: map['createdAt'],
    );
  }
}