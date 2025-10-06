# Simple Web Server

A basic web server written in Dart that displays custom text with colored backgrounds.

## Running the server

```bash
dart run bin/simpleweb.dart --help
```

## Examples

Display "Hello World" with a blue background:
```bash
dart run bin/simpleweb.dart --text "Hello World" --color blue
```

Use short arguments:
```bash
dart run bin/simpleweb.dart -t "Welcome!" -c red -p 8080
```

Add a message to greetings:
```bash
dart run bin/simpleweb.dart -m "Greetings from our server!" -c green
```

Bind to all addresses:
```bash
dart run bin/simpleweb.dart --address 0.0.0.0 --port 3000
```

## Routes

- `/` - Shows your custom text
- `/hello/yourname` - Personal greeting (supports spaces: `/hello/John%20Doe`)
- `/json` - JSON response with your text
- `/favicon.ico` - @ symbol favicon
