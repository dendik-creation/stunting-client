import 'package:client/utils/auth_user.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constants {
  static final String apiBaseUrl = dotenv.get('API_BASE_URL', fallback: "");
  static final String appMode = dotenv.get('APP_MODE', fallback: "");
  static final String appVersion = dotenv.get('APP_VERSION', fallback: "");
  static Future<String?> getApiToken() async {
    return await AuthUser.getToken('operator_auth');
  }
}
