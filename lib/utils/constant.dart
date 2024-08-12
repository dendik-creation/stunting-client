import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constants {
  static final String apiBaseUrl = dotenv.get('API_BASE_URL', fallback: "");
}
