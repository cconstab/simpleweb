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

Bind to all addresses:
```bash
dart run bin/simpleweb.dart --address 0.0.0.0 --port 3000
```

## Routes

- `/` - Shows your custom text
- `/hello/yourname` - Personal greeting
- `/json` - JSON response  
- `/favicon.ico` - @ symbol favicon
