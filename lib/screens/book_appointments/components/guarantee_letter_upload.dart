import 'dart:io';
import 'package:flutter/material.dart';
import 'package:medcare_app/general/themes/components/app_colors.dart';
import 'package:medcare_app/general/themes/components/app_spacing.dart';

class GuaranteeLetterUpload extends StatelessWidget {
  final File? uploadedFile;
  final VoidCallback onPickFile;
  final VoidCallback? onRemoveFile;

  const GuaranteeLetterUpload({
    super.key,
    required this.uploadedFile,
    required this.onPickFile,
    this.onRemoveFile,
  });

  @override
  Widget build(BuildContext context) {
    final fileName = uploadedFile?.path.split('/').last ?? "";

    // Split filename for middle truncation
    final String baseName = fileName.contains('.')
        ? fileName.substring(0, fileName.lastIndexOf('.'))
        : fileName;
    final String extension = fileName.contains('.')
        ? fileName.substring(fileName.lastIndexOf('.'))
        : '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upload Guarantee Letter (PDF)',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        AppSpacing.small,
        Text(
          'You may upload this later.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        AppSpacing.medium,
        Row(
          children: [
            SizedBox(
              width: 110,
              child: TextButton.icon(
                onPressed: onPickFile,
                icon: Icon(
                  Icons.upload_file,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
                label: Text(
                  uploadedFile == null ? 'Upload' : 'Replace',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Icon(
              Icons.picture_as_pdf,
              color: AppColors.strongRed,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: uploadedFile != null
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            baseName,
                            style: Theme.of(context).textTheme.bodySmall,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        Text(
                          extension,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        if (onRemoveFile != null) ...[
                          const SizedBox(width: 20),
                          GestureDetector(
                            onTap: onRemoveFile,
                            child: Icon(
                              Icons.close,
                              size: 16,
                              color: AppColors.strongRed,
                            ),
                          ),
                        ],
                      ],
                    )
                  : Text(
                      'No file selected',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
            ),
          ],
        ),
      ],
    );
  }
}
