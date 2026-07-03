// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_mdi_workspace/flutter_mdi_workspace.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MDI Workspace Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final MdiWorkspaceController _controller;
  int _windowCounter = 0;

  @override
  void initState() {
    super.initState();
    _controller = MdiWorkspaceController();
    _openInitialWindows();
  }

  void _openInitialWindows() {
    _controller.openWindow(
      target: WorkspaceTarget(type: 'welcome'),
      x: 50,
      y: 50,
      width: 500,
      height: 350,
      customTitle: 'Welcome',
    );

    _controller.openWindow(
      target: WorkspaceTarget(type: 'counter'),
      x: 120,
      y: 120,
      width: 400,
      height: 300,
      customTitle: 'Counter Window',
    );
  }

  void _openNewWindow() {
    _windowCounter++;
    _controller.openWindow(
      target: WorkspaceTarget(
        type: 'document',
        params: {'id': _windowCounter.toString()},
      ),
      x: 50 + (_windowCounter * 20),
      y: 50 + (_windowCounter * 20),
      width: 450,
      height: 350,
      customTitle: 'Document #$_windowCounter',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MDI Workspace Demo'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              onPressed: _openNewWindow,
              icon: const Icon(Icons.add),
              label: const Text('New Window'),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: MdiWorkspace(
              controller: _controller,
              registry: _DemoRegistry(),
              theme: MdiWorkspaceTheme.light(),
              onWindowClosed: (windowId) {
                print('Window closed: $windowId');
              },
              onWindowActivated: (windowId) {
                print('Window activated: $windowId');
              },
            ),
          ),
          MdiTaskbar(
            controller: _controller,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _DemoRegistry implements WorkspaceRegistry {
  @override
  Widget build(BuildContext context, WorkspaceTarget target) {
    switch (target.type) {
      case 'welcome':
        return const _WelcomePage();
      case 'counter':
        return const _CounterPage();
      case 'document':
        return _DocumentPage(documentId: target.params['id'] ?? 'unknown');
      default:
        return Center(
          child: Text('Unknown target: ${target.type}'),
        );
    }
  }
}

class _WelcomePage extends StatelessWidget {
  const _WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Welcome to Flutter MDI Workspace',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'This is a demonstration of the flutter_mdi_workspace package.',
          ),
          const SizedBox(height: 16),
          const Text(
            'Features:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('• Draggable windows (drag the title bar)'),
          const Text('• Resizable windows (drag edges/corners)'),
          const Text('• Minimize, maximize, restore, close'),
          const Text('• Window focus and z-index management'),
          const Text('• Taskbar for quick window navigation'),
          const SizedBox(height: 16),
          const Text(
            'Try:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('1. Click "New Window" to open more windows'),
          const Text('2. Drag window title bars to move them'),
          const Text('3. Drag window edges to resize'),
          const Text('4. Use minimize/maximize buttons'),
          const Text('5. Click taskbar items to manage windows'),
        ],
      ),
    );
  }
}

class _CounterPage extends StatefulWidget {
  const _CounterPage({Key? key}) : super(key: key);

  @override
  State<_CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<_CounterPage> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Counter Window',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Text(
            '$_count',
            style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => setState(() => _count--),
                child: const Text('−'),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () => setState(() => _count++),
                child: const Text('+'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DocumentPage extends StatelessWidget {
  final String documentId;

  const _DocumentPage({Key? key, required this.documentId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Document #$documentId',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Expanded(
            child: TextField(
              maxLines: null,
              expands: true,
              decoration: InputDecoration(
                hintText: 'Type here...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Document #$documentId saved!')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
