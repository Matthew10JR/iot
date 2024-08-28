import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_browser_client.dart';

class Readings extends StatefulWidget {
  @override
  _ReadingsState createState() => _ReadingsState();
}

class _ReadingsState extends State<Readings> {
  final client = MqttBrowserClient('wss://cb7241bddd9347ccb8b1403f41271f2b.s1.eu.hivemq.cloud/mqtt', '');
  String temperature = 'N/A';
  String humidity = 'N/A';
  String sound = 'N/A';
  String gas = 'N/A';
  String motion = 'N/A';

  @override
  void initState() {
    super.initState();
    _connect();
  }

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
    } catch (e) {
      print('Exception: $e');
      client.disconnect();
    }

    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print('MQTT client connected');
      client.subscribe('home/garage/#', MqttQos.atMostOnce);

      client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
        final recMess = c[0].payload as MqttPublishMessage;
        final message = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

        setState(() {
          switch (c[0].topic) {
            case 'home/garage/temperature':
              temperature = message;
              break;
            case 'home/garage/humidity':
              humidity = message;
              break;
            case 'home/garage/sound':
              sound = message;
              break;
            case 'home/garage/gas':
              gas = message;
              break;
            case 'home/garage/motion':
              motion = message;
              break;
            default:
              break;
          }
        });
      });
    } else {
      print('Failed to connect');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Readings'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Temperature: $temperature°C'),
              Text('Humidity: $humidity%'),
              Text('Sound: $sound'),
              Text('Gas: $gas'),
              Text('Motion: $motion'),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    client.disconnect();
    super.dispose();
  }
}
