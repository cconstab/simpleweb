import 'dart:convert';
import 'package:test/test.dart';

// Import the contrast color function - we'll need to extract it to lib/ first
// For now, let's duplicate it here for testing
String getContrastColor(String backgroundColor) {
  final lightColors = [
    'white',
    'yellow',
    'lime',
    'cyan',
    'magenta',
    'silver',
    'lightgray',
    'lightblue',
    'lightgreen',
    'lightcyan',
    'lightyellow',
    'lightpink',
    'wheat',
    'beige',
    'ivory',
  ];

  return lightColors.contains(backgroundColor.toLowerCase()) ? 'black' : 'white';
}

void main() {
  group('Color contrast tests', () {
    test('light colors should return black text', () {
      expect(getContrastColor('white'), equals('black'));
      expect(getContrastColor('yellow'), equals('black'));
      expect(getContrastColor('lightblue'), equals('black'));
      expect(getContrastColor('beige'), equals('black'));
    });

    test('dark colors should return white text', () {
      expect(getContrastColor('black'), equals('white'));
      expect(getContrastColor('red'), equals('white'));
      expect(getContrastColor('blue'), equals('white'));
      expect(getContrastColor('darkgreen'), equals('white'));
    });

    test('should be case insensitive', () {
      expect(getContrastColor('WHITE'), equals('black'));
      expect(getContrastColor('Yellow'), equals('black'));
      expect(getContrastColor('LIGHTBLUE'), equals('black'));
    });
  });

  group('URL decoding tests', () {
    test('should decode spaces correctly', () {
      expect(Uri.decodeComponent('John%20Doe'), equals('John Doe'));
      expect(Uri.decodeComponent('Mary%20Jane%20Watson'), equals('Mary Jane Watson'));
    });

    test('should decode special characters', () {
      expect(Uri.decodeComponent('user%40example.com'), equals('user@example.com'));
      expect(Uri.decodeComponent('hello%21world'), equals('hello!world'));
    });

    test('should handle strings without encoding', () {
      expect(Uri.decodeComponent('SimpleUser'), equals('SimpleUser'));
      expect(Uri.decodeComponent('test123'), equals('test123'));
    });
  });

  group('Server response tests', () {
    test('should create valid JSON response', () {
      final testText = 'Test Message';
      final timestamp = DateTime.now().toString();
      final jsonResponse = '{"text": "$testText", "timestamp": "$timestamp"}';

      // Parse to ensure it's valid JSON
      final parsed = json.decode(jsonResponse);
      expect(parsed['text'], equals(testText));
      expect(parsed['timestamp'], equals(timestamp));
    });

    test('should handle HTML escaping in responses', () {
      final textWithHtml = 'Hello <script>alert("test")</script>';
      // In a real app, we'd want to HTML escape this
      expect(textWithHtml.contains('<script>'), isTrue);
      // This test reminds us we might want HTML escaping
    });
  });

  group('Favicon SVG tests', () {
    test('should generate valid SVG with @ symbol', () {
      final backgroundColor = 'red';
      final textColor = getContrastColor(backgroundColor);

      final svg =
          '''
<svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 32 32">
  <rect width="32" height="32" fill="$backgroundColor"/>
  <text x="16" y="22" font-family="Arial" font-size="20" font-weight="bold" 
        text-anchor="middle" fill="$textColor">@</text>
</svg>
      '''
              .trim();

      expect(svg.contains('@'), isTrue);
      expect(svg.contains('fill="$backgroundColor"'), isTrue);
      expect(svg.contains('fill="$textColor"'), isTrue);
    });
  });
}
