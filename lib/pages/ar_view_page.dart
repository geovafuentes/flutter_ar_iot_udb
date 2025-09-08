import 'package:ar_flutter_plugin_updated/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin_updated/datatypes/node_types.dart';
import 'package:ar_flutter_plugin_updated/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin_updated/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin_updated/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin_updated/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin_updated/models/ar_node.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;
import '../models/sensor.dart';

class ARViewPage extends StatefulWidget {
  final Sensor sensor;
  const ARViewPage({super.key, required this.sensor});

  @override
  // ignore: library_private_types_in_public_api
  _ARViewPageState createState() => _ARViewPageState();
}

class _ARViewPageState extends State<ARViewPage> {
  late ARSessionManager arSessionManager;
  late ARObjectManager arObjectManager;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("AR Sensor ${widget.sensor.id}")),
      body: Stack(
        children: [
          ARView(onARViewCreated: onARViewCreated),
          Positioned(
            top: 20,
            left: 20,
            child: Card(
              color: Colors.white38,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Temp: ${widget.sensor.temperature} °C\n'
                  'Hum: ${widget.sensor.humidity} %\n'
                  'Ubicación: ${widget.sensor.location}',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onARViewCreated(
    ARSessionManager sessionManager,
    ARObjectManager objectManager,
    ARAnchorManager anchorManager,
    ARLocationManager locationManager,
  ) {
    arSessionManager = sessionManager;
    arObjectManager = objectManager;

    // Agregar modelo 3D como referencia
    final sensorModel = ARNode(
      type: NodeType.webGLB,
      uri: "assets/models/sensor_model1.glb",
      scale: Vector3(0.2, 0.2, 0.2),
      position: Vector3(0, 0, -1),
    );

    arObjectManager.addNode(sensorModel);
  }
}
