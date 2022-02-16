import 'package:flutter/rendering.dart';
import 'package:spine_flutter/spine_flutter.dart' as sf;

import 'spine_render.dart';

/// Render which load animation from local assets.
class AssetSpineRender extends SpineRender {
  AssetSpineRender({
    required String name,
    String? startAnimation,
    bool? loop,
    String? pathPrefix,
    BoxFit? fit,
    sf.PlayState? playState,
  }) : super(
          name: name,
          startAnimation: startAnimation,
          loop: loop,
          pathPrefix: pathPrefix,
          fit: fit,
          playState: playState,
        );

  @override
  Future<sf.SkeletonAnimation?> buildSkeleton() async =>
      sf.SkeletonAnimation.createWithFiles(name, pathBase: pathPrefix);
}
