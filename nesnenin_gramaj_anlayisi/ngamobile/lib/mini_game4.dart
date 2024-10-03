import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MiniGame4 extends StatefulWidget {
  @override
  _MiniGame4State createState() => _MiniGame4State();
}

class _MiniGame4State extends State<MiniGame4> {
  final TextEditingController _objectController = TextEditingController();
  List<Map<String, dynamic>> _questions = [];
  int _currentQuestionIndex = 0;
  int _team1Score = 0;
  int _team2Score = 0;
  String _dataValue = '';

  @override
  void initState() {
    super.initState();
  }

  Future<void> _fetchData() async {
    final response =
        await http.get(Uri.parse('http://192.168.1.103:8080/data'));

    if (response.statusCode == 200) {
      setState(() {
        _dataValue = json.decode(response.body)['data']; // Gelen veriyi al
      });
    } else {
      throw Exception('Veri alınamadı');
    }
  }

  void _startGame() {
    _fetchData().then((_) {
      setState(() {
        _questions = _loadQuestions(_objectController.text);
        _currentQuestionIndex = 0;
      });
    });
  }

  List<Map<String, dynamic>> _loadQuestions(String objectName) {
    return [
      {
        'question': '$objectName ile ilgili Soru 1',
        'options': ['Şık 1', 'Şık 2', 'Şık 3', 'Şık 4'],
      },
      {
        'question': '$objectName ile ilgili Soru 2',
        'options': ['Şık 1', 'Şık 2', 'Şık 3', 'Şık 4'],
      },
      // Toplamda 5 soru olmalı
    ];
  }

  void _answerQuestion(int selectedOption) {
    // İlk doğru cevabı bulan takım puan kazanır
    if (selectedOption == 0) {
      // Örnek olarak 1. seçenek doğru
      _team1Score++;
    }
    setState(() {
      _currentQuestionIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Yarışma Oyunu'),
      ),
      body: _questions.isEmpty ? _buildStartScreen() : _buildQuestionScreen(),
    );
  }

  Widget _buildStartScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _objectController,
            decoration: InputDecoration(labelText: 'Nesnenin ismini girin'),
          ),
          ElevatedButton(
            onPressed: _startGame,
            child: Text('Başla'),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionScreen() {
    return Column(
      children: [
        Text(_questions[_currentQuestionIndex]['question']),
        ..._questions[_currentQuestionIndex]['options'].map((option) {
          return ElevatedButton(
            onPressed: () => _answerQuestion(
                _questions[_currentQuestionIndex]['options'].indexOf(option)),
            child: Text(option),
          );
        }).toList(),
      ],
    );
  }
}
