import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/sensor.dart';

class ApiService {
  // Ajusta esta URL a tu servidor/local o en la nube
  static const String baseUrl = "http://192.168.1.15:3000";

  /// Obtiene todos los sensores
  static Future<List<Sensor>> fetchSensors() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/sensors'))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Sensor.fromJson(json)).toList();
      } else {
        throw Exception('Error HTTP: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception("Error al conectar con API: $e");
    }
  }

  /// Obtiene un sensor por ID
  static Future<Sensor> fetchSensor(int id) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/sensor/$id'))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        return Sensor.fromJson(jsonDecode(response.body));
      } else {
        throw Exception("Error HTTP: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al obtener sensor $id: $e");
    }
  }

  /// Actualiza manualmente un sensor (ejemplo con PUT)
  static Future<bool> updateSensor(int id, Map<String, dynamic> body) async {
    try {
      final response = await http
          .put(
            Uri.parse('$baseUrl/sensor/$id'),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 5));

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      throw Exception("Error al actualizar sensor $id: $e");
    }
  }
}
