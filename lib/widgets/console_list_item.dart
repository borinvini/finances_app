import 'package:flutter/material.dart';
import '../models/console.dart';

class ConsoleListItem extends StatelessWidget {
  final Console console;

  const ConsoleListItem({
    super.key,
    required this.console,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[900],
        ),
        child: ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: console.iconBackgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              console.icon,
              color: Colors.white,
            ),
          ),
          title: Text(
            console.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          subtitle: Text(
            '${console.gameCount} jogos',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 12,
            ),
          ),
          trailing: const Icon(
            Icons.chevron_right,
            color: Colors.grey,
          ),
          onTap: () {
            // Navigate to console detail page
          },
        ),
      ),
    );
  }
}