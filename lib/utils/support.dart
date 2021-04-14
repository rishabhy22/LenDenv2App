import 'package:flutter/material.dart';

mixin CommonPageDesign {
  BoxDecoration bgDecoration(ThemeData theme) => BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [theme.primaryColor, theme.accentColor]),
      );
  BoxDecoration sheetBGdecoration(ThemeData theme) => BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [theme.primaryColor, theme.accentColor]),
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25), topRight: Radius.circular(25)));
}
