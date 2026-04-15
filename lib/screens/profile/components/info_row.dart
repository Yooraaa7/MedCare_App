import 'package:flutter/material.dart';

Widget infoRow(BuildContext context, IconData icon, String title, String value) {
  return ListTile(
    // leading is the icon on the left
    leading: Icon(
      icon, 
      size: 20, 
      color: Theme.of(context).colorScheme.onTertiary
    ),
    // title is the main label
    title: Text(
      title,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: Theme.of(context).colorScheme.onTertiary 
      ),
    ),
    // trailing is the value on the right
    trailing: Text(
      value,
      style: Theme.of(context).textTheme.bodyMedium,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 0,),
    visualDensity: VisualDensity.compact,
  );
}