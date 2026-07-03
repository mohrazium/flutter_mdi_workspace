/// Represents a target/document to be opened in an MDI window.
///
/// This is a simple data structure that the host app uses to identify
/// what content should be displayed in a window. The MDI package does not
/// interpret this; it only passes it to [WorkspaceRegistry.build].
///
/// Example:
/// ```dart
/// WorkspaceTarget(
///   type: 'customers.list',
///   params: {},
/// )
///
/// WorkspaceTarget(
///   type: 'customer.edit',
///   params: {'id': '123'},
/// )
/// ```
class WorkspaceTarget {
  /// Unique identifier for the target type.
  /// Host app decides naming convention (e.g., 'customers.list', 'invoice.new').
  final String type;

  /// Optional parameters passed to the window content builder.
  /// Host app interprets these parameters.
  final Map<String, dynamic> params;

  WorkspaceTarget({
    required this.type,
    this.params = const {},
  });

  /// Create a copy with optional field overrides.
  WorkspaceTarget copyWith({
    String? type,
    Map<String, dynamic>? params,
  }) {
    return WorkspaceTarget(
      type: type ?? this.type,
      params: params ?? this.params,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkspaceTarget &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          params == other.params;

  @override
  int get hashCode => type.hashCode ^ params.hashCode;

  @override
  String toString() => 'WorkspaceTarget(type: $type, params: $params)';
}
