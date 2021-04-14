import 'package:flutter/material.dart';

class AuthFormClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, size.height * 0.218);
    path.lineTo(0, size.height);
    path.lineTo(size.width * 0.78, size.height);
    path.quadraticBezierTo(
        size.width, size.height, size.width, size.height * 0.776);
    path.lineTo(size.width, 0);
    path.lineTo(size.width * 0.225, 0);
    path.quadraticBezierTo(0, 0, 0, size.height * 0.218);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class ClippedContainer extends StatelessWidget {
  ClippedContainer(this.child);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: AuthFormClipper(),
      child: this.child,
    );
  }
}

class ButtonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width * 0.78, size.height);
    path.quadraticBezierTo(size.width, size.height, size.width, 0);
    path.lineTo(size.width * 0.2, 0);
    path.quadraticBezierTo(0, 0, 0, size.height);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class ClippedButton extends StatelessWidget {
  ClippedButton({this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      child: this.child,
      clipper: ButtonClipper(),
    );
  }
}
