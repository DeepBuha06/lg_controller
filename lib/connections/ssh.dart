import 'dart:async';
import 'package:dartssh2/dartssh2.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SSH {
  SSHClient? _client;
  String? _host; // Cache the host to avoid loading SharedPreferences again

  Future<bool> connect() async {
    final prefs = await SharedPreferences.getInstance();

    // Save to class variable so we can use it later
    _host = prefs.getString('ipAddress') ?? '192.168.100.3';
    final port = int.parse(prefs.getString('sshPort') ?? '22');
    final username = prefs.getString('username') ?? 'lg';
    final password = prefs.getString('password') ?? 'lg';

    //checking if the connection is already there or not.
    if (_client?.isClosed == false) return true;

    try {
      final socket = await SSHSocket.connect(_host!, port);
      _client = SSHClient(
        socket,
        username: username,
        onPasswordRequest: () => password,
      );
      return true;
    } catch (e) {
      print('Connection failed: $e');
      return false;
    }
  }

  Future<void> execute(String command) async {
    if (_client?.isClosed ?? true) {
      bool connected = await connect();
      if (!connected) return;
    }
    try {
      await _client!.run(command);
    } catch (e) {
      print('Execution failed: $e');
    }
  }

  Future<void> uploadKml(String content, String filename) async {
    await execute("cat > /var/www/html/kml/$filename << 'EOF'\n$content\nEOF");
  }

  Future<void> loadKmlViaTxt(String filename) async {
    if (_host == null) await connect();
    if (_host == null) return;

    String url = "http://$_host:81/kml/$filename";
    await execute("echo '$url' > /var/www/html/kmls.txt");
  }

  Future<void> flyTo(String lookAt) async {
    await execute("echo 'flytoview=$lookAt' > /tmp/query.txt");
  }

  Future<void> setPyramid(String kmlContent, String lookAt) async {
    await uploadKml(kmlContent, 'pyramid.kml');
    await loadKmlViaTxt('pyramid.kml');
    await flyTo(lookAt);
  }

  Future<void> cleanLogo() async {
    await uploadKml(blankKML, 'slave_3.kml');
  }

  Future<void> cleanPyramid() async {
    await execute("echo '' > /var/www/html/kmls.txt");
    await uploadKml(blankKML, 'slave_1.kml');
    await execute("echo '' > /tmp/query.txt");
  }
}

const String blankKML = '''<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2">
  <Document></Document>
</kml>''';