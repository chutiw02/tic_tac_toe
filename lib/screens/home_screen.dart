import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/game_provider.dart';
import 'game_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {

  int selectedSize = 3;


  final List<int> boardSizes = [
    3,
    4,
    5,
  ];


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Tic Tac Toe",
        ),
        centerTitle: true,
      ),


      body: Padding(
        padding: const EdgeInsets.all(24),

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            const Text(
              "Select Board Size",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),


            const SizedBox(height: 20),


            DropdownButton<int>(

              value: selectedSize,

              items: boardSizes.map((size){

                return DropdownMenuItem(

                  value: size,

                  child: Text(
                    "$size x $size",
                  ),

                );

              }).toList(),


              onChanged: (value){

                if(value != null){

                  setState(() {

                    selectedSize = value;

                  });

                }

              },

            ),


            const SizedBox(height: 40),



            SizedBox(

              width: double.infinity,

              child: ElevatedButton(

                onPressed: (){

                  final provider =
                      context.read<GameProvider>();


                  provider.initializeBoard(
                    selectedSize,
                  );


                  Navigator.push(

                    context,

                    MaterialPageRoute(

                      builder: (_) =>
                          const GameScreen(),

                    ),

                  );

                },


                child: const Text(
                  "Start Game",
                ),

              ),

            ),


          ],

        ),

      ),

    );

  }
}