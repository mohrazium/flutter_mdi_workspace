import '../models/workspace_target.dart';

/// Optional abstraction for mapping between URIs and [WorkspaceTarget].
///
/// This allows the MDI package to remain router-agnostic while still supporting
/// route synchronization if the host app implements it.
///
/// The host app implements this to define how URIs map to window targets.
abstract class WorkspaceRouteMapper {
  /// Parse a URI and return the corresponding [WorkspaceTarget], or null if unmapped.
  WorkspaceTarget? parseUri(Uri uri);

  /// Build a URI from a [WorkspaceTarget].
  Uri buildUri(WorkspaceTarget target);
}
