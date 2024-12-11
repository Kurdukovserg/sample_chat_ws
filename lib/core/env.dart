
abstract class Env {
  static const apiUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://localhost:3000/',
  );

  static const socketUrl = String.fromEnvironment(
    'WS_URL',
    defaultValue: 'http://localhost:3000/',
  );
}
