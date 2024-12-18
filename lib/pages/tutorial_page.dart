import 'package:flutter/material.dart';

class TutorialOverlay extends ModalRoute<void> {
  Widget? child;

  TutorialOverlay({this.child});

  @override
  Duration get transitionDuration => Duration(microseconds: 500);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.5);

  @override
  String get barrierLabel => "";

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      ) {
    // This makes sure that text and other content follows the material style
    return Material(
      type: MaterialType.transparency,
      // make sure that the overlay content is not cut off
      child: SafeArea(
        child: _buildOverlayContent(context),
      ),
    );
  }

  Widget _buildOverlayContent(BuildContext context) {
    return child ??
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'This is a nice overlay',
                style: TextStyle(color: Colors.white, fontSize: 30.0),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Dismiss'),
              )
            ],
          ),
        );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // You can add your own animations for the overlay content
    return FadeTransition(
      opacity: animation,
      child: child,
      // ScaleTransition(
      //   scale: animation,
      //   child: child,
      // ),
    );
  }
}
