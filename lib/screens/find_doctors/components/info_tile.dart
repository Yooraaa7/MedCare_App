import 'package:flutter/material.dart';

class InfoTile extends StatelessWidget {
  final IconData icon;   
  final String label;  
  final Widget value;  

  const InfoTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: (){},
      contentPadding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
      leading: Container(
        width: 44,
        height: 44,
        alignment: Alignment.center,
        child: Icon(icon, size: 24,),
      ),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: Theme.of(context).colorScheme.onTertiary
        ),
      ),
      subtitle: value,
    );
  }
}