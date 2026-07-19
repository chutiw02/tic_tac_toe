import 'package:flutter/material.dart';
import 'package:tic_tac_toe/services/firestore_service.dart';
import '../models/game_model.dart';
import 'replay_screen.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Game History")),
      body: StreamBuilder<List<GameModel>>(
        stream: FirestoreService.instance.getGames(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final games = snapshot.data ?? [];

          if (games.isEmpty) {
            return const Center(child: Text("No History"));
          }

          return ListView.builder(
            itemCount: games.length,
            itemBuilder: (context, index) {
              final game = games[index];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(child: Text(game.winner)),
                  title: Text("${game.boardSize} x ${game.boardSize}"),
                  subtitle: Text(
                    "Winner : ${game.winner}\nMoves : ${game.totalMoves}",
                  ),
                  trailing: Text(
                    DateFormat('dd/MM/yyyy HH:mm').format(game.createdAt),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ReplayScreen(game: game),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
