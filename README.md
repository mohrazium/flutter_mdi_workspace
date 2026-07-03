# Flutter MDI Workspace

A reusable Flutter package providing a Multiple Document Interface (MDI) workspace layer for desktop and web applications.

## Overview

This package implements a Stack-based MDI workspace with draggable, resizable, and manageable internal windows inspired by desktop GUI behavior.

**Key Features:**
- Draggable and resizable windows
- Minimize, maximize, restore, and close operations
- Window activation and z-index ordering
- Optional taskbar for window management
- Fully themeable
- Registry-based content architecture (works with any design system)
- Router-agnostic with optional route sync abstractions
- Layout persistence abstractions

## Architecture

The package is designed to be embedded in any existing Flutter UI framework (fluent_ui, Material, Cupertino, custom design systems).

### Core Components

1. **WorkspaceTarget** - Identifies what content a window displays
2. **WindowInstance** - Represents an open window with state and geometry
3. **WindowVisualState** - Enum: normal, minimized, maximized
4. **MdiWorkspaceController** - State management for windows
5. **MdiWorkspace** - Main widget (Stack-based layout)
6. **MdiWindow** - Individual window widget
7. **MdiWindowTitleBar** - Draggable title bar with controls
8. **ResizeHandle** - Corner/edge resize handles
9. **MdiTaskbar** - Optional taskbar showing all windows
10. **MdiWorkspaceTheme** - Visual theming
11. **WorkspaceRegistry** - Host-provided registry for content
12. **WorkspaceRouteMapper** & **WorkspaceRouteSyncAdapter** - Optional routing abstractions
13. **WorkspaceLayoutPersistence** - Optional layout persistence abstraction

## Installation

```yaml
dependencies:
  flutter_mdi_workspace:
    path: ../flutter_mdi_workspace
```

## Quick Start

### 1. Create a Registry

```dart
class AppWorkspaceRegistry implements WorkspaceRegistry {
  @override
  Widget build(BuildContext context, WorkspaceTarget target) {
    switch (target.type) {
      case 'home':
        return const HomePage();
      case 'users':
        return const UsersPage();
      case 'settings':
        return const SettingsPage();
      default:
        return Center(
          child: Text('Unknown: ${target.type}'),
        );
    }
  }
}
```

### 2. Create a Controller

```dart
final controller = MdiWorkspaceController();
```

### 3. Build the Workspace

```dart
MdiWorkspace(
  controller: controller,
  registry: AppWorkspaceRegistry(),
)
```

### 4. Open Windows

```dart
controller.openWindow(
  target: WorkspaceTarget(type: 'home'),
  x: 50,
  y: 50,
  width: 600,
  height: 400,
);

controller.openWindow(
  target: WorkspaceTarget(
    type: 'users',
    params: {'filter': 'active'},
  ),
  x: 100,
  y: 100,
);
```

## Complete Example

```dart
import 'package:flutter/material.dart';
import 'package:flutter_mdi_workspace/flutter_mdi_workspace.dart';

class AppWorkspaceRegistry implements WorkspaceRegistry {
  @override
  Widget build(BuildContext context, WorkspaceTarget target) {
    switch (target.type) {
      case 'home':
        return const HomePage();
      default:
        return Center(child: Text('Target: ${target.type}'));
    }
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Home Window'),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final MdiWorkspaceController _controller;

  @override
  void initState() {
    super.initState();
    _controller = MdiWorkspaceController();
    
    // Open initial windows
    _controller.openWindow(
      target: WorkspaceTarget(type: 'home'),
      x: 50,
      y: 50,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: MdiWorkspace(
                controller: _controller,
                registry: AppWorkspaceRegistry(),
              ),
            ),
            MdiTaskbar(
              controller: _controller,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

void main() {
  runApp(MyApp());
}
```

## Window Operations

### Opening a Window

```dart
controller.openWindow(
  target: WorkspaceTarget(type: 'document'),
  x: 20,
  y: 20,
  width: 500,
  height: 400,
  minWidth: 300,
  minHeight: 250,
  customTitle: 'My Document',
);
```

### Closing a Window

```dart
controller.closeWindow(windowId);
```

### Activating/Focusing a Window

```dart
controller.activateWindow(windowId);
```

### Minimizing a Window

```dart
controller.minimizeWindow(windowId);
```

### Maximizing a Window

```dart
controller.maximizeWindow(windowId);
```

### Restoring a Window

```dart
controller.restoreWindow(windowId);
```

### Getting Window Information

```dart
// Get all windows
var allWindows = controller.windows;

// Get visible (non-minimized) windows
var visibleWindows = controller.getVisibleWindows();

// Get minimized windows
var minimizedWindows = controller.getMinimizedWindows();

// Get active window
var activeWindow = controller.getActiveWindow();

// Get specific window
var window = controller.getWindow(windowId);
```

## Theming

```dart
MdiWorkspace(
  controller: controller,
  registry: registry,
  theme: MdiWorkspaceTheme(
    workspaceBackgroundColor: Colors.grey[900]!,
    titleBarBackgroundColor: const Color(0xFF0078D4),
    titleBarTextColor: Colors.white,
    windowBorderColor: Colors.grey[700]!,
  ),
)
```

### Predefined Themes

```dart
MdiWorkspaceTheme.light()  // Default light theme
MdiWorkspaceTheme.dark()   // Dark theme
```

## Optional: Route Integration

The package provides abstractions for routing integration without depending on any specific router.

### Implement WorkspaceRouteMapper

```dart
class MyRouteMapper implements WorkspaceRouteMapper {
  @override
  WorkspaceTarget? parseUri(Uri uri) {
    if (uri.path == '/home') {
      return WorkspaceTarget(type: 'home');
    }
    if (uri.path.startsWith('/user/')) {
      final id = uri.path.split('/')[2];
      return WorkspaceTarget(
        type: 'user.edit',
        params: {'id': id},
      );
    }
    return null;
  }

  @override
  Uri buildUri(WorkspaceTarget target) {
    switch (target.type) {
      case 'home':
        return Uri.parse('/home');
      case 'user.edit':
        return Uri.parse('/user/${target.params['id']}');
      default:
        return Uri.parse('/');
    }
  }
}
```

### Implement WorkspaceRouteSyncAdapter

```dart
class MyRouteSyncAdapter implements WorkspaceRouteSyncAdapter {
  final GoRouter router;
  final List<VoidCallback> _listeners = [];

  MyRouteSyncAdapter(this.router) {
    router.routerDelegate.addListener(_notifyListeners);
  }

  @override
  Uri get currentUri => Uri.parse(
    router.routerDelegate.currentConfiguration.fullPath ?? '/',
  );

  @override
  void go(Uri uri) => router.go(uri.toString());

  @override
  void replace(Uri uri) => router.replace(uri.toString());

  @override
  void addListener(VoidCallback listener) => _listeners.add(listener);

  @override
  void removeListener(VoidCallback listener) => _listeners.remove(listener);

  void _notifyListeners() {
    for (final listener in _listeners) {
      listener();
    }
  }
}
```

## Optional: Layout Persistence

```dart
class MyLayoutPersistence implements WorkspaceLayoutPersistence {
  @override
  Future<void> saveLayout(List<WindowInstance> windows) async {
    // Save to local storage, database, etc.
  }

  @override
  Future<List<WindowInstance>?> loadLayout() async {
    // Load from storage
    return null;
  }

  @override
  Future<void> clearLayout() async {
    // Clear saved layout
  }
}
```

## Host App Integration Pattern

```dart
FluentApp(
  home: NavigationView(
    pane: NavigationPane(
      items: [
        PaneItem(icon: const Icon(FluentIcons.home), title: const Text('Home')),
        PaneItem(icon: const Icon(FluentIcons.add), title: const Text('New')),
      ],
    ),
    content: Column(
      children: [
        Expanded(
          child: MdiWorkspace(
            controller: _workspaceController,
            registry: _registry,
          ),
        ),
        MdiTaskbar(
          controller: _workspaceController,
        ),
      ],
    ),
  ),
)
```

## What This Package Does NOT Include

- ❌ Application shell or framework
- ❌ Dashboard or landing pages
- ❌ Routing implementation
- ❌ Menus, sidebars, or app bars
- ❌ Authentication or authorization
- ❌ Business logic or pages
- ❌ Dependency on any specific router (GoRouter, AutoRoute, etc.)

The host app owns all of these concerns.

## License

MIT
