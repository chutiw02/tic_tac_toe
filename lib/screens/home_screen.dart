import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'history_screen.dart';
import '../providers/game_provider.dart';
import 'game_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedSize = 3;

  bool isCustom = false;

  final TextEditingController sizeController = TextEditingController();

  final List<int> boardSizes = [3, 4, 5];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tic Tac Toe")),

      body: Padding(
        padding: const EdgeInsets.all(24),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            const Text(
              "Select Board Size",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            DropdownButton<int>(
              value: isCustom ? null : selectedSize,

              hint: isCustom ? const Text("Custom") : null,

              items: [
                ...boardSizes.map((size) {
                  return DropdownMenuItem(
                    value: size,

                    child: Text("$size x $size"),
                  );
                }),

                const DropdownMenuItem(value: -1, child: Text("Custom")),
              ],

              onChanged: (value) {
                if (value == -1) {
                  setState(() {
                    isCustom = true;
                  });
                } else if (value != null) {
                  setState(() {
                    isCustom = false;

                    selectedSize = value;
                  });
                }
              },
            ),

            if (isCustom) ...[
              const SizedBox(height: 20),

              TextField(
                controller: sizeController,

                keyboardType: TextInputType.number,

                decoration: const InputDecoration(
                  labelText: "Board Size",

                  hintText: "Example: 6",

                  border: OutlineInputBorder(),
                ),
              ),
            ],

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: () {
                  int size;

                  if (isCustom) {
                    size = int.tryParse(sizeController.text) ?? 3;
                  } else {
                    size = selectedSize;
                  }

                  if (size < 3) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Minimum size is 3")),
                    );

                    return;
                  }

                  context.read<GameProvider>().initializeBoard(size);

                  Navigator.push(
                    context,

                    MaterialPageRoute(builder: (_) => const GameScreen()),
                  );
                },

                child: const Text("Start Game"),
              ),
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HistoryScreen()),
                  );
                },
                child: const Text("History"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
