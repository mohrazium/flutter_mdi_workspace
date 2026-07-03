import 'package:flutter/foundation.dart';
import '../models/window_instance.dart';
import '../models/window_visual_state.dart';
import '../models/workspace_target.dart';

/// Direction for resize operations.
enum ResizeDirection {
  left,
  right,
  top,
  bottom,
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
}

/// Controller for managing MDI workspace state.
///
/// Handles window operations: opening, closing, moving, resizing, and state changes.
/// All state changes are observable; listeners are notified when windows change.
class MdiWorkspaceController extends ChangeNotifier {
  final Map<String, WindowInstance> _windows = {};
  int _nextZIndex = 1;
  double _workspaceWidth = 800;
  double _workspaceHeight = 600;

  /// Set workspace dimensions (call this when workspace size changes)
  void setWorkspaceDimensions(double width, double height) {
    _workspaceWidth = width;
    _workspaceHeight = height;
  }

  /// Get all open windows.
  List<WindowInstance> get windows => _windows.values.toList();

  /// Get a specific window by ID.
  WindowInstance? getWindow(String windowId) => _windows[windowId];

  /// Get all windows sorted by z-index (lowest to highest).
  List<WindowInstance> getWindowsSortedByZIndex() {
    final sorted = _windows.values.toList();
    sorted.sort((a, b) => a.zIndex.compareTo(b.zIndex));
    return sorted;
  }

  /// Get all minimized windows.
  List<WindowInstance> getMinimizedWindows() {
    return _windows.values
        .where((w) => w.visualState == WindowVisualState.minimized)
        .toList();
  }

  /// Get all non-minimized (visible) windows.
  List<WindowInstance> getVisibleWindows() {
    return _windows.values
        .where((w) => w.visualState != WindowVisualState.minimized)
        .toList();
  }

  /// Get the currently active window.
  WindowInstance? getActiveWindow() {
    try {
      return _windows.values.firstWhere((w) => w.isActive);
    } catch (e) {
      return null;
    }
  }

  /// Open a new window with the given target.
  ///
  /// Returns the created [WindowInstance].
  WindowInstance openWindow({
    required WorkspaceTarget target,
    String? windowId,
    double x = 20,
    double y = 20,
    double width = 400,
    double height = 300,
    double minWidth = 200,
    double minHeight = 150,
    String? customTitle,
  }) {
    final id = windowId ?? _generateWindowId();

    final newWindow = WindowInstance(
      id: id,
      target: target,
      visualState: WindowVisualState.normal,
      x: x,
      y: y,
      width: width,
      height: height,
      zIndex: _nextZIndex,
      isActive: true,
      minWidth: minWidth,
      minHeight: minHeight,
      customTitle: customTitle,
    );

    // Deactivate previously active window
    for (final w in _windows.values) {
      if (w.isActive) {
        _windows[w.id] = w.copyWith(isActive: false);
      }
    }

    _windows[id] = newWindow;
    _nextZIndex++;
    notifyListeners();

    return newWindow;
  }

  /// Close a window by ID.
  void closeWindow(String windowId) {
    if (_windows.remove(windowId) != null) {
      notifyListeners();
    }
  }

  /// Activate (focus) a window and bring it to the front.
  void activateWindow(String windowId) {
    final window = _windows[windowId];
    if (window == null) return;

    // If minimized, restore to normal state
    WindowVisualState newState = window.visualState;
    if (window.visualState == WindowVisualState.minimized) {
      newState = WindowVisualState.normal;
    }

    // Deactivate other windows
    for (final w in _windows.values) {
      if (w.id != windowId && w.isActive) {
        _windows[w.id] = w.copyWith(isActive: false);
      }
    }

    // Activate and bring to front
    _windows[windowId] =
        window.copyWith(isActive: true, zIndex: _nextZIndex, visualState: newState);
    _nextZIndex++;
    notifyListeners();
  }

  /// Minimize a window.
  void minimizeWindow(String windowId) {
    final window = _windows[windowId];
    if (window == null) return;

    _windows[windowId] = window.copyWith(
      visualState: WindowVisualState.minimized,
      isActive: false,
    );
    notifyListeners();
  }

  /// Maximize a window.
  void maximizeWindow(String windowId) {
    final window = _windows[windowId];
    if (window == null) return;

    _windows[windowId] = window.copyWith(
      visualState: WindowVisualState.maximized,
    );
    notifyListeners();
  }

  /// Restore a maximized or minimized window to normal state.
  void restoreWindow(String windowId) {
    final window = _windows[windowId];
    if (window == null) return;

    _windows[windowId] = window.copyWith(
      visualState: WindowVisualState.normal,
    );
    notifyListeners();
  }

  /// Move a window by the given delta.
  void moveWindow(String windowId, Offset delta) {
    final window = _windows[windowId];
    if (window == null || !window.canDrag) return;

    // Calculate new position
    double newX = window.x + delta.dx;
    double newY = window.y + delta.dy;

    // Clamp to workspace boundaries
    // Keep at least 50 pixels of the title bar visible on the left/top
    newX = newX.clamp(-window.width + 50, _workspaceWidth - 50);
    newY = newY.clamp(0, _workspaceHeight - 30); // 30 is approximate title bar height

    _windows[windowId] = window.copyWith(
      x: newX,
      y: newY,
    );
    notifyListeners();
  }

  /// Resize a window from a specific handle.
  void resizeWindowFromHandle(
    String windowId,
    ResizeDirection handle,
    Offset delta,
  ) {
    final window = _windows[windowId];
    if (window == null || !window.canResize) return;

    double newX = window.x;
    double newY = window.y;
    double newWidth = window.width;
    double newHeight = window.height;

    switch (handle) {
      case ResizeDirection.left:
        newX += delta.dx;
        newWidth -= delta.dx;
        break;
      case ResizeDirection.right:
        newWidth += delta.dx;
        break;
      case ResizeDirection.top:
        newY += delta.dy;
        newHeight -= delta.dy;
        break;
      case ResizeDirection.bottom:
        newHeight += delta.dy;
        break;
      case ResizeDirection.topLeft:
        newX += delta.dx;
        newY += delta.dy;
        newWidth -= delta.dx;
        newHeight -= delta.dy;
        break;
      case ResizeDirection.topRight:
        newY += delta.dy;
        newWidth += delta.dx;
        newHeight -= delta.dy;
        break;
      case ResizeDirection.bottomLeft:
        newX += delta.dx;
        newWidth -= delta.dx;
        newHeight += delta.dy;
        break;
      case ResizeDirection.bottomRight:
        newWidth += delta.dx;
        newHeight += delta.dy;
        break;
    }

    // Enforce minimum size constraints
    newWidth = newWidth.clamp(window.minWidth, double.infinity);
    newHeight = newHeight.clamp(window.minHeight, double.infinity);

    // Clamp position to keep window within bounds
    newX = newX.clamp(0, _workspaceWidth - newWidth);
    newY = newY.clamp(0, _workspaceHeight - newHeight);

    _windows[windowId] = window.copyWith(
      x: newX,
      y: newY,
      width: newWidth,
      height: newHeight,
    );
    notifyListeners();
  }

  /// Update window position and size (e.g., from layout persistence).
  void updateWindowGeometry({
    required String windowId,
    required double x,
    required double y,
    required double width,
    required double height,
  }) {
    final window = _windows[windowId];
    if (window == null) return;

    _windows[windowId] = window.copyWith(
      x: x,
      y: y,
      width: width,
      height: height,
    );
    notifyListeners();
  }

  /// Update the visual state of a window.
  void updateWindowVisualState(String windowId, WindowVisualState state) {
    final window = _windows[windowId];
    if (window == null) return;

    _windows[windowId] = window.copyWith(visualState: state);
    notifyListeners();
  }

  /// Close all windows.
  void closeAllWindows() {
    if (_windows.isNotEmpty) {
      _windows.clear();
      notifyListeners();
    }
  }

  /// Generate a unique window ID.
  String _generateWindowId() => 'window_${DateTime.now().millisecondsSinceEpoch}_${_windows.length}';
}
