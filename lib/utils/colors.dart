import 'package:flutter/material.dart';
import 'dart:ui';

const primaryColor = const Color(0xff183E8D);
const primaryLight = const Color(0xff3db1fe);
const primaryDark = const Color(0xff3db1fe);

const secondaryColor = const Color(0xff3db1fe);
const secondaryLight = const Color(0xff3db1fe);
const secondaryDark = const Color(0xff3db1fe);

const Color gradientStart = const Color(0xff855bfe);
const Color gradientEnd = const Color(0xff6187ff);

const primaryGradient = const LinearGradient(
  colors: const [
    Color(0xff3db1fe),
    Color(0xff3db1fe),
    Color(0xff39b7fd),
    Color(0xff6187ff),
    Color(0xff855bfe)
  ],
  stops: [0.0, 0.35, 0.55, 0.75, 1.0],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

const chatBubbleGradient = const LinearGradient(
  colors: const [Color(0xff3db1fe), Color(0xff855bfe)],
  begin: Alignment.topRight,
  end: Alignment.bottomLeft,
);

const chatBubbleGradient2 = const LinearGradient(
  colors: const [Color(0xFFf4e3e3), Color(0xFFf4e3e3)],
  begin: Alignment.topRight,
  end: Alignment.bottomLeft,
);
