import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../connections/ssh.dart';

class SettingsPage extends StatefulWidget {//this screen is going to change -> adding text in the box, loading spinner.
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _ip = TextEditingController();
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _port = TextEditingController();

  bool _loading = false; // to avoid multiple clicks by user and crashing the app.

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  void dispose() { //to have no memory leak
    for (var c in [_ip, _username, _password, _port]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance(); //phone storage
    setState(() {
      _ip.text = prefs.getString('ipAddress') ?? '';
      _username.text = prefs.getString('username') ?? 'lg';
      _password.text = prefs.getString('password') ?? 'lg';
      _port.text = prefs.getString('sshPort') ?? '22';
    });
  }

  Future<void> _testConnection() async {
    setState(() => _loading = true);

    //save settings
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('ipAddress', _ip.text);
    await prefs.setString('username', _username.text);
    await prefs.setString('password', _password.text);
    await prefs.setString('sshPort', _port.text);

    bool result = await SSH().connect();

    setState(() => _loading = false);

    if (mounted) { //cheking if the setting page exist or not.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result ? 'Connected!' : 'Connection Failed'),
          backgroundColor: result ? Colors.green : Colors.red,
        ),
      );
    }
  }

  //UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Connection Settings')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _input(_ip, 'IP Address'),
            _input(_username, 'Username'),
            _input(_password, 'Password', obscure: true),
            _input(_port, 'Port', type: TextInputType.number),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loading ? null : _testConnection,
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text('Connect'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _input(TextEditingController controller, String label, {bool obscure = false, TextInputType type = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: type,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}