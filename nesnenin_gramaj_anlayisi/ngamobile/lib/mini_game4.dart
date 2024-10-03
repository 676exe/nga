import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

class MiniGame4 extends StatefulWidget {
  @override
  _MiniGame4State createState() => _MiniGame4State();
}

class _MiniGame4State extends State<MiniGame4> {
  final TextEditingController _objectNameController = TextEditingController();
  List<int> _options = [];
  int _aScore = 0;
  int _bScore = 0;
  bool _isATurn = true; // Sıra kimde olduğunu takip eder
  int? _weight; // Doğru cevap için değişken
  int _remainingQuestions = 5;

  @override
  void dispose() {
    _objectNameController.dispose(); // Controller'ı temizler
    super.dispose();
  }

  Future<void> _getWeight() async {
    final response = await http.get(
        Uri.parse('http://localhost:8080/data')); // Localhost adresini güncelle

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      _weight = jsonResponse['data'][0]; // İlk veri
      _options = _generateRandomOptions(_weight!); // Rastgele 3 şık oluştur
      setState(() {});
    } else {
      throw Exception('Veri alınamadı');
    }
  }

  List<int> _generateRandomOptions(int correctWeight) {
    Random random = Random();
    List<int> options = [];

    options.add(correctWeight); // Doğru değeri ekle

    while (options.length < 4) {
      int randomWeight =
          random.nextInt(20) + 1; // 1 ile 20 arasında rastgele değer
      if (!options.contains(randomWeight) && randomWeight != correctWeight) {
        options.add(randomWeight);
      }
    }

    options.shuffle(); // Seçenekleri karıştır
    return options;
  }

  void _handleAnswer(int selectedAnswer) {
    if (selectedAnswer == _weight) {
      // Doğru cevap verildi
      if (_isATurn) {
        _aScore += 10; // A takımı puan kazandı
      } else {
        _bScore += 10; // B takımı puan kazandı
      }
      _showNotification('Doğru cevap!');
    } else {
      // Yanlış cevap verildi
      _showNotification('Yanlış cevap! Doğru cevap: $_weight g');
    }
    _isATurn = !_isATurn; // Sıra değişimi
    _nextQuestion();
  }

  void _nextQuestion() {
    if (_remainingQuestions > 0) {
      _remainingQuestions--;
      _objectNameController.clear(); // Nesne ismini temizle
      _options.clear(); // Şıkları temizle
      setState(() {}); // Ekranı güncelle
    } else {
      _showResultDialog();
    }
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Oyun Bitti'),
        content: Text(_aScore > _bScore
            ? 'A Takımı kazandı!'
            : _bScore > _aScore
                ? 'B Takımı kazandı!'
                : 'Berabere!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _aScore = 0;
                _bScore = 0;
                _remainingQuestions = 5;
                _isATurn = true; // Başlangıçta A takımı
                _options.clear(); // Şıkları temizle
                _objectNameController.clear(); // Nesne ismi sıfırlansın
              });
            },
            child: Text('Tekrar Oyna'),
          ),
        ],
      ),
    );
  }

  void _showNotification(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2), // Mesajın görünme süresi
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Yarışma Oyunu (Mini Oyun 4)'),
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _objectNameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Örneğin: Kalem',
                hintStyle: TextStyle(color: Colors.white54),
                filled: true,
                fillColor: Colors.deepPurple[600],
              ),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_objectNameController.text.isNotEmpty) {
                  await _getWeight(); // Localhost'tan değeri çek
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              ),
              child: Text('Şıkları Göster'),
            ),
            SizedBox(height: 20),
            if (_options.isNotEmpty) ...[
              Text(
                'Soru: Nesne: ${_objectNameController.text} ağırlığı ne kadardır?',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
              SizedBox(height: 20),
              Text(
                'Sıra: ${_isATurn ? 'A Takımı' : 'B Takımı'}',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              SizedBox(height: 20),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _handleAnswer(_options[0]),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            padding: EdgeInsets.all(20),
                          ),
                          child: Text('${_options[0]} g',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white)),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _handleAnswer(_options[1]),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            padding: EdgeInsets.all(20),
                          ),
                          child: Text('${_options[1]} g',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white)),
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
                          onPressed: () => _handleAnswer(_options[2]),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            padding: EdgeInsets.all(20),
                          ),
                          child: Text('${_options[2]} g',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white)),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _handleAnswer(_options[3]),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            padding: EdgeInsets.all(20),
                          ),
                          child: Text('${_options[3]} g',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'A Takımı Puan: $_aScore',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'B Takımı Puan: $_bScore',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ]
          ],
        ),
      ),
    );
  }
}
