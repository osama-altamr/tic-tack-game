import 'package:flutter/material.dart';

import 'game_logic.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String activePlayer = 'X';
  bool gameOver = false;
  String reslut = '';
  int turn = 0;
  Game game = Game();
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: MediaQuery.of(context).orientation == Orientation.portrait
            ? Column(
                children: [...firstBlock(), expanded(context), ...lastBlock()],
              )
            : Row(
                children: [
                  Expanded(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ...firstBlock(),
                          ...lastBlock(),
                        ]),
                  ),
                  Container(
                    child: expanded(context),
                  )
                ],
              ),
      ),
    );
  }

  List<Widget> firstBlock() {
    return [
      SwitchListTile.adaptive(
          title: const Text(
            'Turn On/Off two player ',
            style: TextStyle(
              fontSize: 25,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
          value: isSwitched,
          onChanged: (bool newVal) {
            setState(() {
              isSwitched = newVal;
            });
          }),
      Text(
        'It\'s $activePlayer turn'.toUpperCase(),
        style: const TextStyle(
          fontSize: 52,
          color: Colors.white,
          fontWeight: FontWeight.w400,
        ),
        textAlign: TextAlign.center,
      )
    ];
  }

  List<Widget> lastBlock() {
    return [
      Text(
        reslut,
        style: const TextStyle(
          fontSize: 52,
          color: Colors.white,
          fontWeight: FontWeight.w400,
        ),
        textAlign: TextAlign.center,
      ),
      ElevatedButton.icon(
        onPressed: () {
          setState(() {
            Player.playerO = [];
            Player.playerX = [];
            activePlayer = 'X';
            gameOver = false;
            reslut = '';
            turn = 0;
          });
        },
        icon: const Icon(Icons.replay),
        label: const Text('Reapet the game '),
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all(Theme.of(context).splashColor),
        ),
      )
    ];
  }

  Expanded expanded(BuildContext context) {
    return Expanded(
      child: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 3,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        childAspectRatio: 1.0,
        children: List.generate(
          9,
          (index) => InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: gameOver == true ? null : () => _onTap(index),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).shadowColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  Player.playerX.contains(index)
                      ? 'X'
                      : Player.playerO.contains(index)
                          ? 'O'
                          : '',
                  style: TextStyle(
                    fontSize: 52,
                    color: Player.playerX.contains(index)
                        ? Colors.blue
                        : Colors.pink,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _onTap(int index) async {
    if ((Player.playerO.isEmpty || !Player.playerO.contains(index)) &&
        (Player.playerX.isEmpty || !Player.playerX.contains(index))) {
      game.playGame(index, activePlayer);
      updateState();
      if (!isSwitched && !gameOver && turn != 9) {
        await game.autoPlay(activePlayer);
        updateState();
      }
    }
  }

  void updateState() {
    setState(() {
      activePlayer = activePlayer == 'X' ? 'O' : 'X';
      turn++;
      String winnerPlayer = game.checkWinner();
      if (winnerPlayer != '')
        reslut = '$winnerPlayer is the winner';
      else if (turn == 9) {
        reslut = 'it\'s Draw!';
      }
    });
  }
}
