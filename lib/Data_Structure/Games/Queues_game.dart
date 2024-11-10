import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(CardBattleGame());
}

class CardBattleGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<CardModel> player1Deck = generateBalancedDeck();
  List<CardModel> player2Deck = generateBalancedDeck();
  int player1Score = 0;
  int player2Score = 0;
  int turn = 1;
  CardModel? player1SelectedCard;
  CardModel? player2SelectedCard;
  List<CardModel>? player1Hand;
  List<CardModel>? player2Hand;
  bool isPlayer2CardHidden = true;
  bool isCardSelectionLocked = false;
  String message = "";

  @override
  void initState() {
    super.initState();
    drawHands();
  }

  void drawHands() {
    // Check if there are enough cards for the next turn and if we are within the turn limit
    if (player1Deck.length >= 2 && player2Deck.length >= 2 && turn <= 10) {
      setState(() {
        player1Hand = [player1Deck.removeLast(), player1Deck.removeLast()];
        player2Hand = [player2Deck.removeLast(), player2Deck.removeLast()];
        player1SelectedCard = null;
        player2SelectedCard = null;
        isPlayer2CardHidden = true;
        isCardSelectionLocked = false;
        message = "Turn $turn: Choose a card to play!";
      });
    } else {
      _showGameOverDialog();
    }
  }

  void playTurn() {
    if (player1SelectedCard != null && player2SelectedCard != null) {
      setState(() {
        isCardSelectionLocked = true;

        int player1InitialHealth = player1SelectedCard!.health;
        int player2InitialHealth = player2SelectedCard!.health;

        // Both cards attack each other
        player1SelectedCard!.health -= player2SelectedCard!.attack;
        player2SelectedCard!.health -= player1SelectedCard!.attack;

        // Determine the outcome of the turn and award points
        if (player1SelectedCard!.health > 0 &&
            player2SelectedCard!.health <= 0) {
          player1Score++;
          message = "Turn $turn Winner: Player 1 wins this round!";
        } else if (player2SelectedCard!.health > 0 &&
            player1SelectedCard!.health <= 0) {
          player2Score++;
          message = "Turn $turn Winner: Player 2 (AI) wins this round!";
        } else if (player1SelectedCard!.health > 0 &&
            player2SelectedCard!.health > 0) {
          message = "Turn $turn: It's a tie! Both cards survived.";
        } else {
          message = "Turn $turn: Both cards were defeated!";
        }

        // Reset health for the next round
        player1SelectedCard!.health = player1InitialHealth;
        player2SelectedCard!.health = player2InitialHealth;

        turn++;
        drawHands();
      });
    }
  }

  void selectCardForPlayer1(CardModel card) {
    if (!isCardSelectionLocked) {
      setState(() {
        player1SelectedCard = card;
        chooseCardForAI();
        isPlayer2CardHidden = false;
        isCardSelectionLocked = true;
      });
    }
  }

  void chooseCardForAI() {
    // AI chooses the card with the highest attack as a basic strategy
    player2SelectedCard =
        player2Hand!.reduce((a, b) => a.attack >= b.attack ? a : b);
  }

  void resetGame() {
    setState(() {
      player1Deck = generateBalancedDeck();
      player2Deck = generateBalancedDeck();
      player1Score = 0;
      player2Score = 0;
      turn = 1;
      player1SelectedCard = null;
      player2SelectedCard = null;
      player1Hand = null;
      player2Hand = null;
      isPlayer2CardHidden = true;
      isCardSelectionLocked = false;
      message = "";
      drawHands();
    });
  }

  void _showGameOverDialog() {
    String winner;
    if (player1Score > player2Score) {
      winner = "Player 1 Wins!";
    } else if (player2Score > player1Score) {
      winner = "Player 2 (AI) Wins!";
    } else {
      winner = "It's a Draw!";
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Game Over"),
          content: Text(
              "Final Score:\nPlayer 1: $player1Score\nPlayer 2: $player2Score\n\n$winner"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                resetGame();
              },
              child: Text("Restart"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[800],
      appBar: AppBar(
        title: Text("Turn-Based Card Game"),
        backgroundColor: Colors.green[700],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Turn: $turn",
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
          SizedBox(height: 10),
          Text(
            message,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    "Player 1",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  Text(
                    "Score: $player1Score",
                    style: TextStyle(color: Colors.white),
                  ),
                  Row(
                    children: player1Hand?.map((card) {
                          return GestureDetector(
                            onTap: () => selectCardForPlayer1(card),
                            child: CardWidget(
                              card: card,
                              isSelected: card == player1SelectedCard,
                            ),
                          );
                        }).toList() ??
                        [],
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    "Player 2 (AI)",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  Text(
                    "Score: $player2Score",
                    style: TextStyle(color: Colors.white),
                  ),
                  Row(
                    children: [
                      if (player2SelectedCard != null && !isPlayer2CardHidden)
                        CardWidget(card: player2SelectedCard!)
                      else
                        Container(
                          width: 100,
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.grey[700],
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(color: Colors.black26, blurRadius: 5)
                            ],
                          ),
                          child: Center(
                            child: Text(
                              "Hidden",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed:
                player1SelectedCard != null && player2SelectedCard != null
                    ? playTurn
                    : null,
            child: Text("Play Turn"),
          ),
          ElevatedButton(
            onPressed: resetGame,
            child: Text("Restart Game"),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red[400]),
          ),
        ],
      ),
    );
  }
}

class CardModel {
  final String name;
  final int attack;
  int health;
  final Color color;

  CardModel(
      {required this.name,
      required this.attack,
      required this.health,
      required this.color});
}

class CardWidget extends StatelessWidget {
  final CardModel card;
  final bool isSelected;

  CardWidget({required this.card, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 150,
      margin: EdgeInsets.symmetric(horizontal: 5),
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: isSelected ? Colors.yellow : card.color,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
        border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            card.name,
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 10),
          Text(
            "ATK: ${card.attack}",
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          Text(
            "HP: ${card.health}",
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

// Function to generate balanced decks
List<CardModel> generateBalancedDeck() {
  List<CardModel> deck = [];
  List<Color> colors = [
    Colors.blue,
    Colors.red,
    Colors.orange,
    Colors.purple,
    Colors.cyan
  ];
  Random random = Random();

  // Create 10 cards with balanced stats
  for (int i = 0; i < 10; i++) {
    int attack = random.nextInt(5) + 5; // Attack values between 5 and 9
    int health = random.nextInt(5) + 5; // Health values between 5 and 9
    deck.add(CardModel(
      name: "Card ${i + 1}",
      attack: attack,
      health: health,
      color: colors[random.nextInt(colors.length)],
    ));
  }

  return deck;
}
