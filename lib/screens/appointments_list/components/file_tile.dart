// Helper to build the file row with smart "Open vs Download" logic
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medcare_app/general/themes/components/app_colors.dart';

Widget buildFileTile(BuildContext context, File file) {
  // TODO: Remove the asset later
  final bool isDownloaded =
      file.existsSync() || file.path.startsWith('assets/');

  return ListTile(
    contentPadding: EdgeInsets.zero,
    visualDensity: VisualDensity.compact,
    dense: true,
    leading: const Icon(Icons.picture_as_pdf, color: AppColors.strongRed),
    title: Text(file.path.split('/').last),
    trailing: IconButton(
      // Toggle icon based on local availability
      icon: Icon(
        isDownloaded ? Icons.visibility : Icons.download,
        size: isDownloaded ? 16 : 20,
      ),
      onPressed: () => onFileTap(context, file),
    ),
    onTap: () => onFileTap(context, file),
  );
}

Future<void> onFileTap(BuildContext context, File file) async {
  if (file.existsSync() || file.path.startsWith('assets/')) {
    // Navigate to your pdfrx previewer
    context.push('/pdf-preview', extra: file.path);
  } else {
    // TODO: Logic for downloading would go here
    print("Downloading and then opening: ${file.path}");
    // After download:
    // context.push('/pdf-preview', extra: downloadedPath);
  }
}
