import 'package:flutter/material.dart';
import 'dart:async';
import 'mini_game1.dart'; // Mini oyun 1 sayfası
import 'mini_game2.dart'; // Mini oyun 2 sayfası
import 'mini_game3.dart'; // Mini oyun 3 sayfası
import 'mini_game4.dart'; // Mini oyun 3 sayfası
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
        scaffoldBackgroundColor: Colors.deepPurple[50], // Arka plan rengi
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
    // 3 saniye sonra ana ekrana yönlendirme
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
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // İlk buton
            _buildGameButton(context, 'Mini Oyun 1', MiniGame1()),
            // İkinci buton
            _buildGameButton(context, 'Mini Oyun 2', MiniGame2()),
            // Üçüncü buton
            _buildGameButton(context, 'Mini Oyun 3', MiniGame3()),
             _buildGameButton(context, 'Mini Oyun 4', MiniGame4()),
          ],
        ),
      ),
    );
  }

  // Butonları oluşturmak için yardımcı metod
  Widget _buildGameButton(BuildContext context, String title, Widget gamePage) {
    return Container(
      margin: EdgeInsets.all(10), // Butonlar arasındaki boşluk
      width: 150, // Buton genişliği
      height: 150, // Buton yüksekliği
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => gamePage),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple, // Buton rengi
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), // Köşe yuvarlama
          ),
          elevation: 5, // Buton gölgesi
        ),
        child: Text(
          title,
          style: TextStyle(fontSize: 20, color: Colors.white), // Buton metni
        ),
      ),
    );
  }
}
