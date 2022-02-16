import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';
import 'package:spine_core/spine_core.dart' as sc;

import 'spine_render.dart';

/// A [PositionComponent] that renders a [SpineRender].
class SpineComponent extends PositionComponent {
  final SpineRender spineRender;

  SpineComponent({
    required this.spineRender,
    Vector2? size,
    Vector2? position,
    Vector2? scale,
    double? angle,
    Anchor? anchor,
    int? priority,
  })  : super(
          position: position,
          size: size,
          scale: scale,
          angle: angle,
          anchor: anchor,
          priority: priority,
        );

  @override
  Future<void>? onLoad() async {
    await spineRender.init();

    if (size.isZero()) {
      final boundsOffset = sc.Vector2();
      final boundsSize = sc.Vector2();
      final temp = <double>[];
      spineRender.skeleton!.getBounds(boundsOffset, boundsSize, temp);
      print('boundsSize ${boundsSize.x} ${boundsSize.y}');
      size.setFrom(Vector2(boundsSize.x, boundsSize.y));
    }

    return super.onLoad();
  }

  @override
  @mustCallSuper
  void render(Canvas canvas) => spineRender.render(canvas, size.toSize());

  @override
  void onRemove() {
    spineRender.destroy();

    super.onRemove();
  }
}
