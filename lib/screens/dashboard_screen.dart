import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/firebase_service.dart';
import '../models/sensor_data.dart';
import '../models/feeding_log.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Feeder Dashboard'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder<SensorData>(
                stream: _firebaseService.getSensorDataStream(),
                builder: (context, snapshot) {
                  final data = snapshot.data;
                  final bool isOnline = data?.isOnline ?? false;
                  final double phValue = data?.phValue ?? 0.0;
                  final bool isPhSafe = data?.isPhSafe ?? false;

                  return Column(
                    children: [
                      Card(
                        color: isOnline ? Colors.green.shade50 : Colors.red.shade50,
                        child: ListTile(
                          leading: Icon(
                            isOnline ? Icons.wifi : Icons.wifi_off,
                            color: isOnline ? Colors.green : Colors.red,
                          ),
                          title: Text(
                            isOnline ? 'Perangkat Online' : 'Perangkat Offline',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isOnline ? Colors.green.shade900 : Colors.red.shade900,
                            ),
                          ),
                          subtitle: Text(
                            data != null
                                ? 'Update terakhir: ${DateFormat('HH:mm:ss').format(data.lastUpdated)}'
                                : 'Menunggu data...',
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Card(
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Kualitas Air (pH)',
                                    style: TextStyle(fontSize: 14, color: Colors.grey),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    phValue.toStringAsFixed(1),
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: isPhSafe ? Colors.teal : Colors.orange.shade800,
                                    ),
                                  ),
                                ],
                              ),
                              Chip(
                                avatar: Icon(
                                  isPhSafe ? Icons.check_circle : Icons.warning,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                label: Text(
                                  isPhSafe ? 'Aman (6.5 - 8.5)' : 'Perlu Perhatian',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                backgroundColor: isPhSafe ? Colors.green : Colors.orange.shade800,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
              const Text(
                'Aktivitas Pakan Terakhir',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              StreamBuilder<List<FeedingLog>>(
                stream: _firebaseService.getFeedingLogsStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final logs = snapshot.data ?? [];
                  if (logs.isEmpty) {
                    return const Card(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(child: Text('Belum ada riwayat pakan.')),
                      ),
                    );
                  }

                  final lastLog = logs.first;
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                        child: const Icon(Icons.set_meal),
                      ),
                      title: Text('${lastLog.grams} Gram Pakan Keluar'),
                      subtitle: Text(
                        'Metode: ${lastLog.triggerType.toUpperCase()} • ${DateFormat('dd MMM yyyy, HH:mm').format(lastLog.timestamp)}',
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}