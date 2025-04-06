import 'package:dio/dio.dart';
import 'package:dio_shaker_interceptor/dio_shaker_interceptor.dart';
import 'package:flutter/material.dart';

void main() {
  final dio = Dio();
  dio.interceptors.add(DioShakerInterceptor());

  runApp(MyApp(dio: dio));
}

class MyApp extends StatelessWidget {
  final Dio dio;

  const MyApp({super.key, required this.dio});

  @override
  Widget build(BuildContext context) {
    ShakerDioDetect.detectShakeAndOpenListCurlScreen(
      buildContext: context,
      navigatorKey: null,
    );
    return MaterialApp(
      title: 'Dio Shaker Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: HomePage(dio: dio),
    );
  }
}

class HomePage extends StatelessWidget {
  final Dio dio;

  const HomePage({super.key, required this.dio});

  Future<void> makeApiCall() async {
    try {
      await dio.get('https://jsonplaceholder.typicode.com/posts/1');
      await dio.post('https://jsonplaceholder.typicode.com/posts', data: {
        'title': 'foo',
        'body': 'bar',
        'userId': 1,
      });
    } catch (e) {
      debugPrint('API call error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dio Shaker Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: makeApiCall,
              child: const Text('Make API Request'),
            ),
          ],
        ),
      ),
    );
  }
}
