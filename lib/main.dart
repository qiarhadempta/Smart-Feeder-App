import 'package:flutter/material.dart';

void main() {
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
      home: const TestDashboardScreen(),
    );
  }
}

class TestDashboardScreen extends StatefulWidget {
  const TestDashboardScreen({super.key});

  @override
  State<TestDashboardScreen> createState() => _TestDashboardScreenState();
}

class _TestDashboardScreenState extends State<TestDashboardScreen> {
  double currentPh = 7.2;
  double feedWeightGram = 10.0;
  double foodStoragePercent = 85.0;
  bool isFeeding = false;

  String getPhStatus(double ph) {
    if (ph < 6.5) return 'Asam (Perlu Perhatian)';
    if (ph > 8.5) return 'Basa (Perlu Perhatian)';
    return 'Normal / Aman';
  }

  Color getPhColor(double ph) {
    if (ph < 6.5 || ph > 8.5) return Colors.orange.shade700;
    return Colors.teal;
  }

  void _triggerManualFeed() {
    setState(() => isFeeding = true);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Mengirim perintah pakan (${feedWeightGram.toInt()}g) ke Smart Feeder...'),
        backgroundColor: Colors.teal,
        duration: const Duration(seconds: 2),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => isFeeding = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pemberian pakan berhasil dieksekusi!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Smart Feeder Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. KADAR pH AIR AKUARIUM
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.water_drop, color: Colors.blue),
                            SizedBox(width: 8),
                            Text('Status pH Air', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: getPhColor(currentPh).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            getPhStatus(currentPh),
                            style: TextStyle(color: getPhColor(currentPh), fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      currentPh.toStringAsFixed(1),
                      style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: getPhColor(currentPh)),
                    ),
                    const Text('Sensor PH-4502C • Real-time', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 2. KONDISI STOK PAKAN (LOAD CELL)
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(Icons.inventory_2, size: 40, color: Colors.amber[700]),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Sisa Stok Pakan (Hopper)', style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          LinearProgressIndicator(
                            value: foodStoragePercent / 100,
                            backgroundColor: Colors.grey[200],
                            color: foodStoragePercent > 20 ? Colors.amber[700] : Colors.red,
                            minHeight: 8,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          const SizedBox(height: 4),
                          Text('$foodStoragePercent% tersisa di wadah', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 3. KONTROL PAKAN MANUAL
            const Text('Kontrol Pakan Manual', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Takaran Pakan (Gram):'),
                        Text('${feedWeightGram.toInt()} Gram', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                    Slider(
                      value: feedWeightGram,
                      min: 5,
                      max: 50,
                      divisions: 9,
                      activeColor: Colors.teal,
                      label: '${feedWeightGram.toInt()} g',
                      onChanged: (val) => setState(() => feedWeightGram = val),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: isFeeding ? null : _triggerManualFeed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: isFeeding
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : const Icon(Icons.set_meal),
                        label: Text(isFeeding ? 'Memproses...' : 'Beri Makan Sekarang'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}