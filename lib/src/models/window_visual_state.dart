/// Visual state of an MDI window.
///
/// Represents the current visual condition of a window:
/// - normal: Regular window state
/// - minimized: Window is minimized (hidden from view, shown in taskbar)
/// - maximized: Window fills the workspace
enum WindowVisualState {
  /// Regular window state. Window can be dragged and resized.
  normal,

  /// Window is minimized. Hidden from workspace, appears in taskbar.
  /// Dragging and resizing are disabled.
  minimized,

  /// Window fills the entire workspace.
  /// Dragging and resizing are disabled.
  maximized,
}
