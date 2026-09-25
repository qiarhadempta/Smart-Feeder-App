import 'package:flutter/material.dart';

class WaterQualityScreen extends StatelessWidget {
  const WaterQualityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Monitoring pH Air')),
      body: const Center(child: Text('Halaman pH Air')),
    );
  }
}