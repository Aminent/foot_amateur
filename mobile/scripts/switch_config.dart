import 'dart:io';

void main() {
  print('🔧 Foot Amateur - Configuration Switcher');
  print('=====================================\n');
  
  print('Select configuration:');
  print('1. Local Network (same WiFi as backend)');
  print('2. Ngrok (external access)');
  print('3. Android Emulator');
  print('4. Exit\n');
  
  stdout.write('Enter your choice (1-4): ');
  String? choice = stdin.readLineSync();
  
  switch (choice) {
    case '1':
      _updateConfig('local');
      break;
    case '2':
      _updateConfig('ngrok');
      break;
    case '3':
      _updateConfig('emulator');
      break;
    case '4':
      print('👋 Goodbye!');
      break;
    default:
      print('❌ Invalid choice. Please try again.');
  }
}

void _updateConfig(String type) {
  final file = File('../lib/app_config.dart');
  
  String configContent;
  switch (type) {
    case 'local':
      configContent = '''class AppConfig {
  // Configuration: Local Network (same WiFi as backend)
  static const String apiBaseUrl = 'http://192.168.1.10:5000/api';
  static const String socketUrl = 'http://192.168.1.10:5000';
  
  // Commented options:
  // static const String apiBaseUrl = 'https://YOUR_NGROK_URL.ngrok-free.app/api';
  // static const String socketUrl = 'https://YOUR_NGROK_URL.ngrok-free.app';
  // static const String apiBaseUrl = 'http://10.0.2.2:5000/api';
  // static const String socketUrl = 'http://10.0.2.2:5000';
}''';
      print('✅ Switched to LOCAL NETWORK configuration');
      break;
      
    case 'ngrok':
      configContent = '''class AppConfig {
  // Configuration: Ngrok (external access)
  // Replace YOUR_NGROK_URL with your actual ngrok URL
  static const String apiBaseUrl = 'https://YOUR_NGROK_URL.ngrok-free.app/api';
  static const String socketUrl = 'https://YOUR_NGROK_URL.ngrok-free.app';
  
  // Commented options:
  // static const String apiBaseUrl = 'http://192.168.1.10:5000/api';
  // static const String socketUrl = 'http://192.168.1.10:5000';
  // static const String apiBaseUrl = 'http://10.0.2.2:5000/api';
  // static const String socketUrl = 'http://10.0.2.2:5000';
}''';
      print('✅ Switched to NGROK configuration');
      print('⚠️  Remember to replace YOUR_NGROK_URL with your actual ngrok URL!');
      break;
      
    case 'emulator':
      configContent = '''class AppConfig {
  // Configuration: Android Emulator
  static const String apiBaseUrl = 'http://10.0.2.2:5000/api';
  static const String socketUrl = 'http://10.0.2.2:5000';
  
  // Commented options:
  // static const String apiBaseUrl = 'http://192.168.1.10:5000/api';
  // static const String socketUrl = 'http://192.168.1.10:5000';
  // static const String apiBaseUrl = 'https://YOUR_NGROK_URL.ngrok-free.app/api';
  // static const String socketUrl = 'https://YOUR_NGROK_URL.ngrok-free.app';
}''';
      print('✅ Switched to ANDROID EMULATOR configuration');
      break;
      
    default:
      return;
  }
  
  file.writeAsStringSync(configContent);
  print('\n📁 Configuration updated in lib/app_config.dart');
  print('🔄 Restart your app to apply changes');
}
