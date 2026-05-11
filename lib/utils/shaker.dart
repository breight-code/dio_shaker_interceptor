import 'package:dio_shaker_interceptor/utils/curl_logger.dart';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:dio_shaker_interceptor/features/list_curl/presentation/screen/list_curl_screen.dart';
import 'dart:math' as math;

/// A utility class to detect shake gestures using the device's accelerometer
/// and open the ListCurlScreen when a shake is detected.
class ShakerDioDetect {
  /// Listens for shake gestures and opens the ListCurlScreen if a shake is detected.
  ///
  /// [buildContext] is the current build context, used to navigate to the ListCurlScreen.
  /// [navigatorKey] is an optional key for the navigator, used to obtain the context.
  /// [shakeThresholdGravity] is the threshold for detecting a shake, with a default value of 1.
  static void detectShakeAndOpenListCurlScreen({
    required BuildContext? buildContext,
    required GlobalKey<NavigatorState>? navigatorKey,
    double shakeThresholdGravity = 1,
  }) {
    int lastShakeTimestamp = 0;
    int shakeSlopTimeMs = 500;

    // Listen to the user accelerometer events to detect shakes.
    userAccelerometerEventStream().listen(
      (UserAccelerometerEvent event) {
        double gX = event.x / 9.80665;
        double gY = event.y / 9.80665;
        double gZ = event.z / 9.80665;

        // Calculate the gForce to determine if a shake has occurred.
        double gForce = math.sqrt(gX * gX + gY * gY + gZ * gZ);
        if (gForce > shakeThresholdGravity) {
          final now = DateTime.now().millisecondsSinceEpoch;
          if (lastShakeTimestamp + shakeSlopTimeMs > now) {
            return;
          }
          lastShakeTimestamp = now;
          final context =
              navigatorKey?.currentState?.overlay?.context ?? buildContext;
          if (context != null &&
              context.mounted &&
              !CurlLogs.instance.isAlreadyOpen) {
            CurlLogs.instance.isAlreadyOpen = true;
            Navigator.of(context)
                .push(
              MaterialPageRoute<void>(
                builder: (BuildContext context) => const ListCurlScreen(),
              ),
            )
                .then((_) => CurlLogs.instance.markClosed());
          }
        }
      },
      onError: (e) {
        debugPrint(
          'It seems that your device doesn\'t support User Accelerometer Sensor',
        );
      },
      cancelOnError: true,
    );
  }
}
