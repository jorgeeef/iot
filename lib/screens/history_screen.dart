import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/database_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final DatabaseService _databaseService = DatabaseService();
  List<Map<String, dynamic>> _readings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    try {
      final readings = await _databaseService.getSensorHistory();
      setState(() {
        _readings = readings;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading history: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Map<String, List<Map<String, dynamic>>> _groupByDate() {
    final grouped = <String, List<Map<String, dynamic>>>{};
    
    for (var reading in _readings) {
      final timestamp = reading['timestamp'] as String;
      final date = timestamp.split(' ')[0]; // Get just the date part
      
      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(reading);
    }
    
    return Map.fromEntries(
      grouped.entries.toList()
        ..sort((a, b) => b.key.compareTo(a.key)) // Sort dates in descending order
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final groupedReadings = _groupByDate();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sensor History'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: groupedReadings.length,
        itemBuilder: (context, index) {
          final date = groupedReadings.keys.elementAt(index);
          final readings = groupedReadings[date]!;
          
          return ExpansionTile(
            title: Text(
              DateFormat('MMMM d, yyyy').format(DateTime.parse(date)),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            children: readings.map((reading) {
              final time = reading['timestamp'].toString().split(' ')[1];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        time,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildDataRow('Plant 1', [
                        _buildDataItem('Moisture', '${reading['plant1_moisture']}'),
                        _buildDataItem('Light', '${reading['plant1_light']}'),
                        _buildDataItem('Rain', reading['plant1_rain'] == 1 ? 'Yes' : 'No'),
                        _buildDataItem('Pump', reading['plant1_pump'] == 1 ? 'On' : 'Off'),
                      ]),
                      const SizedBox(height: 8),
                      _buildDataRow('Plant 2', [
                        _buildDataItem('Moisture', '${reading['plant2_moisture']}'),
                        _buildDataItem('Light', '${reading['plant2_light']}'),
                        _buildDataItem('Rain', reading['plant2_rain'] == 1 ? 'Yes' : 'No'),
                        _buildDataItem('Pump', reading['plant2_pump'] == 1 ? 'On' : 'Off'),
                      ]),
                      const SizedBox(height: 8),
                      _buildDataRow('Environment', [
                        _buildDataItem('Temperature', '${reading['temperature']}°C'),
                        _buildDataItem('Humidity', '${reading['humidity']}%'),
                        _buildDataItem('Gas', '${reading['gas']}'),
                        _buildDataItem('Water Tank', reading['water_tank'] == 1 ? 'Full' : 'Empty'),
                      ]),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Widget _buildDataRow(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        const SizedBox(height: 4),
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: items,
        ),
      ],
    );
  }

  Widget _buildDataItem(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$label: $value',
        style: const TextStyle(fontSize: 14),
      ),
    );
  }
} 