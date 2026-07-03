import 'package:flutter/foundation.dart';
import 'workspace_target.dart';
import 'window_visual_state.dart';

/// Represents an open window instance in the MDI workspace.
///
/// Each window has a unique ID, a target (what content to display),
/// position/size information, and visual state.
class WindowInstance {
  /// Unique identifier for this window instance.
  final String id;

  /// What content this window displays.
  final WorkspaceTarget target;

  /// Visual state (normal, minimized, maximized).
  final WindowVisualState visualState;

  /// X position in workspace coordinates (when not maximized).
  final double x;

  /// Y position in workspace coordinates (when not maximized).
  final double y;

  /// Width in logical pixels (when not maximized).
  final double width;

  /// Height in logical pixels (when not maximized).
  final double height;

  /// Z-order index. Higher values appear on top.
  final int zIndex;

  /// Whether this window is currently active/focused.
  final bool isActive;

  /// Minimum width constraint for resizing.
  final double minWidth;

  /// Minimum height constraint for resizing.
  final double minHeight;

  /// Custom title for the window (if not using target.type).
  final String? customTitle;

  /// When the window was created.
  final DateTime createdAt;

  /// Previous geometry before maximizing (for restore).
  final _WindowGeometry? _previousGeometry;

  WindowInstance({
    required this.id,
    required this.target,
    this.visualState = WindowVisualState.normal,
    this.x = 0,
    this.y = 0,
    this.width = 400,
    this.height = 300,
    this.zIndex = 0,
    this.isActive = false,
    this.minWidth = 200,
    this.minHeight = 150,
    this.customTitle,
    DateTime? createdAt,
    _WindowGeometry? previousGeometry,
  })
      : _previousGeometry = previousGeometry,
        createdAt = createdAt ?? DateTime.now();

  /// Get the display title for this window.
  String getTitle() => customTitle ?? target.type;

  /// Whether the window is in a state where it can be dragged.
  bool get canDrag =>
      visualState == WindowVisualState.normal;

  /// Whether the window is in a state where it can be resized.
  bool get canResize =>
      visualState == WindowVisualState.normal;

  /// Create a copy with optional field overrides.
  WindowInstance copyWith({
    String? id,
    WorkspaceTarget? target,
    WindowVisualState? visualState,
    double? x,
    double? y,
    double? width,
    double? height,
    int? zIndex,
    bool? isActive,
    double? minWidth,
    double? minHeight,
    String? customTitle,
    DateTime? createdAt,
    _WindowGeometry? previousGeometry,
  }) {
    return WindowInstance(
      id: id ?? this.id,
      target: target ?? this.target,
      visualState: visualState ?? this.visualState,
      x: x ?? this.x,
      y: y ?? this.y,
      width: width ?? this.width,
      height: height ?? this.height,
      zIndex: zIndex ?? this.zIndex,
      isActive: isActive ?? this.isActive,
      minWidth: minWidth ?? this.minWidth,
      minHeight: minHeight ?? this.minHeight,
      customTitle: customTitle ?? this.customTitle,
      createdAt: createdAt ?? this.createdAt,
      previousGeometry: previousGeometry ?? _previousGeometry,
    );
  }

  /// Save current geometry for restoration later.
  WindowInstance withSavedGeometry() {
    return copyWith(
      previousGeometry: _WindowGeometry(x, y, width, height),
    );
  }

  /// Restore to previously saved geometry.
  WindowInstance restorePreviousGeometry() {
    if (_previousGeometry == null) return this;
    return copyWith(
      x: _previousGeometry!.x,
      y: _previousGeometry!.y,
      width: _previousGeometry!.width,
      height: _previousGeometry!.height,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WindowInstance &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          target == other.target &&
          visualState == other.visualState &&
          x == other.x &&
          y == other.y &&
          width == other.width &&
          height == other.height &&
          zIndex == other.zIndex &&
          isActive == other.isActive &&
          minWidth == other.minWidth &&
          minHeight == other.minHeight &&
          customTitle == other.customTitle;

  @override
  int get hashCode => Object.hashAll([
        id,
        target,
        visualState,
        x,
        y,
        width,
        height,
        zIndex,
        isActive,
        minWidth,
        minHeight,
        customTitle,
      ]);

  @override
  String toString() =>
      'WindowInstance(id: $id, target: $target, visualState: $visualState, '
      'pos: ($x, $y), size: ${width}x$height, zIndex: $zIndex, active: $isActive)';
}

/// Internal class to store previous window geometry.
class _WindowGeometry {
  final double x;
  final double y;
  final double width;
  final double height;

  _WindowGeometry(this.x, this.y, this.width, this.height);
}
