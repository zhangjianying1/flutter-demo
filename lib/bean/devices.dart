import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:json_annotation/json_annotation.dart';
part 'devices.g.dart';
@JsonSerializable(nullable: false)
class Devices {
  static Devices _instance;
  /// The name of the underlying board, like "goldfish".
  final String board;

  /// The system bootloader version number.
  final String bootloader;

  /// The consumer-visible brand with which the product/hardware will be associated, if any.
  final String brand;

  /// The name of the industrial design.
  final String device;

  /// A build ID string meant for displaying to the user.
  final String display;

  /// A string that uniquely identifies this build.
  final String fingerprint;

  /// The name of the hardware (from the kernel command line or /proc).
  final String hardware;

  /// Hostname.
  final String host;

  /// Either a changelist number, or a label like "M4-rc20".
  final String id;

  /// The manufacturer of the product/hardware.
  final String manufacturer;

  /// The end-user-visible name for the end product.
  final String model;

  /// The name of the overall product.
  final String product;

  /// Comma-separated tags describing the build, like "unsigned,debug".
  final String tags;

  /// The type of build, like "user" or "eng".
  final String type;

  /// `false` if the application is running in an emulator, `true` otherwise.
  final bool isPhysicalDevice;

  /// The Android hardware device ID that is unique between the device + user and app signing.
  final String androidId;
  Devices({
  this.board,
  this.bootloader,
  this.brand,
  this.device,
  this.display,
  this.fingerprint,
  this.hardware,
  this.host,
  this.id,
  this.manufacturer,
  this.model,
  this.product,
  this.tags,
  this.type,
  this.isPhysicalDevice,
  this.androidId,
  });
  factory Devices.fromJson(Map<String, dynamic> json) => _$DevicesFromJson(json);
  Map<String, dynamic> toJson() => _$DevicesToJson(this);
  static getInfo() async{
    if (_instance != null) return _instance;
    DeviceInfoPlugin deviceInfo = new DeviceInfoPlugin();
    if(Platform.isAndroid) {
      AndroidDeviceInfo map = await deviceInfo.androidInfo;
      _instance = Devices(
        board: map.board,
        bootloader: map.bootloader,
        brand: map.brand,
        device: map.device,
        display: map.display,
        fingerprint: map.fingerprint,
        hardware: map.hardware,
        host: map.host,
        id: map.id,
        manufacturer: map.manufacturer,
        model: map.model,
        product: map.product,
        tags: map.tags,
        type: map.type,
        isPhysicalDevice: map.isPhysicalDevice,
        androidId: map.androidId
      );
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo =  await deviceInfo.iosInfo;
      return iosInfo;
    }
    return _instance;
  }
}