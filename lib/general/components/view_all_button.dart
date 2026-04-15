import 'package:flutter/material.dart';

class ViewAllButton extends StatelessWidget {
  final String? text;
  final VoidCallback? onPressed;
  final Alignment alignment;

  const ViewAllButton({
    super.key,
    this.onPressed,
    this.text = 'View All',
    this.alignment = Alignment.centerRight
  });

  @override
  Widget build(BuildContext context){
    return SizedBox(
      width: 100,
      child: TextButton(
        // TODO: Navigate to appointments screen
        onPressed: onPressed,
        style: TextButton.styleFrom(
          alignment: alignment,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            side: BorderSide.none
          )
        ),
        child: Text(text ?? 'View All',
          style: TextStyle(
            decoration: TextDecoration.underline,
            fontSize: 12
          ),  
        ),
      ),
    );
    }
}