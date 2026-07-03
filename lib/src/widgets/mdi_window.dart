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
        child: Column(
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
      ),
    );
  }
}
