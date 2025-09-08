import 'dart:async';
import 'package:ar_flutter_plugin_updated/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin_updated/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin_updated/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin_updated/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin_updated/managers/ar_session_manager.dart';
import 'package:flutter/material.dart';

import '../models/sensor.dart';
import '../services/api_service.dart';

class ARViewPage extends StatefulWidget {
  final Sensor sensor;
  const ARViewPage({super.key, required this.sensor});

  @override
  State<ARViewPage> createState() => _ARViewPageState();
}

class _ARViewPageState extends State<ARViewPage> {
  late ARSessionManager arSessionManager;
  late ARObjectManager arObjectManager;
  Timer? _pollTimer;

  Sensor? currentSensor;
  bool loading = false;
  String error = "";

  @override
  void initState() {
    super.initState();
    currentSensor = widget.sensor;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startPolling();
    });
  }

  void _startPolling() {
    _pollTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _fetchSensor(),
    );
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    arSessionManager.dispose();
    super.dispose();
  }

  Future<void> _fetchSensor() async {
    setState(() => loading = true);
    try {
      final sensor = await ApiService.fetchSensor(widget.sensor.id);
      if (!mounted) return;
      setState(() => currentSensor = sensor);
    } catch (e) {
      setState(() => error = "Error: $e");
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> _manualRefresh() async {
    await _fetchSensor();
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Datos actualizados")));
    }
  }

  // NUEVOS colores dinámicos para demo
  Color tempColor(double temp) {
    if (temp > 25) return Colors.redAccent; // ahora >25 es rojo
    if (temp < 23) return Colors.blueAccent; // <23 es azul
    return Colors.greenAccent; // entre 23 y 25 es verde
  }

  Color humidityColor(double hum) {
    if (hum > 55) return Colors.blueAccent; // >55 azul
    if (hum < 50) return Colors.orangeAccent; // <50 naranja
    return Colors.greenAccent; // 50-55 verde
  }

  void onARViewCreated(
    ARSessionManager sessionManager,
    ARObjectManager objectManager,
    ARAnchorManager anchorManager,
    ARLocationManager locationManager,
  ) {
    arSessionManager = sessionManager;
    arObjectManager = objectManager;

    arSessionManager.onInitialize(
      showFeaturePoints: false,
      showPlanes: false,
      handlePans: false,
      handleRotation: false,
    );

    arObjectManager.onInitialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sensor ${widget.sensor.id}")),
      body: Stack(
        children: [
          // ARView
          ARView(onARViewCreated: onARViewCreated),

          // Panel centrado
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                color: Colors.black87.withOpacity(0.7),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: currentSensor == null
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Temp: ${currentSensor!.temperature} °C",
                              style: TextStyle(
                                color: tempColor(currentSensor!.temperature),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "Hum: ${currentSensor!.humidity} %",
                              style: TextStyle(
                                color: humidityColor(currentSensor!.humidity),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "Ubicación: ${currentSensor!.location}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            if (loading)
                              const Padding(
                                padding: EdgeInsets.only(top: 8.0),
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                          ],
                        ),
                ),
              ),
            ),
          ),

          // Botón de refresco manual
          Positioned(
            bottom: 30,
            right: 30,
            child: FloatingActionButton(
              onPressed: _manualRefresh,
              child: const Icon(Icons.refresh),
            ),
          ),
        ],
      ),
    );
  }
}
