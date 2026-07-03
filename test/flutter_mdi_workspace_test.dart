// ignore_for_file: directives_ordering

// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:flutter_mdi_workspace/flutter_mdi_workspace.dart';

void main() {
  group('MDI Workspace Tests', () {
    test('WorkspaceTarget equality', () {
      final target1 = WorkspaceTarget(type: 'test');
      final target2 = WorkspaceTarget(type: 'test');
      expect(target1, equals(target2));
    });

    test('WindowInstance creation', () {
      final target = WorkspaceTarget(type: 'test');
      final window = WindowInstance(
        id: 'window1',
        target: target,
      );
      expect(window.id, equals('window1'));
      expect(window.visualState, equals(WindowVisualState.normal));
      expect(window.canDrag, true);
      expect(window.canResize, true);
    });

    test('WindowVisualState constraints', () {
      final target = WorkspaceTarget(type: 'test');
      final minimized = WindowInstance(
        id: 'w1',
        target: target,
        visualState: WindowVisualState.minimized,
      );
      expect(minimized.canDrag, false);
      expect(minimized.canResize, false);

      final maximized = WindowInstance(
        id: 'w2',
        target: target,
        visualState: WindowVisualState.maximized,
      );
      expect(maximized.canDrag, false);
      expect(maximized.canResize, false);
    });

    test('MdiWorkspaceController - open window', () {
      final controller = MdiWorkspaceController();
      final target = WorkspaceTarget(type: 'test');
      
      final window = controller.openWindow(target: target);
      
      expect(window.id, isNotEmpty);
      expect(window.target, equals(target));
      expect(window.isActive, true);
      expect(controller.windows.length, equals(1));
    });

    test('MdiWorkspaceController - close window', () {
      final controller = MdiWorkspaceController();
      final window = controller.openWindow(
        target: WorkspaceTarget(type: 'test'),
      );
      
      expect(controller.windows.length, equals(1));
      controller.closeWindow(window.id);
      expect(controller.windows.length, equals(0));
    });

    test('MdiWorkspaceController - activate window', () {
      final controller = MdiWorkspaceController();
      final w1 = controller.openWindow(target: WorkspaceTarget(type: 'w1'));
      final w2 = controller.openWindow(target: WorkspaceTarget(type: 'w2'));
      
      expect(controller.getActiveWindow()?.id, equals(w2.id));
      controller.activateWindow(w1.id);
      expect(controller.getActiveWindow()?.id, equals(w1.id));
    });

    test('MdiWorkspaceController - minimize window', () {
      final controller = MdiWorkspaceController();
      final window = controller.openWindow(
        target: WorkspaceTarget(type: 'test'),
      );
      
      expect(window.visualState, equals(WindowVisualState.normal));
      controller.minimizeWindow(window.id);
      
      final minimized = controller.getWindow(window.id);
      expect(minimized?.visualState, equals(WindowVisualState.minimized));
    });

    test('MdiWorkspaceController - maximize window', () {
      final controller = MdiWorkspaceController();
      final window = controller.openWindow(
        target: WorkspaceTarget(type: 'test'),
      );
      
      controller.maximizeWindow(window.id);
      final maximized = controller.getWindow(window.id);
      expect(maximized?.visualState, equals(WindowVisualState.maximized));
    });

    test('MdiWorkspaceController - z-index management', () {
      final controller = MdiWorkspaceController();
      final w1 = controller.openWindow(target: WorkspaceTarget(type: 'w1'));
      final w2 = controller.openWindow(target: WorkspaceTarget(type: 'w2'));
      
      final sorted = controller.getWindowsSortedByZIndex();
      expect(sorted[0].zIndex, lessThan(sorted[1].zIndex));
    });

    test('MdiWorkspaceController - listener notification', () {
      final controller = MdiWorkspaceController();
      int callCount = 0;
      
      controller.addListener(() => callCount++);
      controller.openWindow(target: WorkspaceTarget(type: 'test'));
      
      expect(callCount, equals(1));
    });
  });
}
