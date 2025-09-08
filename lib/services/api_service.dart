import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/sensor.dart';

class ApiService {
  // URL base de la API local
  static const String baseUrl = "http://192.168.1.15:3000";

  // Obtener todos los sensores
  static Future<List<Sensor>> fetchSensors() async {
    final response = await http.get(
      Uri.parse('$baseUrl/sensors'),
    ); // ← cambio aquí

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Sensor.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener sensores: ${response.statusCode}');
    }
  }

  // Obtener un sensor por id
  static Future<Sensor> fetchSensor(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/sensor/$id'),
    ); // ← y aquí

    if (response.statusCode == 200) {
      return Sensor.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        'Error al obtener datos del sensor: ${response.statusCode}',
      );
    }
  }
}
