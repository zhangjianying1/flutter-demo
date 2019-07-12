// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'devices.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Devices _$DevicesFromJson(Map<String, dynamic> json) {
  return Devices(
      board: json['board'] as String,
      bootloader: json['bootloader'] as String,
      brand: json['brand'] as String,
      device: json['device'] as String,
      display: json['display'] as String,
      fingerprint: json['fingerprint'] as String,
      hardware: json['hardware'] as String,
      host: json['host'] as String,
      id: json['id'] as String,
      manufacturer: json['manufacturer'] as String,
      model: json['model'] as String,
      product: json['product'] as String,
      tags: json['tags'] as String,
      type: json['type'] as String,
      isPhysicalDevice: json['isPhysicalDevice'] as bool,
      androidId: json['androidId'] as String);
}

Map<String, dynamic> _$DevicesToJson(Devices instance) => <String, dynamic>{
      'board': instance.board,
      'bootloader': instance.bootloader,
      'brand': instance.brand,
      'device': instance.device,
      'display': instance.display,
      'fingerprint': instance.fingerprint,
      'hardware': instance.hardware,
      'host': instance.host,
      'id': instance.id,
      'manufacturer': instance.manufacturer,
      'model': instance.model,
      'product': instance.product,
      'tags': instance.tags,
      'type': instance.type,
      'isPhysicalDevice': instance.isPhysicalDevice,
      'androidId': instance.androidId
    };
