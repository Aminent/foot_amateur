import 'dart:io';
import 'lib/app_config.dart';

void main() async {
  print('Testing API connection...');
  print('API URL: ${AppConfig.apiBaseUrl}');
  print('Socket URL: ${AppConfig.socketUrl}');
  
  try {
    final client = HttpClient();
    final request = await client.getUrl(Uri.parse('${AppConfig.apiBaseUrl}/auth/profile'));
    request.headers.set('Content-Type', 'application/json');
    
    final response = await request.close();
    print('Response status: ${response.statusCode}');
    
    if (response.statusCode == 200) {
      print('✅ API connection successful!');
    } else {
      print('❌ API connection failed with status: ${response.statusCode}');
    }
    
    client.close();
  } catch (e) {
    print('❌ Connection error: $e');
  }
}
