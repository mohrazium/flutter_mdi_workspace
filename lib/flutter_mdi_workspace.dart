/// Flutter MDI Workspace Package
///
/// A reusable Flutter package providing a Multiple Document Interface (MDI)
/// workspace layer for desktop and web applications.
///
/// Core exports for the public API.
library flutter_mdi_workspace;

// Core abstractions
export 'src/models/workspace_target.dart';
export 'src/models/window_instance.dart';
export 'src/models/window_visual_state.dart';

// Registry abstraction
export 'src/registry/workspace_registry.dart';

// Route abstractions (optional)
export 'src/routing/workspace_route_mapper.dart';
export 'src/routing/workspace_route_sync_adapter.dart';

// Layout persistence abstractions (optional)
export 'src/persistence/workspace_layout_persistence.dart';

// Controller
export 'src/controller/mdi_workspace_controller.dart';

// Theme
export 'src/theme/mdi_workspace_theme.dart';

// Main widgets
export 'src/widgets/mdi_workspace.dart';
export 'src/widgets/mdi_window.dart';
export 'src/widgets/mdi_window_title_bar.dart';
export 'src/widgets/mdi_taskbar.dart';
