import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const SmartIrrigationApp());
}

class SmartIrrigationApp extends StatelessWidget {
  const SmartIrrigationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistem Irigasi Pintar',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const DashboardPage(),
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool pumpIsOn = true; 
  int currentIndex = 0; 

  final List<FlSpot> soilMoistureData = [
    FlSpot(1, 50),
    FlSpot(2, 45),
    FlSpot(3, 43),
    FlSpot(4, 47),
    FlSpot(5, 44),
  ];

  final List<FlSpot> temperatureData = [
    FlSpot(1, 22),
    FlSpot(2, 24),
    FlSpot(3, 23),
    FlSpot(4, 25),
    FlSpot(5, 24),
  ];

  final List<FlSpot> humidityData = [
    FlSpot(1, 60),
    FlSpot(2, 62),
    FlSpot(3, 59),
    FlSpot(4, 63),
    FlSpot(5, 61),
  ];

  void togglePump() {
    setState(() {
      pumpIsOn = !pumpIsOn;
    });
  }

  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget body;

    switch (currentIndex) {
      case 0:
        body = _buildHomePage();
        break;
      case 1:
        body = const SettingsPage();
        break;
      case 2:
        body = const AboutPage();
        break;
      default:
        body = _buildHomePage();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Irigasi Pintar'),
      ),
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Pengaturan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Tentang',
          ),
        ],
        currentIndex: currentIndex,
        onTap: onTabTapped,
      ),
    );
  }

  Widget _buildHomePage() {
    return Column(
      children: [
        const GreetingCard(username: "User"),
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StatisticsPage(
                        title: "Kelembaban Tanah",
                        data: soilMoistureData,
                      ),
                    ),
                  );
                },
                child: SensorCard(
                  title: "Kelembaban Tanah",
                  value: "45%", 
                  icon: Icons.water_drop,
                ),
              ),
              PumpCard(
                title: "Status Pompa",
                isOn: pumpIsOn,  
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StatisticsPage(
                        title: "Suhu",
                        data: temperatureData,
                      ),
                    ),
                  );
                },
                child: IndicatorCard(
                  title: "Suhu",
                  value: "24°C", 
                  icon: Icons.thermostat,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StatisticsPage(
                        title: "Kelembaban",
                        data: humidityData,
                      ),
                    ),
                  );
                },
                child: IndicatorCard(
                  title: "Kelembaban",
                  value: "60%",  
                  icon: Icons.cloud,
                ),
              ),
              ControlPumpCard(
                isOn: pumpIsOn,
                onPressed: togglePump,
              ),
              WaterTankCard(
                title: "Kapasitas Tangki Air",
                capacity: "100L",
                isLow: false,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class GreetingCard extends StatelessWidget {
  final String username;

  const GreetingCard({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage('assets/avatar.png'), 
            ),
            const SizedBox(width: 16),
            Text(
              'Halo, $username!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class SensorCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const SensorCard({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: Colors.blue),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 10),
          Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class PumpCard extends StatelessWidget {
  final String title;
  final bool isOn;

  const PumpCard({
    Key? key,
    required this.title,
    required this.isOn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isOn ? Icons.power : Icons.power_off,
            size: 48,
            color: isOn ? Colors.green : Colors.red,
          ),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 10),
          Text(isOn ? "Nyala" : "Mati", style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class IndicatorCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const IndicatorCard({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: Colors.blue), 
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 10),
          Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class ControlPumpCard extends StatelessWidget {
  final bool isOn;
  final VoidCallback onPressed;

  const ControlPumpCard({
    Key? key,
    required this.isOn,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.control_camera, size: 48, color: Colors.orange),
          const SizedBox(height: 10),
          const Text("Kontrol Pompa", style: TextStyle(fontSize: 20)),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: onPressed,
            child: Text(isOn ? "Matikan Pompa" : "Nyalakan Pompa"),
          ),
        ],
      ),
    );
  }
}

class WaterTankCard extends StatelessWidget {
  final String title;
  final String capacity;
  final bool isLow;

  const WaterTankCard({
    Key? key,
    required this.title,
    required this.capacity,
    required this.isLow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.water, size: 48, color: Colors.blue),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 10),
          Text(capacity, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          if (isLow) const Text("Tingkat air rendah!", style: TextStyle(color: Colors.red)),
        ],
      ),
    );
  }
}

class StatisticsPage extends StatelessWidget {
  final String title;
  final List<FlSpot> data;

  const StatisticsPage({
    Key? key,
    required this.title,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$title Statistik'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Data $title dari Waktu ke Waktu',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 300,
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: data,
                      isCurved: true,
                      color: Colors.blue, 
                      barWidth: 4,
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                  ),
                  gridData: FlGridData(show: true),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Data ditampilkan sebagai grafik garis yang menunjukkan perubahan seiring waktu.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Halaman Pengaturan'));
  }
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Tentang Sistem Irigasi Pintar',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              'Aplikasi ini membantu memantau dan mengontrol sistem irigasi secara efisien. '
              'Anda dapat melihat kelembaban tanah, suhu, kelembaban, dan mengontrol pompa langsung dari dashboard ini.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
             Text(
              'Developed by Kelompok Veteran',
              style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}
