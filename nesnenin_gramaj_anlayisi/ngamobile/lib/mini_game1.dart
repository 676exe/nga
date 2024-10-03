import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

class MiniGame1 extends StatefulWidget {
  @override
  _MiniGame1State createState() => _MiniGame1State();
}

class _MiniGame1State extends State<MiniGame1> {
  final TextEditingController _controller = TextEditingController();
  String? _objectName;
  int? _weight;
  List<int> _options = [];

  Future<void> _getWeight() async {
    final response =
        await http.get(Uri.parse('http://192.168.1.103:8080/data'));

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
      if (!options.contains(randomWeight)) {
        options.add(randomWeight);
      }
    }

    options.shuffle(); // Seçenekleri karıştır
    return options;
  }

  void _checkAnswer(int selectedOption) {
    if (selectedOption == _weight) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Doğru cevap! 🎉", style: TextStyle(color: Colors.green)),
        duration: Duration(seconds: 2),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Yanlış cevap! ❌ Doğru cevap: $_weight gram",
            style: TextStyle(color: Colors.red)),
        duration: Duration(seconds: 4),
      ));
    }

    // 2 saniye bekleyip yeni soru için nesne ismini isteme
    Future.delayed(Duration(seconds: 2), () {
      _controller.clear(); // Önceki ismi temizle
      _weight = null; // Ağırlığı sıfırla
      _options.clear(); // Seçenekleri temizle
      setState(() {}); // Arayüzü güncelle
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Nesne Gramaj Tahmini', style: TextStyle(color: Colors.white)),
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
              Text(
                'Nesnenin ismini girin:',
                style: TextStyle(
                    fontSize: 26,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Örneğin: Kalem',
                    hintStyle: TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: Colors.deepPurple[600],
                  ),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _objectName = _controller.text;
                  _getWeight();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                ),
                child: Text('Ağırlığı Al'),
              ),
              SizedBox(height: 40),
              if (_weight != null) ...[
                Text(
                  'Şıkları Göster:',
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
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
                            child: Text('A: ${_options[0]} gram',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white)),
                          ),
                        ),
                        SizedBox(width: 10),
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
                            child: Text('B: ${_options[1]} gram',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white)),
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
                            onPressed: () => _checkAnswer(_options[2]),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              padding: EdgeInsets.all(20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: Text('C: ${_options[2]} gram',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white)),
                          ),
                        ),
                        SizedBox(width: 10),
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
                            child: Text('D: ${_options[3]} gram',
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
