import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:minecraft/layout/game_layout.dart';

void main(s) async {
  WidgetsFlutterBinding.ensureInitialized();

  await Flame.images
      .load('sprite_sheets/blocks/block_breaking_sprite_sheet.png');

  await Flame.images.load('sprite_sheets/player/player_idle_sprite_sheet.png');

  await Flame.images
      .load('sprite_sheets/player/player_walking_sprite_sheet.png');

  await Flame.images.load('sprite_sheets/blocks/block_sprite_sheet.png');

  runApp(const MaterialApp(home: Scaffold(body: GameLayout())));
}
