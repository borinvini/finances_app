import 'package:flutter/material.dart';

class Console {
  final String name;
  final int gameCount;
  final IconData icon;
  final Color iconBackgroundColor;

  Console({
    required this.name,
    required this.gameCount,
    required this.icon,
    required this.iconBackgroundColor,
  });
}

List<Console> demoConsoles = [
  Console(
    name: 'PlayStation 5',
    gameCount: 12,
    icon: Icons.gamepad,
    iconBackgroundColor: Colors.blue.shade900,
  ),
  Console(
    name: 'Nintendo Switch',
    gameCount: 23,
    icon: Icons.videogame_asset,
    iconBackgroundColor: Colors.red.shade800,
  ),
  Console(
    name: 'Xbox Series X',
    gameCount: 8,
    icon: Icons.sports_esports,
    iconBackgroundColor: Colors.green.shade800,
  ),
  Console(
    name: 'PlayStation 4',
    gameCount: 45,
    icon: Icons.gamepad,
    iconBackgroundColor: Colors.blue.shade700,
  ),
];