import 'package:flutter/material.dart';
import 'dart:math';

class MiniGame2 extends StatefulWidget {
  @override
  _MiniGame2State createState() => _MiniGame2State();
}

class _MiniGame2State extends State<MiniGame2> {
  final List<Map<String, dynamic>> _products = [
    {'name': 'Kalem', 'weight': 10},
    {'name': 'Silgi', 'weight': 15},
    {'name': 'Defter', 'weight': 200},
    {'name': 'Çanta', 'weight': 500},
    {'name': 'Renkli Kağıt', 'weight': 50},
    {'name': 'Kitap', 'weight': 300},
  ];

  int? _randomWeight;
  String? _correctProduct;
  List<Map<String, dynamic>> _options = [];
  bool _isGameOver = false;

  void _startGame() {
    _isGameOver = false;
    Random random = Random();
    int randomIndex = random.nextInt(_products.length);
    _correctProduct = _products[randomIndex]['name'];
    _randomWeight = _products[randomIndex]['weight'];

    _generateOptions();

    setState(() {});
  }

  void _generateOptions() {
    _options.clear();
    _options.add({'name': _correctProduct, 'isCorrect': true});

    Random random = Random();
    while (_options.length < 4) {
      int randomIndex = random.nextInt(_products.length);
      if (_options.every(
          (option) => option['name'] != _products[randomIndex]['name'])) {
        _options
            .add({'name': _products[randomIndex]['name'], 'isCorrect': false});
      }
    }

    _options.shuffle();
  }

  void _checkAnswer(bool isCorrect) {
    setState(() {
      _isGameOver = true; 
    });

    if (isCorrect) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Doğru cevap! 🎉", style: TextStyle(color: Colors.green)),
        duration: Duration(seconds: 2),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Yanlış cevap! ❌ Doğru cevap: $_correctProduct",
            style: TextStyle(color: Colors.red)),
        duration: Duration(seconds: 2),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ürün Tahmini', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple[900]!, Colors.deepPurple[700]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_randomWeight == null) ...[
                ElevatedButton(
                  onPressed: _startGame,
                  child: Text('Tahmin Et'),
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                ),
              ] else ...[
                Text(
                  'Nesnenin Ağırlığı: $_randomWeight gram',
                  style: TextStyle(
                      fontSize: 26,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text(
                  'Bu ağırlıkta hangi ürün Olabilir?',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
                SizedBox(height: 20),
                // Şıkları göster
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isGameOver
                                ? null
                                : () => _checkAnswer(_options[0]['isCorrect']),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal),
                            child: Text(_options[0]['name']),
                          ),
                        ),
                        SizedBox(width: 10), 
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isGameOver
                                ? null
                                : () => _checkAnswer(_options[1]['isCorrect']),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal),
                            child: Text(_options[1]['name']),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isGameOver
                                ? null
                                : () => _checkAnswer(_options[2]['isCorrect']),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal),
                            child: Text(_options[2]['name']),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isGameOver
                                ? null
                                : () => _checkAnswer(_options[3]['isCorrect']),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal),
                            child: Text(_options[3]['name']),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
                if (_isGameOver) ...[
                  ElevatedButton(
                    onPressed: () {
                      _startGame();
                    },
                    child: Text('Tekrar Sor'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}
