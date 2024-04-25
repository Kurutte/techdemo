import 'dart:ui';
import 'package:dino_run/widgets/customize_menu_hud.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/widgets/hud.dart';
import '/game/gamerunner.dart';
import '/widgets/main_menu.dart';
import '/models/player_data.dart';

class CustomizePauseMenu extends StatelessWidget {
  static const id = 'CustomizePauseMenu';

  final GameRunner game;

  const CustomizePauseMenu(this.game, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: game.playerData,
      child: Center(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: Colors.black.withAlpha(100),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 100),
                child: Wrap(
                  direction: Axis.vertical,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Selector<PlayerData, int>(
                        selector: (_, playerData) => playerData.currentScore,
                        builder: (_, score, __) {
                          return const Text(
                            'Would You Like To Save?',
                            style: TextStyle(fontSize: 40, color: Colors.white),
                          );
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        game.overlays.remove(CustomizePauseMenu.id);
                        game.overlays.add(CustomizeHud.id);
                        game.resumeEngine();
                      },
                      child: const Text(
                        'Go Back',
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        game.overlays.remove(CustomizePauseMenu.id);
                        game.overlays.add(MainMenu.id);
                        game.resumeEngine();
                        game.closeMenu();
                      },
                      child: const Text(
                        'Save & Exit',
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
