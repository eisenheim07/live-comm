import 'package:flutter/material.dart';
import 'dart:math' as math;

class SizeUtils {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;
  static late double safeAreaHorizontal;
  static late double safeAreaVertical;
  static late double safeBlockHorizontal;
  static late double safeBlockVertical;
  static late double devicePixelRatio;
  static late bool isTablet;
  static late bool isLandscape;

  // Design dimensions (based on your Figma design)
  static const double designWidth = 375.0; // iPhone design width
  static const double designHeight = 812.0; // iPhone design height

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
    devicePixelRatio = _mediaQueryData.devicePixelRatio;
    isLandscape = _mediaQueryData.orientation == Orientation.landscape;

    safeAreaHorizontal = _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    safeAreaVertical = _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (screenWidth - safeAreaHorizontal) / 100;
    safeBlockVertical = (screenHeight - safeAreaVertical) / 100;

    // Determine if device is tablet (width > 600dp)
    isTablet = screenWidth > 600;
  }

  // Responsive width based on design
  static double getWidth(double width) {
    return (width / designWidth) * screenWidth;
  }

  // Responsive height based on design
  static double getHeight(double height) {
    return (height / designHeight) * screenHeight;
  }

  // Responsive font size
  static double getFontSize(double fontSize) {
    double scaleFactor = math.min(screenWidth / designWidth, screenHeight / designHeight);
    return fontSize * scaleFactor;
  }

  // Responsive radius
  static double getRadius(double radius) {
    return getWidth(radius);
  }

  // Responsive padding/margin
  static EdgeInsets getPadding({double? all, double? horizontal, double? vertical, double? top, double? bottom, double? left, double? right}) {
    return EdgeInsets.only(
      top: getHeight(top ?? vertical ?? all ?? 0),
      bottom: getHeight(bottom ?? vertical ?? all ?? 0),
      left: getWidth(left ?? horizontal ?? all ?? 0),
      right: getWidth(right ?? horizontal ?? all ?? 0),
    );
  }

  // Common spacing values
  static double get spacing2 => getWidth(2);

  static double get spacing4 => getWidth(4);

  static double get spacing6 => getWidth(6);

  static double get spacing8 => getWidth(8);

  static double get spacing12 => getWidth(12);

  static double get spacing16 => getWidth(16);

  static double get spacing20 => getWidth(20);

  static double get spacing24 => getWidth(24);

  static double get spacing32 => getWidth(32);

  static double get spacing40 => getWidth(40);

  static double get spacing48 => getWidth(48);

  static double get spacing56 => getWidth(56);

  static double get spacing64 => getWidth(64);

  // Common font sizes
  static double get font10 => getFontSize(10);

  static double get font12 => getFontSize(12);

  static double get font14 => getFontSize(14);

  static double get font16 => getFontSize(16);

  static double get font18 => getFontSize(18);

  static double get font20 => getFontSize(20);

  static double get font22 => getFontSize(22);

  static double get font24 => getFontSize(24);

  static double get font28 => getFontSize(28);

  static double get font32 => getFontSize(32);

  static double get font36 => getFontSize(36);

  static double get font40 => getFontSize(40);

  // Common radius values
  static double get radius4 => getRadius(4);

  static double get radius6 => getRadius(6);

  static double get radius8 => getRadius(8);

  static double get radius12 => getRadius(12);

  static double get radius16 => getRadius(16);

  static double get radius20 => getRadius(20);

  static double get radius24 => getRadius(24);

  static double get radius32 => getRadius(32);

  // Icon sizes
  static double get iconSmall => getWidth(16);

  static double get iconMedium => getWidth(24);

  static double get iconLarge => getWidth(32);

  static double get iconXLarge => getWidth(40);

  // Button heights
  static double get buttonHeightSmall => getHeight(32);

  static double get buttonHeightMedium => getHeight(44);

  static double get buttonHeightLarge => getHeight(56);

  // App bar height
  static double get appBarHeight => getHeight(56);

  // Bottom navigation height
  static double get bottomNavHeight => getHeight(80);

  // Card heights
  static double get cardHeightSmall => getHeight(80);

  static double get cardHeightMedium => getHeight(120);

  static double get cardHeightLarge => getHeight(200);

  // Screen padding
  static EdgeInsets get screenPadding => getPadding(horizontal: 16, vertical: 20);

  static EdgeInsets get screenPaddingHorizontal => getPadding(horizontal: 16);

  static EdgeInsets get screenPaddingVertical => getPadding(vertical: 20);

  // Card padding
  static EdgeInsets get cardPadding => getPadding(all: 16);

  static EdgeInsets get cardPaddingSmall => getPadding(all: 8);

  static EdgeInsets get cardPaddingLarge => getPadding(all: 20);

  // Scaffold Padding
  static EdgeInsets get scaffoldPaddingSmall => getPadding(all: 8);

  static EdgeInsets get scaffoldPadding => getPadding(all: 16);

  static EdgeInsets get scaffoldPaddingLarge => getPadding(all: 20);

  // List item padding
  static EdgeInsets get listItemPadding => getPadding(horizontal: 16, vertical: 12);

  // Button padding
  static EdgeInsets get buttonPadding => getPadding(horizontal: 24, vertical: 12);

  static EdgeInsets get buttonPaddingSmall => getPadding(horizontal: 16, vertical: 8);

  static EdgeInsets get buttonPaddingLarge => getPadding(horizontal: 32, vertical: 16);

  // Responsive breakpoints
  static bool get isMobile => screenWidth < 600;

  static bool get isTabletPortrait => screenWidth >= 600 && screenWidth < 900;

  static bool get isTabletLandscape => screenWidth >= 900 && screenWidth < 1200;

  static bool get isDesktop => screenWidth >= 1200;

  // Safe area getters
  static double get safeAreaTop => _mediaQueryData.padding.top;

  static double get safeAreaBottom => _mediaQueryData.padding.bottom;

  static double get safeAreaLeft => _mediaQueryData.padding.left;

  static double get safeAreaRight => _mediaQueryData.padding.right;

  // Keyboard height
  static double get keyboardHeight => _mediaQueryData.viewInsets.bottom;

  static bool get isKeyboardOpen => keyboardHeight > 0;

  // Device orientation helpers
  static bool get isPortrait => !isLandscape;

  // Aspect ratio helpers
  static double get aspectRatio => screenWidth / screenHeight;

  static bool get isWideScreen => aspectRatio > 1.5;

  // Text scale factor
  static double get textScaleFactor => _mediaQueryData.textScaler.scale(1.0);

  // Platform density
  static double get density => devicePixelRatio;

  // Utility method to get responsive size based on screen size
  static double getResponsiveSize({required double mobile, double? tablet, double? desktop}) {
    if (isDesktop && desktop != null) return desktop;
    if (isTablet && tablet != null) return tablet;
    return mobile;
  }

  // Method to get adaptive padding based on screen size
  static EdgeInsets getAdaptivePadding() {
    if (isDesktop) return getPadding(horizontal: 32, vertical: 24);
    if (isTablet) return getPadding(horizontal: 24, vertical: 20);
    return getPadding(horizontal: 16, vertical: 16);
  }
}
