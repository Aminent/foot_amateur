class AppConfig {
  // Configuration options - UNCOMMENT the one you want to use:
  
  // Option 1: Local network (same WiFi as backend)
  // static const String apiBaseUrl = 'http://192.168.1.10:5000/api';
  // static const String socketUrl = 'http://192.168.1.10:5000';
  
  // Option 2: Ngrok (for external access) - CURRENTLY ACTIVE
  static const String apiBaseUrl = 'https://epineurial-itzel-enquiringly.ngrok-free.dev/api';
  static const String socketUrl = 'https://epineurial-itzel-enquiringly.ngrok-free.dev';
  
  // Option 3: Android Emulator (if running on Android emulator)
  // static const String apiBaseUrl = 'http://10.0.2.2:5000/api';
  // static const String socketUrl = 'http://10.0.2.2:5000';
  
  // Option 4: Environment variable (for production)
  // static const String apiBaseUrl = String.fromEnvironment('API_BASE_URL', defaultValue: 'http://192.168.1.10:5000/api');
  // static const String socketUrl = String.fromEnvironment('SOCKET_URL', defaultValue: 'http://192.168.1.10:5000');
}