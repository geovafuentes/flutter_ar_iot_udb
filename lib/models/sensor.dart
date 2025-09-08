class Sensor {
  final int id;
  final double temperature;
  final double humidity;
  final String location;

  Sensor({
    required this.id,
    required this.temperature,
    required this.humidity,
    required this.location,
  });

  factory Sensor.fromJson(Map<String, dynamic> json) {
    return Sensor(
      id: json['sensorId'],
      temperature: json['temperature'].toDouble(),
      humidity: json['humidity'].toDouble(),
      location: json['location'],
    );
  }
}
