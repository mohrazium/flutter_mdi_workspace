# Change Log

## [0.1.0] - 2026-07-03

### Added

- Initial release of flutter_mdi_workspace package
- Core MDI workspace functionality:
  - Stack-based window layout
  - Draggable windows (title bar)
  - Resizable windows (all 8 directions)
  - Window minimize, maximize, restore, close operations
  - Window activation and z-index management
  - Taskbar for window navigation
- MdiWorkspaceTheme for visual customization
- WorkspaceRegistry for host-app content binding
- MdiWorkspaceController for state management
- Optional abstractions:
  - WorkspaceRouteMapper for routing integration
  - WorkspaceRouteSyncAdapter for router sync
  - WorkspaceLayoutPersistence for layout saving/loading
- Complete example application
- Unit tests for core functionality
