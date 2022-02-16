import 'dart:math';

import 'package:flutter/rendering.dart';
import 'package:spine_flutter/spine_flutter.dart';

/// A class that wraps all the settings of a Spine animation from [name].
/// It has a API to the [SkeletonRenderObjectWidget] widget.
abstract class SpineRender {
  String get defaultAnimation => 'idle';

  /// Model name.
  final String name;

  /// Start animation.
  late final String animation;

  /// Infinity animation loop.
  final bool loop;

  /// Prefix for find model by name.
  final String pathPrefix;

  final BoxFit fit;
  final PlayState playState;

  /// \todo Add [alignment] into the constructor.
  final Alignment alignment = Alignment.topLeft;

  SkeletonAnimation? skeleton;

  SkeletonRenderObject? _skeletonRender;

  bool get isPrepared => skeleton != null;

  SpineRender({
    required this.name,
    String? startAnimation,
    bool? loop,
    String? pathPrefix,
    BoxFit? fit,
    PlayState? playState,
  })  : assert(name.isNotEmpty),
        loop = loop ?? false,
        pathPrefix = pathPrefix ?? '',
        fit = fit ?? BoxFit.contain,
        playState = playState ?? PlayState.playing {
    animation = startAnimation ?? defaultAnimation;
    assert(animation.isNotEmpty);
  }

  Future<void> init() async {
    skeleton = await buildSkeleton();
    _skeletonRender = SkeletonRenderObject()
      ..skeleton = skeleton!
      ..fit = fit
      ..alignment = alignment
      ..playState = playState
      ..debugRendering = false
      ..triangleRendering = true;

    skeleton!.state.setAnimation(0, animation, loop);
  }

  Future<SkeletonAnimation?> buildSkeleton();

  void render(Canvas canvas, Size preferredSize) {
    if (skeleton == null) {
      return;
    }

    if (_skeletonRender == null) {
      return;
    }

    _paint(canvas, preferredSize);
  }

  /// Paint procedures ported from [SkeletonRenderObject.paint]
  /// with some changes that makes sense on a Flame context.
  void _paint(Canvas canvas, Size size) {
    if (_skeletonRender == null) {
      return;
    }

    if (skeleton == null) {
      return;
    }

    final ro = _skeletonRender!;
    final bounds = ro.bounds;
    if (bounds == null) {
      return;
    }

    final boundsSize = Size(bounds.size.x, bounds.size.y);
    if (boundsSize.isEmpty) {
      return;
    }

    final contentWidth = boundsSize.width;
    final x = -1 * bounds.offset.x -
        contentWidth / 2 -
        (alignment.x * contentWidth / 2);

    final contentHeight = boundsSize.height;
    final y = -1 * bounds.offset.y -
        contentHeight / 2 -
        (alignment.y * contentHeight / 2);

    var scaleX = 1.0;
    var scaleY = 1.0;

    canvas
      ..save()
      ..clipRect(Offset.zero & size);

    switch (fit) {
      case BoxFit.fill:
        scaleX = size.width / contentWidth;
        scaleY = size.height / contentHeight;
        break;
      case BoxFit.contain:
        scaleX = scaleY =
            min(size.width / contentWidth, size.height / contentHeight);
        break;
      case BoxFit.cover:
        scaleX = scaleY =
            max(size.width / contentWidth, size.height / contentHeight);
        break;
      case BoxFit.fitHeight:
        scaleX = scaleY = size.height / contentHeight;
        break;
      case BoxFit.fitWidth:
        scaleX = scaleY = size.width / contentWidth;
        break;
      case BoxFit.none:
        break;
      case BoxFit.scaleDown:
        final minScale =
            min(size.width / contentWidth, size.height / contentHeight);
        scaleX = scaleY = minScale < 1.0 ? minScale : 1.0;
        break;
    }

    final tx = size.width / 2 + (alignment.x * size.width / 2);
    final ty = size.height / 2 + (alignment.y * size.height / 2);
    canvas
      ..translate(tx, -ty)
      ..scale(scaleX, -scaleY)
      ..translate(x, y)
      ..translate(0, -bounds.size.y);

    ro.draw(canvas);

    canvas.restore();
  }

  void destroy() {
    if (_skeletonRender == null) {
      return;
    }

    _skeletonRender?.dispose();
  }
}
