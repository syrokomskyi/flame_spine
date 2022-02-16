import 'package:flutter/rendering.dart';
import 'package:spine_flutter/spine_flutter.dart';

import '../flame_spine.dart';

/// Render which load animation from local assets.
class AssetSpineRender extends SpineRender {
  AssetSpineRender({
    required String name,
    String? startAnimation,
    bool? loop,
    String? pathPrefix,
    BoxFit? fit,
    PlayState? playState,
  }) : super(
          name: name,
          startAnimation: startAnimation,
          loop: loop,
          pathPrefix: pathPrefix,
          fit: fit,
          playState: playState,
        );

  @override
  Future<SkeletonAnimation?> buildSkeleton() async =>
      SkeletonAnimation.createWithFiles(name, pathBase: pathPrefix);
}
