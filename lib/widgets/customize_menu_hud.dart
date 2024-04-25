import 'package:dino_run/widgets/customize_menu_pause.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/game/gamerunner.dart';
import '/models/player_data.dart';
import '/widgets/pause_menu.dart';

class CustomizeHud extends StatelessWidget {
  static const id = 'CustomizeHud';

  final GameRunner game;

  const CustomizeHud(this.game, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: game.playerData,
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(
              onPressed: () {
                game.overlays.remove(CustomizeHud.id);
                game.overlays.add(CustomizePauseMenu.id);
                game.pauseEngine();
              },
              child: const Icon(Icons.pause, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
