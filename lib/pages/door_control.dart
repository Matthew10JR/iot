import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_browser_client.dart';

class DoorControl extends StatelessWidget {
  final client = MqttBrowserClient('wss://cb7241bddd9347ccb8b1403f41271f2b.s1.eu.hivemq.cloud/mqtt', '');

  Future<void> _connect() async {
    client.port = 8884;
    client.keepAlivePeriod = 60;

    final connMessage = MqttConnectMessage()
        .withClientIdentifier('FlutterClient')
        .startClean()
        .authenticateAs('hivemq.webclient.1724159031696', '20egJl61p&:T,x.UPXRu');
    client.connectionMessage = connMessage;

    try {
      await client.connect();
      print('Connected to MQTT broker.');
    } catch (e) {
      print('Exception: $e');
      client.disconnect();
    }

    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print('MQTT client connected');
    } else {
      print('Failed to connect');
    }
  }

  void _sendCommand(String command) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(command);
    client.publishMessage('garage/door', MqttQos.atMostOnce, builder.payload!);
  }

  @override
  Widget build(BuildContext context) {
    _connect(); // Connect to MQTT broker when the page is loaded
    return Scaffold(
      appBar: AppBar(
        title: Text('Door Control'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => _sendCommand('open'),
              child: Text('Open Door'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _sendCommand('close'),
              child: Text('Close Door'),
            ),
          ],
        ),
      ),
    );
  }
}
