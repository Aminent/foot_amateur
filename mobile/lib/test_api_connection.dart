import 'package:dio/dio.dart';
import 'app_config.dart';

void testApiConnection() async {
  print('Testing API connection...');
  print('API URL: ${AppConfig.apiBaseUrl}');
  
  final dio = Dio();
  
  try {
    final response = await dio.get(
      '${AppConfig.apiBaseUrl}',
      options: Options(
        sendTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );
    
    print('✅ Connection successful!');
    print('Status: ${response.statusCode}');
    print('Data: ${response.data}');
  } catch (e) {
    print('❌ Connection failed: $e');
    
    if (e is DioException) {  // Updated from DioError to DioException
      print('DioException type: ${e.type}');
      print('DioException message: ${e.message}');
      if (e.response != null) {
        print('Response status: ${e.response?.statusCode}');
        print('Response data: ${e.response?.data}');
      }
    }
  }
}
