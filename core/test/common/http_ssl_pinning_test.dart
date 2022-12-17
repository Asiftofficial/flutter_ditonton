import 'package:core/utils/shared.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  const BASE_URL = 'https://api.themoviedb.org/3';
  group('Http SSL Pinning', () {
    test('should response 200 when url is correct', () async {
      final client = await Shared.createLEClient(isTestMode: true);
      final response =
          await client.get(Uri.parse('$BASE_URL/tv/airing_today?$API_KEY'));
      expect(response.statusCode, 200);
      client.close();
    });
  });
}
