import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class MiniGame3 extends StatefulWidget {
  @override
  _MiniGame3State createState() => _MiniGame3State();
}

class _MiniGame3State extends State<MiniGame3> {
  final List<Map<String, dynamic>> _products = [
    {'name': 'Kalem', 'weight': 20},
    {'name': 'Defter', 'weight': 200},
    {'name': 'Kitap', 'weight': 500},
    {'name': 'Silgi', 'weight': 15},
    {'name': 'Çanta', 'weight': 300},
    {'name': 'Tablet', 'weight': 400},
    {'name': 'Masa', 'weight': 3000},
    {'name': 'Sandalyem', 'weight': 500},
  ];

  late Timer _timer;
  int _timeLeft = 45;
  int _score = 0;
  String? _currentObject;
  List<int> _options = [];
  bool _gameStarted = false; // Oyun başlamadı

  @override
  void initState() {
    super.initState();
  }

  void _startGame() {
    setState(() {
      _score = 0;
      _timeLeft = 45;
      _gameStarted = true; // Oyun başladı
    });
    _nextQuestion();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        _timer.cancel();
        _showResultDialog();
      }
    });
  }

  void _nextQuestion() {
    Random random = Random();
    int randomIndex = random.nextInt(_products.length);
    _currentObject = _products[randomIndex]['name'];
    _options = _generateOptions(_products[randomIndex]['weight']);
    setState(() {});
  }

  List<int> _generateOptions(int correctWeight) {
    Random random = Random();
    List<int> options = [correctWeight];

    while (options.length < 4) {
      int randomWeight =
          random.nextInt(200) + 1; // 1 ile 200 arasında rastgele değer
      if (!options.contains(randomWeight)) {
        options.add(randomWeight);
      }
    }

    options.shuffle(); // Seçenekleri karıştır
    return options;
  }

  void _checkAnswer(int selectedOption) {
    if (selectedOption ==
        _products.firstWhere(
            (product) => product['name'] == _currentObject)['weight']) {
      setState(() {
        _score += 10;
      });
    }
    // Yanlış cevapta direkt diğer soruya geç
    _nextQuestion();
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Oyun Bitti!',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Toplam Puan: $_score', style: TextStyle(fontSize: 20)),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _resetGame();
                },
                child: Text('Tekrar Oyna'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ],
          ),
          actions: [],
        );
      },
    );
  }

  void _resetGame() {
    setState(() {
      _score = 0;
      _timeLeft = 45;
      _gameStarted = false; // Oyun durdu
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Timer'ı durdur
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nesne Ağırlık Tahmin Oyunu',
            style: TextStyle(color: Colors.white)),
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
          child: !_gameStarted // Oyun başlamadıysa butonu göster
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Oyun Başlasın!',
                      style: TextStyle(
                          fontSize: 26,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _startGame,
                      child: Text('Başla', style: TextStyle(fontSize: 20)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Nesne: $_currentObject',
                      style: TextStyle(
                          fontSize: 26,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Kalan Süre: $_timeLeft',
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Puan: $_score',
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    if (_currentObject != null) ...[
                      Text(
                        'Ağırlığı Tahmin Et:',
                        style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      // Butonları 2x2 düzenlemek için Row ve Column kullanıyoruz
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => _checkAnswer(_options[0]),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.teal,
                                    padding: EdgeInsets.all(20),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  child: Text('${_options[0]} gram',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white)),
                                ),
                              ),
                              SizedBox(width: 10), // Butonlar arasında boşluk
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => _checkAnswer(_options[1]),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.teal,
                                    padding: EdgeInsets.all(20),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  child: Text('${_options[1]} gram',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white)),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20), // Satırlar arasında boşluk
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => _checkAnswer(_options[2]),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.teal,
                                    padding: EdgeInsets.all(20),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  child: Text('${_options[2]} gram',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white)),
                                ),
                              ),
                              SizedBox(width: 10), // Butonlar arasında boşluk
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => _checkAnswer(_options[3]),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.teal,
                                    padding: EdgeInsets.all(20),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  child: Text('${_options[3]} gram',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}
