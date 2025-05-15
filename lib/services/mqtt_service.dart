import 'dart:async';
import 'dart:convert';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import '../models/sensor_data.dart';

class MQTTService {
  late MqttServerClient client;
  final StreamController<SensorData> _sensorDataController = StreamController<SensorData>.broadcast();
  Stream<SensorData> get sensorDataStream => _sensorDataController.stream;
  StreamSubscription? _subscription;

  Future<void> connect() async {
    // Create a new client instance for each connection
    client = MqttServerClient('192.168.177.10', 'flutter_client_${DateTime.now().millisecondsSinceEpoch}');
    client.port = 1883;
    client.secure = false;
    client.keepAlivePeriod = 60;
    client.connectTimeoutPeriod = 2000;
    client.logging(on: true);

    try {
      await client.connect();
      print('Connected to MQTT broker');
      
      // Subscribe to the topic
      client.subscribe('plant_system/sensor_data', MqttQos.atLeastOnce);
      
      // Set up the subscription
      _subscription = client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> messages) {
        final message = messages[0].payload as MqttPublishMessage;
        final payload = MqttPublishPayload.bytesToStringAsString(message.payload.message);
        print('Received message: $payload');
        
        try {
          final Map<String, dynamic> jsonData = json.decode(payload);
          final sensorData = SensorData.fromJson(jsonData);
          _sensorDataController.add(sensorData);
        } catch (e) {
          print('Error parsing message: $e');
        }
      });
    } catch (e) {
      print('Exception during connection: $e');
      await disconnect();
      rethrow;
    }
  }

  Future<void> disconnect() async {
    try {
      if (_subscription != null) {
        await _subscription!.cancel();
        _subscription = null;
      }
      
      if (client.connectionStatus?.state == MqttConnectionState.connected) {
        client.disconnect();
      }
      
      if (!_sensorDataController.isClosed) {
        await _sensorDataController.close();
      }
      
      print('Disconnected from MQTT broker');
    } catch (e) {
      print('Error during disconnection: $e');
    }
  }
} 