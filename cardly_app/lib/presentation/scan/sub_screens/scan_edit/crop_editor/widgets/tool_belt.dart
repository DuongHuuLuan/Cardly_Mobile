import 'package:flutter/material.dart';

class ToolBelt extends StatelessWidget {
  final bool canUndo;
  final bool canRedo;
  final VoidCallback onUndo;
  final VoidCallback onRedo;
  final VoidCallback onReset;

  const ToolBelt({
    super.key,
    required this.canUndo,
    required this.canRedo,
    required this.onUndo,
    required this.onRedo,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildIconButton(Icons.undo, 'Undo', canUndo, onUndo),
          const SizedBox(width: 24),
          _buildIconButton(Icons.redo, 'Redo', canRedo, onRedo),
          const SizedBox(width: 24),
          _buildIconButton(Icons.restart_alt, 'Reset', true, onReset),
        ],
      ),
    );
  }

  Widget _buildIconButton(
    IconData icon,
    String tooltip,
    bool enabled,
    VoidCallback onTap,
  ) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: enabled ? Colors.grey.shade100 : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            icon,
            size: 20,
            color: enabled ? Colors.black87 : Colors.grey.shade400,
          ),
        ),
      ),
    );
  }
}
