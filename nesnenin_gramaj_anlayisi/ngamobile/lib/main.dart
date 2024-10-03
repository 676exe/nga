import 'package:flutter/material.dart';
import 'dart:async';
import 'mini_game1.dart';
import 'mini_game2.dart';
import 'mini_game3.dart';
import 'mini_game4.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nesnenin Gramaj Anlayışı',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.deepPurple[50],
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 1), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Nesnenin Gramaj Anlayışı',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple[700], // Başlık rengi
              ),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(), // Yüklenme animasyonu
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Oyun Seçim Ekranı'),
        centerTitle: true,
        elevation: 0,
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.count(
              crossAxisCount: 2, // İki sütun
              mainAxisSpacing: 20, // Sütunlar arasındaki boşluk
              crossAxisSpacing: 20, // Satırlar arasındaki boşluk
              children: [
                _buildGameButton(context, 'Gramaj Tahmin Etme', MiniGame1()),
                _buildGameButton(
                    context, 'Gramaj ile Nesne Tahimin Etme', MiniGame2()),
                _buildGameButton(context, 'Süreye Karşı', MiniGame3()),
                _buildGameButton(context, 'Takım Oyunu', MiniGame4()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Butonları oluşturmak için yardımcı metod
  Widget _buildGameButton(BuildContext context, String title, Widget gamePage) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // Buton arka plan rengi
        borderRadius: BorderRadius.circular(15), // Köşe yuvarlama
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4), // Gölgenin konumu
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => gamePage),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent, // Şeffaf arka plan
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), // Köşe yuvarlama
          ),
          elevation: 0, // Buton gölgesi
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            title,
            style: TextStyle(
                fontSize: 20, color: Colors.deepPurple), // Buton metni
          ),
        ),
      ),
    );
  }
}
