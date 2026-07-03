import 'package:flutter/material.dart';
import '../models/workspace_target.dart';

/// Abstract registry for building window content based on [WorkspaceTarget].
///
/// The MDI package does not know about business pages or content.
/// The host app implements this to provide the actual UI for each window type.
///
/// Example:
/// ```dart
/// class AppWorkspaceRegistry implements WorkspaceRegistry {
///   @override
///   Widget build(BuildContext context, WorkspaceTarget target) {
///     switch (target.type) {
///       case 'customers.list':
///         return const CustomersListPage();
///       case 'customer.edit':
///         return CustomerEditPage(id: target.params['id']!);
///       case 'invoice.new':
///         return const InvoiceCreatePage();
///       default:
///         return UnknownTargetPage(target: target);
///     }
///   }
/// }
/// ```
abstract class WorkspaceRegistry {
  /// Build the content widget for the given target.
  ///
 /// Called when a window instance is rendered.
  /// The host app decides what content to display based on [target].
  Widget build(BuildContext context, WorkspaceTarget target);
}
