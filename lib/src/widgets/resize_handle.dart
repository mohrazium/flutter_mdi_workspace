import 'package:flutter/material.dart';
import '../controller/mdi_workspace_controller.dart';
import '../models/window_instance.dart';
import '../theme/mdi_workspace_theme.dart';

/// Resize handle for an MDI window.
///
/// Small draggable widget positioned at window edges/corners.
/// Updates window size based on drag deltas.
class ResizeHandle extends StatefulWidget {
  /// The window being resized.
  final WindowInstance window;

  /// Workspace controller.
  final MdiWorkspaceController controller;

  /// Resize direction.
  final ResizeDirection direction;

  /// Theme.
  final MdiWorkspaceTheme theme;

  const ResizeHandle({
    Key? key,
    required this.window,
    required this.controller,
    required this.direction,
    required this.theme,
  }) : super(key: key);

  @override
  State<ResizeHandle> createState() => _ResizeHandleState();
}

class _ResizeHandleState extends State<ResizeHandle> {
  late MouseCursor _cursor;

  @override
  void initState() {
    super.initState();
    _cursor = _getCursorForDirection(widget.direction);
  }

  MouseCursor _getCursorForDirection(ResizeDirection direction) {
    switch (direction) {
      case ResizeDirection.left:
      case ResizeDirection.right:
        return SystemMouseCursors.resizeColumn;
      case ResizeDirection.top:
      case ResizeDirection.bottom:
        return SystemMouseCursors.resizeRow;
      case ResizeDirection.topLeft:
      case ResizeDirection.bottomRight:
        return SystemMouseCursors.resizeUpLeftDownRight;
      case ResizeDirection.topRight:
      case ResizeDirection.bottomLeft:
        return SystemMouseCursors.resizeUpRightDownLeft;
    }
  }

  @override
  Widget build(BuildContext context) {
    final window = widget.window;
    final canResize = window.canResize;

    return MouseRegion(
      cursor: canResize ? _cursor : MouseCursor.defer,
      child: GestureDetector(
        onPanUpdate: canResize
            ? (details) {
                widget.controller.resizeWindowFromHandle(
                  window.id,
                  widget.direction,
                  details.delta,
                );
              }
            : null,
        child: Container(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              border: _buildBorder(),
            ),
          ),
        ),
      ),
    );
  }

  Border _buildBorder() {
    final color = widget.theme.resizeHandleColor;
    final width = widget.theme.resizeHandleWidth;

    switch (widget.direction) {
      case ResizeDirection.left:
        return Border(left: BorderSide(color: color, width: width));
      case ResizeDirection.right:
        return Border(right: BorderSide(color: color, width: width));
      case ResizeDirection.top:
        return Border(top: BorderSide(color: color, width: width));
      case ResizeDirection.bottom:
        return Border(bottom: BorderSide(color: color, width: width));
      case ResizeDirection.topLeft:
        return Border(
          top: BorderSide(color: color, width: width),
          left: BorderSide(color: color, width: width),
        );
      case ResizeDirection.topRight:
        return Border(
          top: BorderSide(color: color, width: width),
          right: BorderSide(color: color, width: width),
        );
      case ResizeDirection.bottomLeft:
        return Border(
          bottom: BorderSide(color: color, width: width),
          left: BorderSide(color: color, width: width),
        );
      case ResizeDirection.bottomRight:
        return Border(
          bottom: BorderSide(color: color, width: width),
          right: BorderSide(color: color, width: width),
        );
    }
  }
}
