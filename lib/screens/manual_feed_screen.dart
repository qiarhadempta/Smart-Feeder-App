import 'package:flutter/material.dart';

class ManualFeedScreen extends StatelessWidget {
  const ManualFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kasih Makan Manual')),
      body: const Center(child: Text('Halaman Kasih Makan Manual')),
    );
  }
}