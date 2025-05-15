// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sensor_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SensorData _$SensorDataFromJson(Map<String, dynamic> json) => SensorData(
  plant1: PlantData.fromJson(json['plant1'] as Map<String, dynamic>),
  plant2: PlantData.fromJson(json['plant2'] as Map<String, dynamic>),
  environment: EnvironmentData.fromJson(
    json['environment'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$SensorDataToJson(SensorData instance) =>
    <String, dynamic>{
      'plant1': instance.plant1,
      'plant2': instance.plant2,
      'environment': instance.environment,
    };

PlantData _$PlantDataFromJson(Map<String, dynamic> json) => PlantData(
  moisture: (json['moisture'] as num).toInt(),
  light: (json['light'] as num).toInt(),
  rain: json['rain'] as bool,
  pump: json['pump'] as bool,
);

Map<String, dynamic> _$PlantDataToJson(PlantData instance) => <String, dynamic>{
  'moisture': instance.moisture,
  'light': instance.light,
  'rain': instance.rain,
  'pump': instance.pump,
};

EnvironmentData _$EnvironmentDataFromJson(Map<String, dynamic> json) =>
    EnvironmentData(
      temperature: (json['temperature'] as num).toDouble(),
      humidity: (json['humidity'] as num).toDouble(),
      gas: (json['gas'] as num).toInt(),
      waterTank: json['waterTank'] as bool,
    );

Map<String, dynamic> _$EnvironmentDataToJson(EnvironmentData instance) =>
    <String, dynamic>{
      'temperature': instance.temperature,
      'humidity': instance.humidity,
      'gas': instance.gas,
      'waterTank': instance.waterTank,
    };
