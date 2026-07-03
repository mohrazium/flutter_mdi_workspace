import '../models/window_instance.dart';

/// Optional abstraction for persisting and restoring workspace layout.
///
/// Allows the host app to save and restore window positions, sizes, and states.
/// The MDI package provides no concrete implementation; the host app decides
/// how to persist this data (local storage, database, etc.).
abstract class WorkspaceLayoutPersistence {
  /// Save the current workspace layout (list of windows).
  Future<void> saveLayout(List<WindowInstance> windows);

  /// Load a previously saved workspace layout.
  /// Returns null if no layout was saved.
  Future<List<WindowInstance>?> loadLayout();

  /// Clear any persisted layout.
  Future<void> clearLayout();
}
