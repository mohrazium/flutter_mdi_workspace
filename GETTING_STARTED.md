## Getting Started

This is a Flutter package for building MDI (Multiple Document Interface) workspaces.

## What This Package Provides

The `flutter_mdi_workspace` package provides:

- A reusable MDI layer that works with any Flutter UI framework
- Stack-based window management with dragging and resizing
- Window lifecycle management (open, close, minimize, maximize, restore)
- Optional taskbar for window navigation
- Themeable components
- Registry-based content architecture
- Optional route synchronization abstractions
- Optional layout persistence abstractions

## What This Package Does NOT Provide

- Application shell or framework
- Routing implementation
- Menus, sidebars, or app bars
- Authentication or authorization
- Business logic or pages
- Dependency on specific UI frameworks (Material, Fluent, Cupertino)

The host application owns all of these concerns and embeds the MDI workspace as needed.

## Project Structure

```
flutter_mdi_workspace/
├── lib/
│   ├── flutter_mdi_workspace.dart          # Main library export
│   └── src/
│       ├── models/
│       │   ├── workspace_target.dart       # (1) Target abstraction
│       │   ├── window_instance.dart        # (2) Window state
│       │   └── window_visual_state.dart    # (3) State enum
│       ├── registry/
│       │   └── workspace_registry.dart     # (11) Content registry
│       ├── routing/                        # Optional routing abstractions
│       │   ├── workspace_route_mapper.dart # (12)
│       │   └── workspace_route_sync_adapter.dart # (12)
│       ├── persistence/                    # Optional persistence abstractions
│       │   └── workspace_layout_persistence.dart # (13)
│       ├── controller/
│       │   └── mdi_workspace_controller.dart # (5) State management
│       ├── theme/
│       │   └── mdi_workspace_theme.dart    # (11) Theme system
│       └── widgets/
│           ├── mdi_workspace.dart          # (6) Main workspace
│           ├── mdi_window.dart             # (7) Window widget
│           ├── mdi_window_title_bar.dart   # (8) Title bar
│           ├── resize_handle.dart          # (9) Resize handles
│           └── mdi_taskbar.dart            # (10) Taskbar
├── example/
│   ├── main.dart                           # Example application
│   └── pubspec.yaml
├── test/
│   └── flutter_mdi_workspace_test.dart     # Unit tests
├── README.md                               # User documentation
├── pubspec.yaml                            # Package metadata
└── CHANGELOG.md                            # Version history
```

## Next Steps

1. Review the [README.md](README.md) for usage documentation
2. Check the [example/main.dart](example/main.dart) for a working example
3. Run tests with: `flutter test`
4. Review the core abstractions to understand extension points

## Core Abstractions

- **WorkspaceTarget**: Identifies window content (host app decides meaning)
- **WorkspaceRegistry**: Builds UI for WorkspaceTargets (host app implements)
- **WorkspaceRouteMapper**: Maps URIs to targets (optional, host implements)
- **WorkspaceRouteSyncAdapter**: Bridges router to workspace (optional, host implements)
- **WorkspaceLayoutPersistence**: Saves/loads layouts (optional, host implements)

## Integration Pattern

```dart
class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late MdiWorkspaceController controller;
  
  @override
  void initState() {
    super.initState();
    controller = MdiWorkspaceController();
  }
  
  @override
  Widget build(BuildContext context) {
    return MyAppShell(
      // Host app shell with menus, routing, etc.
      child: MdiWorkspace(
        controller: controller,
        registry: MyContentRegistry(),
      ),
    );
  }
}
```
