import 'package:flutter/material.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Atur Jadwal Pakan')),
      body: const Center(child: Text('Halaman Atur Jadwal')),
    );
  }
}