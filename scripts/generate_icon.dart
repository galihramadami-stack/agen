import 'dart:io';
import 'dart:typed_data';

// Script to generate Valorant-themed launcher icons for Android
// Run with: dart run scripts/generate_icon.dart

Future<void> main() async {
  // Generate icons at all required Android mipmap sizes
  final sizes = {
    'mipmap-mdpi': 48,
    'mipmap-hdpi': 72,
    'mipmap-xhdpi': 96,
    'mipmap-xxhdpi': 144,
    'mipmap-xxxhdpi': 192,
  };

  for (final entry in sizes.entries) {
    final folderName = entry.key;
    final size = entry.value;
    final pngBytes = _generateValorantIcon(size);
    final dir = Directory('android/app/src/main/res/$folderName');
    if (!dir.existsSync()) dir.createSync(recursive: true);
    final file = File('${dir.path}/ic_launcher.png');
    file.writeAsBytesSync(pngBytes);
    stdout.writeln('Generated ${file.path} (${size}x$size)');
  }

  // Also generate web icon
  final webIcon = _generateValorantIcon(192);
  File('web/icons/Icon-192.png').writeAsBytesSync(webIcon);
  stdout.writeln('Generated web/icons/Icon-192.png');

  final webIcon512 = _generateValorantIcon(512);
  File('web/icons/Icon-512.png').writeAsBytesSync(webIcon512);
  stdout.writeln('Generated web/icons/Icon-512.png');

  stdout.writeln('\nDone! All icons generated.');
}

Uint8List _generateValorantIcon(int size) {
  // We cannot use dart:ui outside of Flutter, so we'll generate a simple
  // PNG manually using a minimal PNG encoder.
  // Instead, let's create a script that uses Flutter's canvas.
  throw UnimplementedError('See alternative approach below');
}
