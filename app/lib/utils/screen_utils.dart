import 'package:flutter/material.dart';

import 'app_utils.dart';

class ScreenUtils {
  factory ScreenUtils.init(MediaQueryData mediaQuery,
      {num width = defaultWidth,
      num height = defaultHeight,
      bool allowFontScaling = false}) {
    _instance = ScreenUtils._internal(
        width,
        height,
        allowFontScaling,
        mediaQuery,
        mediaQuery.accessibleNavigation,
        mediaQuery.devicePixelRatio,
        mediaQuery.size.width,
        mediaQuery.size.height,
        mediaQuery.textScaleFactor);
    return _instance;
  }

  ScreenUtils._internal(
    this.uiWidthPx,
    this.uiHeightPx,
    this.allowFontScaling,
    this._mediaQueryData,
    this._accessibleNavigation,
    this._pixelRatio,
    this._screenWidth,
    this._screenHeight,
    this._textScaleFactor,
  );

  static ScreenUtils _instance;
  static const int defaultWidth = 1080;
  static const int defaultHeight = 1920;
  static const MEDIUM_SCREEN_BREAKPOINT = 800.0;
  static const LARGE_SCREEN_BREAKPOINT = 1200.0;

  /// Size of the phone in UI Design , px
  final num uiWidthPx;
  final num uiHeightPx;

  /// allowFontScaling Specifies whether fonts should scale to respect Text Size accessibility settings. The default is false.
  final bool allowFontScaling;

  final MediaQueryData _mediaQueryData;
  final bool _accessibleNavigation;
  final double _screenWidth;
  final double _screenHeight;
  final double _pixelRatio;
  final double _textScaleFactor;

  static MediaQueryData get mediaQueryData => _instance._mediaQueryData;

  /// The number of font pixels for each logical pixel.
  static bool get accessibleNavigation => _instance._accessibleNavigation;

  /// The number of font pixels for each logical pixel.
  static double get textScaleFactor => _instance._textScaleFactor;

  /// The size of the media in logical pixels (e.g, the size of the screen).
  static double get pixelRatio => _instance._pixelRatio;

  /// The horizontal extent of this size.
  static double get screenWidthDp => _instance._screenWidth;

  ///The vertical extent of this size. dp
  static double get screenHeightDp => _instance._screenHeight;

  /// The vertical extent of this size. px
  static double get screenWidth =>
      _instance._screenWidth * _instance._pixelRatio;

  /// The vertical extent of this size. px
  static double get screenHeight =>
      _instance._screenHeight * _instance._pixelRatio;

  /// The ratio of the actual dp to the design draft px
  static double get scaleWidth => _instance._screenWidth / _instance.uiWidthPx;

  static double get scaleHeight =>
      _instance._screenHeight / _instance.uiHeightPx;

  static double get scaleText => scaleWidth;

  static String getDeviceForm([bool isSmallDevice]) {
    return AppUtils.isWeb
        ? 'Web'
        : (isSmallDevice ?? ScreenUtils.isSmallDevice()) ? 'Phone' : 'Tablet';
  }

  static bool isSmallDevice() =>
      isSmallScreenByWidth(_instance._mediaQueryData.size.shortestSide);
  static bool isSmallScreen() => isSmallScreenByWidth(_instance._screenWidth);
  static bool isSmallScreenByWidth(double width) =>
      width < MEDIUM_SCREEN_BREAKPOINT;
  static bool isLargerThanSmallScreenByWidth(double width) =>
      isMediumScreenByWidth(width) || isLargeScreenByWidth(width);

  static bool isMediumScreen() => isMediumScreenByWidth(_instance._screenWidth);

  static bool isMediumScreenByWidth(double width) =>
      width >= MEDIUM_SCREEN_BREAKPOINT && width < LARGE_SCREEN_BREAKPOINT;

  static bool isLargeScreen() => isLargeScreenByWidth(_instance._screenWidth);
  static bool isLargeScreenByWidth(double width) =>
      width >= LARGE_SCREEN_BREAKPOINT;

  /// Adapted to the device width of the UI Design.
  /// Height can also be adapted according to this to ensure no deformation ,
  /// if you want a square
  static num getWidth(num width) => width * scaleWidth;

  /// Highly adaptable to the device according to UI Design
  /// It is recommended to use this method to achieve a high degree of adaptation
  /// when it is found that one screen in the UI design
  /// does not match the current style effect, or if there is a difference in shape.
  static num getHeight(num height) => height * scaleHeight;

  ///Font size adaptation method
  ///@param [fontSize] The size of the font on the UI design, in px.
  ///@param [allowFontScaling]
  static num getSp(num fontSize, {bool allowFontScalingSelf}) =>
      allowFontScalingSelf == null
          ? (_instance.allowFontScaling
              ? (fontSize * scaleText)
              : ((fontSize * scaleText) / _instance._textScaleFactor))
          : (allowFontScalingSelf
              ? (fontSize * scaleText)
              : ((fontSize * scaleText) / _instance._textScaleFactor));
}
