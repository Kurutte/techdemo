import 'dart:async';
import 'dart:developer';

import 'package:dino_run/game/gamerunner.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';

import '../models/player_data.dart';

class NavigationArrow extends SpriteComponent
    with TapCallbacks, HasGameRef<GameRunner> {
  final String direction;
  PlayerData playerData;
  String id;
  NavigationArrow(this.playerData, this.direction, this.id);

  final buttonSize = 16;

  @override
  FutureOr<void> onLoad() {
    _loadSprite();

    return super.onLoad();
  }

  _loadSprite() {
    int yOffset = 0;
    int xOffset = 0;
    if (id == 'Body' && direction == 'Left') {
      sprite = Sprite(game.images.fromCache('LeftArrow.png'));
      xOffset = 200;
      yOffset = 108;
    } else if (id == 'Body' && direction == 'Right') {
      sprite = Sprite(game.images.fromCache('RightArrow.png'));
      xOffset = 86;
      yOffset = 108;
    } else if (id == 'Color' && direction == 'Left') {
      sprite = Sprite(game.images.fromCache('LeftArrow.png'));
      xOffset = 200;
      yOffset = 88;
    } else if (id == 'Color' && direction == 'Right') {
      sprite = Sprite(game.images.fromCache('RightArrow.png'));
      xOffset = 86;
      yOffset = 88;
    } else if (id == 'Hat' && direction == 'Left') {
      sprite = Sprite(game.images.fromCache('LeftArrow.png'));
      xOffset = 200;
      yOffset = 68;
    } else if (id == 'Hat' && direction == 'Right') {
      sprite = Sprite(game.images.fromCache('RightArrow.png'));
      xOffset = 86;
      yOffset = 68;
    }

    position = Vector2(
        game.size.x - xOffset - buttonSize, game.size.y - yOffset - buttonSize);

    priority = 10;
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    game.fingerOnScreen = false;

    super.onTapCancel(event);
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (!game.fingerOnScreen) {
      game.fingerOnScreen = true;

      if (direction == 'Right') {
        if (id == 'Body' && game.bodyIndex < game.bodyArray.length - 1) {
          game.bodyIndex += 1;
          playerData.body = game.bodyArray[game.bodyIndex];
        } else if (id == 'Color' &&
            game.colorIndex < game.colorArray.length - 1) {
          game.colorIndex += 1;
          playerData.color = game.colorArray[game.colorIndex];
        } else if (id == 'Hat' && game.hatIndex < game.hatArray.length - 1) {
          game.hatIndex += 1;
          playerData.hat = game.hatArray[game.hatIndex];
        }
      } else if (direction == 'Left') {
        if (id == 'Body' && game.bodyIndex > 0) {
          game.bodyIndex -= 1;
          playerData.body = game.bodyArray[game.bodyIndex];
        } else if (id == 'Color' && game.colorIndex > 0) {
          game.colorIndex -= 1;
          playerData.color = game.colorArray[game.colorIndex];
        } else if (id == 'Hat' && game.hatIndex > 0) {
          game.hatIndex -= 1;
          playerData.hat = game.hatArray[game.hatIndex];
        }
      }

      game.hero.loadAllAnimations();
    }

    super.onTapDown(event);
  }
}
