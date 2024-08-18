import 'package:client/utils/auth_user.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constants {
  static final String apiBaseUrl = dotenv.get('API_BASE_URL', fallback: "");
  static Future<String?> getApiToken() async {
    return await AuthUser.getToken('operator_auth');
  }
}
