import 'package:flutter/material.dart';
import '../controller/mdi_workspace_controller.dart';
import '../models/window_instance.dart';
import '../models/window_visual_state.dart';
import '../registry/workspace_registry.dart';
import '../theme/mdi_workspace_theme.dart';
import 'mdi_window_title_bar.dart';
import 'resize_handle.dart';

/// Individual window widget.
///
/// Renders a single MDI window with title bar, content, and resize handles.
/// Handles dragging (title bar), resizing (handles), and state changes.
class MdiWindow extends StatefulWidget {
  /// The window instance data.
  final WindowInstance window;

  /// Workspace controller.
  final MdiWorkspaceController controller;

  /// Theme.
  final MdiWorkspaceTheme theme;

  /// Registry for building content.
  final WorkspaceRegistry registry;

  /// Callback when window is closed.
  final void Function(String windowId)? onClosed;

  /// Callback when window is activated.
  final void Function(String windowId)? onActivated;

  const MdiWindow({
    Key? key,
    required this.window,
    required this.controller,
    required this.theme,
    required this.registry,
    this.onClosed,
    this.onActivated,
  }) : super(key: key);

  @override
  State<MdiWindow> createState() => _MdiWindowState();
}

class _MdiWindowState extends State<MdiWindow> {
  @override
  Widget build(BuildContext context) {
    final window = widget.window;
    final resizeHandleWidth = widget.theme.resizeHandleWidth;

    return GestureDetector(
      onTap: () {
        widget.controller.activateWindow(window.id);
        widget.onActivated?.call(window.id);
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: widget.theme.windowBorderColor,
            width: widget.theme.windowBorderWidth,
          ),
          borderRadius: widget.theme.windowBorderRadius,
          boxShadow: window.isActive
              ? (widget.theme.windowShadow != null
                  ? [
                      ...widget.theme.windowShadow!,
                      if (widget.theme.activeWindowShadowColor != null)
                        BoxShadow(
                          color: widget.theme.activeWindowShadowColor!,
                          blurRadius: 12.0,
                          offset: const Offset(0, 4),
                        ),
                    ]
                  : null)
              : widget.theme.windowShadow,
        ),
        child: Stack(
          children: [
            // Main window content
            Column(
              children: [
                // Title bar
                MdiWindowTitleBar(
                  window: window,
                  controller: widget.controller,
                  theme: widget.theme,
                  onClosed: () {
                    widget.controller.closeWindow(window.id);
                    widget.onClosed?.call(window.id);
                  },
                ),
                // Content
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: widget.registry.build(context, window.target),
                  ),
                ),
              ],
            ),
            // Resize handles
            if (window.canResize) ...[
              // Top-left corner
              Positioned(
                left: 0,
                top: 0,
                child: MouseRegion(
                  cursor: SystemMouseCursors.resizeUpLeftDownRight,
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      widget.controller.resizeWindowFromHandle(
                        window.id,
                        ResizeDirection.topLeft,
                        details.delta,
                      );
                    },
                    child: Container(
                      width: resizeHandleWidth * 2,
                      height: resizeHandleWidth * 2,
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ),
              // Top-right corner
              Positioned(
                right: 0,
                top: 0,
                child: MouseRegion(
                  cursor: SystemMouseCursors.resizeUpRightDownLeft,
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      widget.controller.resizeWindowFromHandle(
                        window.id,
                        ResizeDirection.topRight,
                        details.delta,
                      );
                    },
                    child: Container(
                      width: resizeHandleWidth * 2,
                      height: resizeHandleWidth * 2,
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ),
              // Bottom-left corner
              Positioned(
                left: 0,
                bottom: 0,
                child: MouseRegion(
                  cursor: SystemMouseCursors.resizeUpRightDownLeft,
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      widget.controller.resizeWindowFromHandle(
                        window.id,
                        ResizeDirection.bottomLeft,
                        details.delta,
                      );
                    },
                    child: Container(
                      width: resizeHandleWidth * 2,
                      height: resizeHandleWidth * 2,
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ),
              // Bottom-right corner
              Positioned(
                right: 0,
                bottom: 0,
                child: MouseRegion(
                  cursor: SystemMouseCursors.resizeUpLeftDownRight,
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      widget.controller.resizeWindowFromHandle(
                        window.id,
                        ResizeDirection.bottomRight,
                        details.delta,
                      );
                    },
                    child: Container(
                      width: resizeHandleWidth * 2,
                      height: resizeHandleWidth * 2,
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ),
              // Top edge
              Positioned(
                left: resizeHandleWidth * 2,
                right: resizeHandleWidth * 2,
                top: 0,
                child: MouseRegion(
                  cursor: SystemMouseCursors.resizeRow,
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      widget.controller.resizeWindowFromHandle(
                        window.id,
                        ResizeDirection.top,
                        details.delta,
                      );
                    },
                    child: Container(
                      height: resizeHandleWidth,
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ),
              // Bottom edge
              Positioned(
                left: resizeHandleWidth * 2,
                right: resizeHandleWidth * 2,
                bottom: 0,
                child: MouseRegion(
                  cursor: SystemMouseCursors.resizeRow,
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      widget.controller.resizeWindowFromHandle(
                        window.id,
                        ResizeDirection.bottom,
                        details.delta,
                      );
                    },
                    child: Container(
                      height: resizeHandleWidth,
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ),
              // Left edge
              Positioned(
                left: 0,
                top: resizeHandleWidth * 2,
                bottom: resizeHandleWidth * 2,
                child: MouseRegion(
                  cursor: SystemMouseCursors.resizeColumn,
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      widget.controller.resizeWindowFromHandle(
                        window.id,
                        ResizeDirection.left,
                        details.delta,
                      );
                    },
                    child: Container(
                      width: resizeHandleWidth,
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ),
              // Right edge
              Positioned(
                right: 0,
                top: resizeHandleWidth * 2,
                bottom: resizeHandleWidth * 2,
                child: MouseRegion(
                  cursor: SystemMouseCursors.resizeColumn,
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      widget.controller.resizeWindowFromHandle(
                        window.id,
                        ResizeDirection.right,
                        details.delta,
                      );
                    },
                    child: Container(
                      width: resizeHandleWidth,
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
