import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String baseUrl = dotenv.env["Url_Base"] ?? "";
}
