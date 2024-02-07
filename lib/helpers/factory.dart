import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProjectProperty {
  static ColorFactory colorFactory = _ProjectColors();
  static FontFactory fontFactory = _ProjectFonts();
}

abstract class FontFactory {
  late TextStyle robotoStyle;
  late TextStyle nunitoSansStyle;
}

abstract class ColorFactory {
  late Color primaryColor;
  late Color scaffoldBackgroundColor;
  late Color drawerColor;
}

class _ProjectColors implements ColorFactory {
  @override
  Color primaryColor = const Color(0xff164cff);

  @override
  Color scaffoldBackgroundColor = const Color(0xffF8F6FF);

  @override
  Color drawerColor = const Color(0xff224682);
}

class _ProjectFonts implements FontFactory {
  @override
  TextStyle robotoStyle = GoogleFonts.roboto();

  @override
  TextStyle nunitoSansStyle = GoogleFonts.nunitoSans();
}


