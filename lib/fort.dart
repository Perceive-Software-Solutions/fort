
import 'dart:async';

import 'package:flutter/services.dart';

class Fort {
  static const MethodChannel _channel = MethodChannel('fort');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
