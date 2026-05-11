# dio_shaker_interceptor

The `dio_shaker_interceptor` package provides a Dio interceptor that allows you to easily inspect and debug network requests by shaking your device. It captures and displays detailed information about HTTP requests and responses, facilitating efficient development and troubleshooting.

## Features

-   Capture and display detailed information about HTTP requests and responses.
-   Shake your device to trigger the interceptor and view the network details.
-   View request URL, method, headers, body, query parameters, status, and response.
-   Easily integrate with your existing Dio setup.

## Usage

To use the `dio_shaker_interceptor` package, follow these steps:

1.  **Add Dependency**:

    Add the `dio_shaker_interceptor` package to your `pubspec.yaml` file:

    ```yaml
    dependencies:
      dio_shaker_interceptor: ^0.2.0
    ```

## Configuration

Limita la coda di richieste in memoria (default `200`) e personalizza gli header redatti nei comandi cURL condivisi / copiati:

```dart
import 'package:dio_shaker_interceptor/dio_shaker_interceptor.dart';

void configureDioShaker() {
  CurlLogs.instance.maxItems = 500;
  Utils.redactedHeaderPatterns.add(
    RegExp(r'^x-custom-token$', caseSensitive: false),
  );
}
```

Ogni richiesta ha un `id` stabile (`CurlModel.id`); il match risposta usa internamente `RequestOptions.extra[kDsiRequestIdExtraKey]` (`_dsi_id`).

Per copiare un cURL con header sensibili in chiaro (solo dopo conferma), usa **Copy curl (raw, no redact)** dal menu del dettaglio.

2.  **Import the Package**:

    Import the `dio_shaker_interceptor` package in your Dart file:

    ```dart
    import 'package:dio_shaker_interceptor/dio_shaker_interceptor.dart';
    ```

3.  **Initialize Dio and Add Interceptor**:

    Create an instance of Dio and add the `DioShakerInterceptor` to the interceptors list:

    ```dart
    import 'package:dio/dio.dart';
    import 'package:dio_shaker_interceptor/dio_shaker_interceptor.dart';

    void main() {
      final dio = Dio();

      // Add the DioShakerInterceptor to the Dio instance
      dio.interceptors.add(DioShakerInterceptor());
    }
    ```

4.  **Integrate Shake Detection**:

    Integrate the `detectShakeAndOpenListCurlScreen` function within the `build` method to enable the detection of the device's shake event and subsequently invoke the display of the cURL request list screen.

    ### Example 1 (Recommended)

    In this example, the `navigatorKey` is passed as a parameter, while the `buildContext` is set to `null`. This is the recommended approach.

    ```dart
    @override
    Widget build(BuildContext context) {
      ShakerDioDetect.detectShakeAndOpenListCurlScreen(
        buildContext: null,
        navigatorKey: navigatorKey,
      );
    }
    ```

    **Note:** Ensure you have a global `navigatorKey` defined in your Flutter application.

    ### Example 2 (Alternative)

    In this example, the `buildContext` is passed as a parameter, while the `navigatorKey` is set to `null`.

    ```dart
    @override
    Widget build(BuildContext context) {
      ShakerDioDetect.detectShakeAndOpenListCurlScreen(
        buildContext: context,
        navigatorKey: null,
      );
    }
    ```

    **Note:** This approach relies on the context being available at the time of the shake event.

5.  **Shake Device to Inspect Requests**:

    Shake your device to trigger the interceptor and view the network details. The interceptor will capture and display detailed information about HTTP requests and responses, including URL, method, headers, body, query parameters, status, and response.