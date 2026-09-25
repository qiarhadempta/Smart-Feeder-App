import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  // Wajib dipanggil sebelum menginisialisasi plugin native
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Inisialisasi Firebase
    await Firebase.initializeApp();
    debugPrint("------------------------------------------------");
    debugPrint("🔥 FIREBASE BERHASIL TERHUBUNG DENGAN SUKSES! 🔥");
    debugPrint("------------------------------------------------");
  } catch (e, stacktrace) {
    debugPrint("------------------------------------------------");
    debugPrint("❌ GAGAL MENGHUBUNGKAN FIREBASE:");
    debugPrint(e.toString());
    debugPrint("------------------------------------------------");
  }

  runApp(const SmartFeederApp());
}

class SmartFeederApp extends StatelessWidget {
  const SmartFeederApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Feeder IoT',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Status Firebase'),
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: Text(
            'Cek konsol terminal di Android Studio\nuntuk melihat status koneksi Firebase.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}