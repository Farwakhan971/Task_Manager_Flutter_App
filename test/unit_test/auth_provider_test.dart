import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:task_manager/models/user.dart';
import 'package:task_manager/providers/auth_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../mocks/mocks.mocks.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group('AuthProvider', () {
    late MockApiService mockApiService;
    late AuthProvider authProvider;

    setUp(() {
      mockApiService = MockApiService();

      SharedPreferences.setMockInitialValues({});

      authProvider = AuthProvider(apiService: mockApiService);
    });

    test('login success', () async {
      final user = User(
        id: 15,
        username: 'kminchelle',
        email: 'kminchelle@qq.com',
        firstName: 'Jeanne',
        lastName: 'Halvorson',
        gender: 'female',
        image: 'https://robohash.org/Jeanne.png?set=set4',
        token:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTUsInVzZXJuYW1lIjoia21pbmNoZWxsZSIsImVtYWlsIjoia21pbmNoZWxsZUBxcS5jb20iLCJmaXJzdE5hbWUiOiJKZWFubmUiLCJsYXN0TmFtZSI6IkhhbHZvcnNvbiIsImdlbmRlciI6ImZlbWFsZSIsImltYWdlIjoiaHR0cHM6Ly9yb2JvaGFzaC5vcmcvSmVhbm5lLnBuZz9zZXQ9c2V0NCIsImlhdCI6MTcxMTIwOTAwMSwiZXhwIjoxNzExMjEyNjAxfQ.F_ZCpi2qdv97grmWiT3h7HcT1prRJasQXjUR4Nk1yo8',
      );

      when(mockApiService.login(any, any)).thenAnswer((_) async => user);

      final result = await authProvider.login('kminchelle', '0lelplR');

      expect(result, true);
      expect(authProvider.user, user);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('user'), isNotNull);
    });

    test('login failure', () async {
      when(mockApiService.login(any, any)).thenAnswer((_) async => null);

      final result = await authProvider.login('kminchelle', '');

      expect(result, false);
      expect(authProvider.user, null);
    });

    test('logout', () async {
      authProvider.logout();

      expect(authProvider.user, null);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('user'), isNull);
    });
  });
}
