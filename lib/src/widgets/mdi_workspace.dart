import 'package:flutter/material.dart';
import '../../flutter_mdi_workspace.dart';
import '../controller/mdi_workspace_controller.dart';
import '../models/window_instance.dart';
import '../models/window_visual_state.dart';
import '../registry/workspace_registry.dart';
import '../theme/mdi_workspace_theme.dart';

/// Main MDI workspace widget.
///
/// Renders all open windows as a Stack of Positioned widgets.
/// Handles window layering by z-index and manages the workspace background.
class MdiWorkspace extends StatefulWidget {
  /// Controller managing workspace state.
  final MdiWorkspaceController controller;

  /// Registry for building window content.
  final WorkspaceRegistry registry;

  /// Theme for the workspace.
  final MdiWorkspaceTheme theme;

  /// Optional callback when a window is closed.
  final void Function(String windowId)? onWindowClosed;

  /// Optional callback when a window is activated.
  final void Function(String windowId)? onWindowActivated;

  MdiWorkspace({
    super.key,
    required this.controller,
    required this.registry,
    MdiWorkspaceTheme? theme,
    this.onWindowClosed,
    this.onWindowActivated,
  })  : theme = theme ?? MdiWorkspaceTheme();

  @override
  State<MdiWorkspace> createState() => _MdiWorkspaceState();
}

class _MdiWorkspaceState extends State<MdiWorkspace> {
  late final MdiWorkspaceController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _controller.addListener(_onControllerChanged);
  }

  @override
  void didUpdateWidget(MdiWorkspace oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onControllerChanged);
      _controller = widget.controller;
      _controller.addListener(_onControllerChanged);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Get all non-minimized windows, sorted by z-index
    final visibleWindows = _controller.getVisibleWindows();
    visibleWindows.sort((a, b) => a.zIndex.compareTo(b.zIndex));

    return LayoutBuilder(
      builder: (context, constraints) {
        // Update workspace dimensions in controller
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _controller.setWorkspaceDimensions(
            constraints.maxWidth,
            constraints.maxHeight,
          );
        });

        return Container(
          color: widget.theme.workspaceBackgroundColor,
          child: Stack(
            children: [
              // Render all visible windows
              for (final window in visibleWindows)
                _buildWindowPositioned(context, window),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWindowPositioned(BuildContext context, WindowInstance window) {
    // For maximized windows, fill the entire workspace
    if (window.visualState == WindowVisualState.maximized) {
      return Positioned(
        left: 0,
        top: 0,
        right: 0,
        bottom: 0,
        child: MdiWindow(
          window: window,
          controller: _controller,
          theme: widget.theme,
          registry: widget.registry,
          onClosed: widget.onWindowClosed,
          onActivated: widget.onWindowActivated,
        ),
      );
    }

    // For normal windows, use the stored position/size
    return Positioned(
      left: window.x,
      top: window.y,
      width: window.width,
      height: window.height,
      child: MdiWindow(
        window: window,
        controller: _controller,
        theme: widget.theme,
        registry: widget.registry,
        onClosed: widget.onWindowClosed,
        onActivated: widget.onWindowActivated,
      ),
    );
  }
}
