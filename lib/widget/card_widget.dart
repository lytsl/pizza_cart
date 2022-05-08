import 'package:flutter/material.dart';

import '../constants.dart';

class CardWidget extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;

  const CardWidget({required this.child, Key? key, this.padding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Card(
        color: kCardBgColor,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 2,
        child: Container(
          padding: padding ?? EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: child,
        ),
      ),
    );
  }
}
