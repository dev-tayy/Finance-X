import 'package:flutter/material.dart';

//Custom PageRoute for the App
//EgoWavePageRoute is a custom PageRoute that has a custom transition animation

class RMPageRoute<T> extends PageRoute<T> {
  RMPageRoute({
    required this.builder,
    RouteSettings? settings,
    this.maintainState = true,
    bool fullscreenDialog = false,
  })  : assert(builder != null),
        // ignore: unnecessary_null_comparison
        assert(maintainState != null),
        // ignore: unnecessary_null_comparison
        assert(fullscreenDialog != null),
        super(settings: settings, fullscreenDialog: fullscreenDialog);

  /// Builds the primary contents of the route.
  final WidgetBuilder? builder;

  @override
  final bool maintainState;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);

  @override
  bool get opaque => false;

  @override
  Color get barrierColor => Colors.transparent;

  @override
  String get barrierLabel => '';

  @override
  bool canTransitionFrom(TransitionRoute<dynamic> previousRoute) {
    return previousRoute is RMPageRoute;
  }

  @override
  bool canTransitionTo(TransitionRoute<dynamic> nextRoute) {
    return (nextRoute is RMPageRoute && !nextRoute.fullscreenDialog);
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    final Widget? result = builder!(context);
    assert(() {
      if (result == null) {
        throw FlutterError(
            'The builder for route "${settings.name}" returned null.\n'
            'Route builders must never return null.');
      }
      return true;
    }());
    return Semantics(
      scopesRoute: true,
      explicitChildNodes: true,
      child: result,
    );
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return _FadeInPageTransition(routeAnimation: animation, child: child);
  }

  @override
  String get debugLabel => '${super.debugLabel}(${settings.name})';
}

class _FadeInPageTransition extends StatelessWidget {
  _FadeInPageTransition({
    Key? key,
    required Animation<double>?
        routeAnimation, // The route's linear 0.0 - 1.0 animation.
    required this.child,
  })  : _opacityAnimation = routeAnimation!.drive(_easeInTween),
        super(key: key);

  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);

  final Animation<double> _opacityAnimation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: child,
    );
  }
}

class TransparentRoute extends PageRoute<void> {
  TransparentRoute({
    required this.builder,
    required this.dx,
    required this.dy,
    RouteSettings? settings,
  }) : super(settings: settings, fullscreenDialog: false);

  final WidgetBuilder builder;

  final double dx, dy;

  @override
  bool get opaque => false;

  @override
  Color get barrierColor => Colors.transparent;

  @override
  String get barrierLabel => '';

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    final result = builder(context);
    return Semantics(
      scopesRoute: true,
      explicitChildNodes: true,
      child: SlideTransition(
        transformHitTests: false,
        position: Tween<Offset>(
          begin: Offset(dx, dy),
          end: Offset.zero,
        ).animate(animation),
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 0.0),
            end: const Offset(0.0, -1.0),
          ).animate(secondaryAnimation),
          child: result,
        ),
      ),
    );
  }
}
