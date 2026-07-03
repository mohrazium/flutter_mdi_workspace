import 'package:flutter/material.dart';

/// Theming for MDI workspace and windows.
///
/// Allows host apps to customize the appearance of window frames, title bars,
/// resize handles, and taskbar.
class MdiWorkspaceTheme {
  /// Background color of the workspace.
  final Color workspaceBackgroundColor;

  /// Border color for window frames.
  final Color windowBorderColor;

  /// Width of the window border.
  final double windowBorderWidth;

  /// Background color of window title bars.
  final Color titleBarBackgroundColor;

  /// Text color in title bars.
  final Color titleBarTextColor;

  /// Background color of active/focused title bars.
  final Color titleBarActiveBackgroundColor;

  /// Icon color in title bars.
  final Color titleBarIconColor;

  /// Icon color on hover in title bars.
  final Color titleBarIconHoverColor;

  /// Color of resize handles.
  final Color resizeHandleColor;

  /// Width of resize handles.
  final double resizeHandleWidth;

  /// Taskbar background color.
  final Color taskbarBackgroundColor;

  /// Taskbar border color.
  final Color taskbarBorderColor;

  /// Taskbar border width.
  final double taskbarBorderWidth;

  /// Height of taskbar buttons.
  final double taskbarButtonHeight;

  /// Title bar height.
  final double titleBarHeight;

  /// Border radius for window corners.
  final BorderRadius? windowBorderRadius;

  /// Shadow for windows.
  final List<BoxShadow>? windowShadow;

  /// Shadow color for active windows (enhanced shadow when focused).
  final Color? activeWindowShadowColor;

  MdiWorkspaceTheme({
    this.workspaceBackgroundColor = const Color(0xFFEEEEEE),
    this.windowBorderColor = const Color(0xFFBBBBBB),
    this.windowBorderWidth = 1.0,
    this.titleBarBackgroundColor = const Color(0xFF0078D4),
    this.titleBarTextColor = Colors.white,
    this.titleBarActiveBackgroundColor = const Color(0xFF0078D4),
    this.titleBarIconColor = Colors.white,
    this.titleBarIconHoverColor = const Color(0xFFE7F3FF),
    this.resizeHandleColor = const Color(0xFFBBBBBB),
    this.resizeHandleWidth = 5.0,
    this.taskbarBackgroundColor = const Color(0xFFF0F0F0),
    this.taskbarBorderColor = const Color(0xFFCCCCCC),
    this.taskbarBorderWidth = 1.0,
    this.taskbarButtonHeight = 36.0,
    this.titleBarHeight = 30.0,
    this.windowBorderRadius,
    this.windowShadow = const [
      BoxShadow(
        color: Color(0x1A000000),
        blurRadius: 8.0,
        offset: Offset(0, 2),
      ),
    ],
    this.activeWindowShadowColor,
  });

  /// Create a light theme (default Windows-like appearance).
  factory MdiWorkspaceTheme.light() => MdiWorkspaceTheme();

  /// Create a dark theme.
  factory MdiWorkspaceTheme.dark() => MdiWorkspaceTheme(
        workspaceBackgroundColor: const Color(0xFF1E1E1E),
        windowBorderColor : const Color(0xFF3F3F3F),
        titleBarBackgroundColor : const Color(0xFF2D2D30),
        titleBarTextColor : const Color(0xFFCCCCCC),
        titleBarActiveBackgroundColor : const Color(0xFF0078D4),
        titleBarIconColor : const Color(0xFFCCCCCC),
        titleBarIconHoverColor : const Color(0xFFFFFFFF),
        resizeHandleColor : const Color(0xFF3F3F3F),
        taskbarBackgroundColor : const Color(0xFF2D2D30),
        taskbarBorderColor : const Color(0xFF3F3F3F),
      );

  /// Create a copy with optional field overrides.
  MdiWorkspaceTheme copyWith({
    Color? workspaceBackgroundColor,
    Color? windowBorderColor,
    double? windowBorderWidth,
    Color? titleBarBackgroundColor,
    Color? titleBarTextColor,
    Color? titleBarActiveBackgroundColor,
    Color? titleBarIconColor,
    Color? titleBarIconHoverColor,
    Color? resizeHandleColor,
    double? resizeHandleWidth,
    Color? taskbarBackgroundColor,
    Color? taskbarBorderColor,
    double? taskbarBorderWidth,
    double? taskbarButtonHeight,
    double? titleBarHeight,
    BorderRadius? windowBorderRadius,
    List<BoxShadow>? windowShadow,
    Color? activeWindowShadowColor,
  }) {
    return MdiWorkspaceTheme(
      workspaceBackgroundColor:
          workspaceBackgroundColor ?? this.workspaceBackgroundColor,
      windowBorderColor: windowBorderColor ?? this.windowBorderColor,
      windowBorderWidth: windowBorderWidth ?? this.windowBorderWidth,
      titleBarBackgroundColor:
          titleBarBackgroundColor ?? this.titleBarBackgroundColor,
      titleBarTextColor: titleBarTextColor ?? this.titleBarTextColor,
      titleBarActiveBackgroundColor:
          titleBarActiveBackgroundColor ?? this.titleBarActiveBackgroundColor,
      titleBarIconColor: titleBarIconColor ?? this.titleBarIconColor,
      titleBarIconHoverColor:
          titleBarIconHoverColor ?? this.titleBarIconHoverColor,
      resizeHandleColor: resizeHandleColor ?? this.resizeHandleColor,
      resizeHandleWidth: resizeHandleWidth ?? this.resizeHandleWidth,
      taskbarBackgroundColor:
          taskbarBackgroundColor ?? this.taskbarBackgroundColor,
      taskbarBorderColor: taskbarBorderColor ?? this.taskbarBorderColor,
      taskbarBorderWidth: taskbarBorderWidth ?? this.taskbarBorderWidth,
      taskbarButtonHeight: taskbarButtonHeight ?? this.taskbarButtonHeight,
      titleBarHeight: titleBarHeight ?? this.titleBarHeight,
      windowBorderRadius: windowBorderRadius ?? this.windowBorderRadius,
      windowShadow: windowShadow ?? this.windowShadow,
      activeWindowShadowColor:
          activeWindowShadowColor ?? this.activeWindowShadowColor,
    );
  }
}
