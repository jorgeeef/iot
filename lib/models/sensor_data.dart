import 'package:json_annotation/json_annotation.dart';

part 'sensor_data.g.dart';

@JsonSerializable()
class SensorData {
  final PlantData plant1;
  final PlantData plant2;
  final EnvironmentData environment;

  SensorData({
    required this.plant1,
    required this.plant2,
    required this.environment,
  });

  factory SensorData.fromJson(Map<String, dynamic> json) => _$SensorDataFromJson(json);
  Map<String, dynamic> toJson() => _$SensorDataToJson(this);
}

@JsonSerializable()
class PlantData {
  final int moisture;
  final int light;
  final bool rain;
  final bool pump;

  PlantData({
    required this.moisture,
    required this.light,
    required this.rain,
    required this.pump,
  });

  factory PlantData.fromJson(Map<String, dynamic> json) => _$PlantDataFromJson(json);
  Map<String, dynamic> toJson() => _$PlantDataToJson(this);
}

@JsonSerializable()
class EnvironmentData {
  final double temperature;
  final double humidity;
  final int gas;
  @JsonKey(name: 'waterTank')
  final bool waterTank;

  EnvironmentData({
    required this.temperature,
    required this.humidity,
    required this.gas,
    required this.waterTank,
  });

  factory EnvironmentData.fromJson(Map<String, dynamic> json) => _$EnvironmentDataFromJson(json);
  Map<String, dynamic> toJson() => _$EnvironmentDataToJson(this);
} 