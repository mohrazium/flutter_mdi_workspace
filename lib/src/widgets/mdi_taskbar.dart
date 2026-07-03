import 'package:flutter/material.dart';
import '../controller/mdi_workspace_controller.dart';
import '../models/window_visual_state.dart';
import '../theme/mdi_workspace_theme.dart';

/// Taskbar showing all open windows.
///
/// Displays buttons for each open window.
/// - Clicking a minimized window restores and activates it.
/// - Clicking a normal inactive window activates it.
/// - Clicking the active window minimizes it.
class MdiTaskbar extends StatefulWidget {
  /// Workspace controller.
  final MdiWorkspaceController controller;

  /// Theme.
  final MdiWorkspaceTheme theme;

  /// Optional height override.
  final double? height;

  const MdiTaskbar({
    Key? key,
    required this.controller,
    this.theme = const MdiWorkspaceTheme(),
    this.height,
  }) : super(key: key);

  @override
  State<MdiTaskbar> createState() => _MdiTaskbarState();
}

class _MdiTaskbarState extends State<MdiTaskbar> {
  late final MdiWorkspaceController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _controller.addListener(_onControllerChanged);
  }

  @override
  void didUpdateWidget(MdiTaskbar oldWidget) {
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
    final windows = _controller.windows;

    return Container(
      height: widget.height ?? widget.theme.taskbarButtonHeight,
      decoration: BoxDecoration(
        color: widget.theme.taskbarBackgroundColor,
        border: Border(
          top: BorderSide(
            color: widget.theme.taskbarBorderColor,
            width: widget.theme.taskbarBorderWidth,
          ),
        ),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: windows.length,
        itemBuilder: (context, index) {
          final window = windows[index];
          return _buildTaskbarButton(window);
        },
      ),
    );
  }

  Widget _buildTaskbarButton(window) {
    final isMinimized = window.visualState == WindowVisualState.minimized;
    final isActive = window.isActive && !isMinimized;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 4.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (isMinimized) {
              // Restore and activate
              _controller.activateWindow(window.id);
            } else if (isActive) {
              // Minimize
              _controller.minimizeWindow(window.id);
            } else {
              // Activate
              _controller.activateWindow(window.id);
            }
          },
          child: Container(
            constraints: const BoxConstraints(minWidth: 100, maxWidth: 200),
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFF0078D4) : Colors.grey[300],
              border: Border.all(
                color: isActive ? Colors.transparent : Colors.grey[600]!,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(2),
            ),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isMinimized)
                  Icon(
                    Icons.unfold_less,
                    size: 12,
                    color: isActive ? Colors.white : Colors.black,
                  ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    isMinimized ? '[${window.getTitle()}]' : window.getTitle(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                      color: isActive ? Colors.white : Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
