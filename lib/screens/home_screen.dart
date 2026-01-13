import 'package:flutter/material.dart';
import '../connections/ssh.dart';
import '../utils/kml_makers.dart';
import 'settings_page.dart';

const String logoUrl = 'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgXmdNgBTXup6bdWew5RzgCmC9pPb7rK487CpiscWB2S8OlhwFHmeeACHIIjx4B5-Iv-t95mNUx0JhB_oATG3-Tq1gs8Uj0-Xb9Njye6rHtKKsnJQJlzZqJxMDnj_2TXX3eA5x6VSgc8aw/s320-rw/LOGO+LIQUID+GALAXY-sq1000-+OKnoline.png';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SSH ssh = SSH();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LG Control Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage())),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              children: [
                _buildCard(
                  icon: Icons.image,
                  label: 'Show Logo',
                  color: Colors.blueAccent,
                  onTap: () async {
                    String kml = KMLMakers.screenOverlayImage(logoUrl, 0.02, 0.95);
                    await ssh.uploadKml(kml, 'slave_3.kml');
                  },
                ),
                _buildCard(
                  icon: Icons.terrain,
                  label: 'Show Pyramid',
                  color: Colors.orangeAccent,
                  onTap: () async {
                    // FIX: Logic moved to SSH class
                    await ssh.setPyramid(
                        KMLMakers.pyramid(),
                        KMLMakers.lookAt(23.2156, 72.6369, 5000, 45, 0)
                    );
                  },
                ),
                _buildCard(
                  icon: Icons.home,
                  label: 'Fly Home (Surat)',
                  color: Colors.green,
                  onTap: () async {
                    await ssh.flyTo(KMLMakers.lookAt(21.1702, 72.8311, 5000, 0, 0));
                  },
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Divider(thickness: 2),
            const Text("Cleaning Tools", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: _buildCard(
                    icon: Icons.clear,
                    label: 'Clean Logo',
                    color: Colors.deepOrange,
                    onTap: () => ssh.cleanLogo(),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _buildCard(
                    icon: Icons.delete_sweep,
                    label: 'Clean KMLs',
                    color: Colors.red,
                    onTap: () => ssh.cleanPyramid(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: color,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          height: 120,
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.white),
              const SizedBox(height: 10),
              Text(label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}