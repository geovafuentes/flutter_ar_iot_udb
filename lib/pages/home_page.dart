// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'package:flutter/material.dart';
import '../models/sensor.dart';
import '../services/api_service.dart';
import '../widgets/sensor_card.dart';
import 'ar_view_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Sensor> sensors = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() => loading = true);
    try {
      sensors = await ApiService.fetchSensors(); // obtener todos los sensores
    } catch (e) {
      print('Error al obtener sensores: $e');
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sensores IoT")),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : sensors.isNotEmpty
          ? ListView.builder(
              itemCount: sensors.length,
              itemBuilder: (context, index) {
                final sensor = sensors[index];
                return SensorCard(
                  sensor: sensor,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ARViewPage(sensor: sensor),
                      ),
                    );
                  },
                );
              },
            )
          : Center(child: Text("No hay datos")),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchData,
        child: Icon(Icons.refresh),
      ),
    );
  }
}
