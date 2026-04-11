import 'dart:io';

Future<void> main() async {
  final wasmUrl = Uri.parse(
      'https://github.com/simolus3/sqlite3.dart/releases/download/sqlite3-2.4.0/sqlite3.wasm');
  final targetFile = File('web/sqlite3.wasm');

  stdout.writeln('Downloading sqlite3.wasm from $wasmUrl...');
  try {
    final client = HttpClient();
    final request = await client.getUrl(wasmUrl);
    final response = await request.close();

    if (response.statusCode == 200 || response.statusCode == 302) {
      final bytes = await response.expand((e) => e).toList();
      await targetFile.writeAsBytes(bytes);
      stdout.writeln(
          'Successfully downloaded sqlite3.wasm to ${targetFile.path}');
      stdout.writeln('File size: ${await targetFile.length()} bytes');
    } else {
      stdout.writeln(
          'Failed to download: ${response.statusCode} ${response.reasonPhrase}');
    }
  } catch (e) {
    stdout.writeln('Error downloading file: $e');
  }
}
