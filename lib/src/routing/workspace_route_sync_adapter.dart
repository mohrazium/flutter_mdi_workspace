/// Optional abstraction for synchronizing the MDI workspace with routing.
///
/// This allows the host app to bridge between its router and the MDI workspace.
/// The MDI package never imports concrete router packages.
///
/// Example host implementation:
/// ```dart
/// class GoRouterSyncAdapter implements WorkspaceRouteSyncAdapter {
///   final GoRouter router;
///
///   GoRouterSyncAdapter(this.router);
///
///   @override
///   Uri get currentUri => Uri.parse(router.routerDelegate.currentConfiguration.fullPath ?? '/');
///
///   @override
///   void go(Uri uri) => router.go(uri.toString());
///
///   @override
///   void replace(Uri uri) => router.replace(uri.toString());
///
///   @override
///   void addListener(VoidCallback listener) {
///     router.routerDelegate.addListener(listener);
///   }
///
///   @override
///   void removeListener(VoidCallback listener) {
///     router.routerDelegate.removeListener(listener);
///   }
/// }
/// ```
abstract class WorkspaceRouteSyncAdapter {
  /// Get the current URI from the router.
  Uri get currentUri;

  /// Navigate to the given URI (push).
  void go(Uri uri);

  /// Replace the current route with the given URI.
  void replace(Uri uri);

  /// Add a listener to be called when the route changes.
  void addListener(void Function() listener);

  /// Remove a previously added listener.
  void removeListener(void Function() listener);
}
