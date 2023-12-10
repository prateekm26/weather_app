import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:weather_app/business_layer/util/helper/log_helper.dart';
import 'package:weather_app/data_layer/res/numbers.dart';

/// This class stores information about the device and provides methods
/// to retrieve and set device-specific data.
class DeviceInfo {
  /// Private constructor to prevent instantiation.
  DeviceInfo._privateConstructor();

  /// Static variables to store device information
  static double height = 0.0;
  static double width = 0.0;
  static bool smallDevice = false;
  static bool extraLargeDevice = false;
  static String? release;
  static int? sdkInt;
  static String? manufacturer;
  static String? model;
  static String? deviceId = "abc";
  static String? systemName = "ios";
  static String? version;
  static String? name;
  static String data = "";

  /// Method used to set device information based on the provided BuildContext.
  static void setDeviceInfo(BuildContext context) async {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    smallDevice = getDeviceSize() == DeviceSize.small ||
        getDeviceSize() == DeviceSize.medium;
    extraLargeDevice = getDeviceSize() == DeviceSize.xlarge ||
        getDeviceSize() == DeviceSize.large;
  }

  /// Asynchronously sets device-specific information, including
  /// Android or iOS device details.
  static Future<void> setDeviceId() async {
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;
        release = androidInfo.version.release;
        sdkInt = androidInfo.version.sdkInt;
        manufacturer = androidInfo.manufacturer;
        model = androidInfo.model;
        deviceId = androidInfo.id;
        systemName = "ANDROID";
        data = androidInfo.data.toString();
        LogHelper.logData(
            'Android $release, ID $deviceId, SDK $sdkInt, $manufacturer $model');
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await DeviceInfoPlugin().iosInfo;
        systemName = "IOS";
        version = iosInfo.systemVersion;
        name = iosInfo.name;
        model = iosInfo.model;
        data = iosInfo.data.toString();
        deviceId = iosInfo.identifierForVendor;
        LogHelper.logData('$model, ID $deviceId, $systemName, $version, $name');
      }
    } on Exception catch (e) {
      LogHelper.logError("Error while getting device information's ====> $e");
    }
  }

  /// Method used to return the device size based on screen height.
  static DeviceSize getDeviceSize() {
    if (height > d_850) {
      //iPhone 12 pro max
      return DeviceSize.xlarge;
    } else if (height > d_800) {
      //iPhone 12 pro
      return DeviceSize.large;
    } else if (height > d_750) {
      //iPhone 8
      return DeviceSize.medium;
    } else {
      //iPhone SE
      return DeviceSize.small;
    }
  }

  /// Determines whether the software keyboard is open based on the BuildContext.
  static bool isKeyBoardOpen(BuildContext context) {
    if (MediaQuery.of(context).viewInsets.bottom > d_0) {
      return true;
    } else {
      return false;
    }
  }
}

/// Enum to represent different device sizes
enum DeviceSize {
  small, // Small-sized device
  medium, // Medium-sized device
  large, // Large-sized device
  xlarge, // Extra-large-sized device
}
