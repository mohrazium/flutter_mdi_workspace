import 'package:flutter/material.dart';
import '../controller/mdi_workspace_controller.dart';
import '../models/window_instance.dart';
import '../models/window_visual_state.dart';
import '../theme/mdi_workspace_theme.dart';

/// Title bar for an MDI window.
///
/// Displays the window title and control buttons (minimize, maximize, close).
/// The title bar is draggable to move the window.
class MdiWindowTitleBar extends StatefulWidget {
  /// The window instance.
  final WindowInstance window;

  /// Workspace controller.
  final MdiWorkspaceController controller;

  /// Theme.
  final MdiWorkspaceTheme theme;

  /// Callback when close button is pressed.
  final VoidCallback onClosed;

  const MdiWindowTitleBar({
    Key? key,
    required this.window,
    required this.controller,
    required this.theme,
    required this.onClosed,
  }) : super(key: key);

  @override
  State<MdiWindowTitleBar> createState() => _MdiWindowTitleBarState();
}

class _MdiWindowTitleBarState extends State<MdiWindowTitleBar> {
  @override
  Widget build(BuildContext context) {
    final window = widget.window;
    final isDraggable = window.canDrag;

    return GestureDetector(
      onPanUpdate: isDraggable
          ? (details) {
              widget.controller.moveWindow(window.id, details.delta);
            }
          : null,
      onPanDown: (_) {
        // Activate window on drag start
        widget.controller.activateWindow(window.id);
      },
      child: Container(
        height: widget.theme.titleBarHeight,
        color: window.isActive
            ? widget.theme.titleBarActiveBackgroundColor
            : widget.theme.titleBarBackgroundColor,
        child: Row(
          children: [
            // Title (draggable area)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    window.getTitle(),
                    style: TextStyle(
                      color: widget.theme.titleBarTextColor,
                      fontWeight:
                          window.isActive ? FontWeight.bold : FontWeight.normal,
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
            // Control buttons
            _buildButton(
              icon: Icons.minimize,
              onPressed: () {
                widget.controller.minimizeWindow(window.id);
              },
            ),
            _buildButton(
              icon: window.visualState == WindowVisualState.maximized
                  ? Icons.unfold_less
                  : Icons.unfold_more,
              onPressed: () {
                if (window.visualState == WindowVisualState.maximized) {
                  widget.controller.restoreWindow(window.id);
                } else {
                  widget.controller.maximizeWindow(window.id);
                }
              },
            ),
            _buildButton(
              icon: Icons.close,
              onPressed: widget.onClosed,
              isClose: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    required VoidCallback onPressed,
    bool isClose = false,
  }) {
    return SizedBox(
      width: 36,
      height: widget.theme.titleBarHeight,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          hoverColor: isClose
              ? Colors.red.withOpacity(0.3)
              : widget.theme.titleBarIconHoverColor.withOpacity(0.2),
          child: Icon(
            icon,
            size: 16,
            color: widget.theme.titleBarIconColor,
          ),
        ),
      ),
    );
  }
}
