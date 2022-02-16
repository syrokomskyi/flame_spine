import 'package:flame/components.dart';
import 'package:flutter/widgets.dart';
import 'package:spine_core/spine_core.dart' as sc;

import '../flame_spine.dart';

/// A [PositionComponent] that renders a [SpineRender].
class SpineComponent extends PositionComponent {
  final SpineRender _render;

  SpineComponent({
    required SpineRender render,
    Vector2? size,
    Vector2? position,
    Vector2? scale,
    double? angle,
    Anchor? anchor,
    int? priority,
  })  : _render = render,
        super(
          position: position,
          size: size,
          scale: scale,
          angle: angle,
          anchor: anchor,
          priority: priority,
        );

  @override
  Future<void>? onLoad() async {
    await _render.init();

    if (size.isZero()) {
      final boundsOffset = sc.Vector2();
      final boundsSize = sc.Vector2();
      final temp = <double>[];
      _render.skeleton!.getBounds(boundsOffset, boundsSize, temp);
      print('boundsSize ${boundsSize.x} ${boundsSize.y}');
      size.setFrom(Vector2(boundsSize.x, boundsSize.y));
    }
  }

  @override
  @mustCallSuper
  void render(Canvas canvas) => _render.render(canvas, size.toSize());

  @override
  void onRemove() {
    _render.destroy();

    super.onRemove();
  }
}
