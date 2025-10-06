import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:args/args.dart';

// Function to determine contrast color for text visibility
String _getContrastColor(String backgroundColor) {
  // List of light colors that need dark text
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

void main(List<String> arguments) async {
  // Set up argument parser
  final parser = ArgParser()
    ..addOption('text', abbr: 't', defaultsTo: 'Hello, World!', help: 'The text to display on the homepage')
    ..addOption('color', abbr: 'c', defaultsTo: 'white', help: 'Background color for the homepage')
    ..addOption('address', abbr: 'a', defaultsTo: 'localhost', help: 'Address to bind the server to')
    ..addOption('port', abbr: 'p', defaultsTo: '8080', help: 'Port number for the server')
    ..addFlag('help', abbr: 'h', negatable: false, help: 'Show this help message');

  try {
    final results = parser.parse(arguments);

    // Show help if requested
    if (results['help'] as bool) {
      print('Simple Dart Web Server');
      print('');
      print('Usage: dart run bin/simpleweb.dart [options]');
      print('');
      print(parser.usage);
      print('');
      print('Examples:');
      print('  dart run bin/simpleweb.dart --text "Welcome!" --color blue');
      print('  dart run bin/simpleweb.dart -t "Hello World" -c red -p 8081');
      print('  dart run bin/simpleweb.dart --address 0.0.0.0 --port 3000');
      return;
    }

    // Parse arguments
    final displayText = results['text'] as String;
    final backgroundColor = results['color'] as String;
    final address = results['address'] as String;
    final port = int.tryParse(results['port'] as String) ?? 8080;

    // Parse the address
    InternetAddress bindAddress;
    try {
      if (address.toLowerCase() == 'localhost') {
        bindAddress = InternetAddress.loopbackIPv4;
      } else if (address == '0.0.0.0' || address.toLowerCase() == 'any') {
        bindAddress = InternetAddress.anyIPv4;
      } else {
        bindAddress = InternetAddress(address);
      }
    } catch (e) {
      print('Error: Invalid address "$address"');
      print('Use "localhost", "0.0.0.0", or a valid IP address');
      return;
    }

    // Create a router
    final router = Router();

    // Define routes
    router.get('/', (Request request) {
      final html =
          '''
<!DOCTYPE html>
<html>
<head>
    <title>Simple Dart Web Server</title>
    <style>
        body {
            background-color: $backgroundColor;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            font-family: Arial, sans-serif;
        }
        .main-text {
            font-size: 4em;
            font-weight: bold;
            text-align: center;
            color: ${_getContrastColor(backgroundColor)};
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
            padding: 20px;
            border-radius: 10px;
            max-width: 80%;
            word-wrap: break-word;
        }
    </style>
</head>
<body>
    <div class="main-text">$displayText</div>
</body>
</html>
    ''';
      return Response.ok(html, headers: {'Content-Type': 'text/html'});
    });

    router.get('/hello/<name>', (Request request, String name) {
      final html =
          '''
<!DOCTYPE html>
<html>
<head>
    <title>Hello $name - Simple Dart Web Server</title>
    <style>
        body {
            background-color: $backgroundColor;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            font-family: Arial, sans-serif;
        }
        .main-text {
            font-size: 4em;
            font-weight: bold;
            text-align: center;
            color: ${_getContrastColor(backgroundColor)};
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
            padding: 20px;
            border-radius: 10px;
            max-width: 80%;
            word-wrap: break-word;
        }
    </style>
</head>
<body>
    <div class="main-text">Hello, $name!</div>
</body>
</html>
    ''';
      return Response.ok(html, headers: {'Content-Type': 'text/html'});
    });

    router.get('/json', (Request request) {
      return Response.ok(
        '{"message": "This is a JSON response", "timestamp": "${DateTime.now()}"}',
        headers: {'Content-Type': 'application/json'},
      );
    });

    // Favicon route - returns a simple SVG icon with @ symbol
    router.get('/favicon.ico', (Request request) {
      final svg =
          '''
<svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 32 32">
  <rect width="32" height="32" fill="${backgroundColor == 'white' ? '#4285f4' : backgroundColor}"/>
  <text x="16" y="22" font-family="Arial" font-size="20" font-weight="bold" 
        text-anchor="middle" fill="${_getContrastColor(backgroundColor == 'white' ? '#4285f4' : backgroundColor)}">@</text>
</svg>
    ''';
      return Response.ok(svg, headers: {'Content-Type': 'image/svg+xml'});
    });

    // Create a handler
    final handler = Pipeline().addMiddleware(logRequests()).addHandler(router);

    // Start the server
    final server = await serve(handler, bindAddress, port);

    print('Simple Dart Web Server Started');
    print('Server running on http://${server.address.host}:${server.port}');
    print('Displaying: "$displayText" with background color: $backgroundColor');
    print('Available routes:');
    print('  GET / - Custom text with colored background');
    print('  GET /hello/<name> - Personalized greeting');
    print('  GET /json - JSON response');
    print('  GET /favicon.ico - Favicon (SVG)');
    print('');
    print('Use --help or -h for usage information');
  } on FormatException catch (e) {
    print('Error parsing arguments: ${e.message}');
    print('');
    print('Use --help or -h for usage information');
  } catch (e) {
    print('Error starting server: $e');
  }
}
