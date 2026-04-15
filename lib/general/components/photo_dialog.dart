import 'package:flutter/material.dart';

class PhotoDialog extends StatelessWidget {
  final String imagePath;
  final Widget imageWidget;
  const PhotoDialog({super.key, required this.imagePath, required this.imageWidget});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => Dialog(
            child: InteractiveViewer(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        );
      },
      child: imageWidget,
    );
  }
}