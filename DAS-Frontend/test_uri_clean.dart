void main() {
  final uri =
      Uri.parse('http://localhost:63105/?code=123&email=abc#/auto-login');
  print('Host: ${uri.host}');
  print('Path: ${uri.path}');
  print('Clean URL: ${uri.replace(queryParameters: {})}');
}
