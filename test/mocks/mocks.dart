import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/services/api_service.dart';
import 'package:task_manager/services/database.helper.dart';
import 'package:http/http.dart' as http;

@GenerateMocks([ApiService, SharedPreferences, DatabaseHelper, http.Client])
void main() {}
