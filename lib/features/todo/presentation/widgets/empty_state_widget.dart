// lib/features/todo/presentation/widgets/empty_state_widget.dart

import 'package:flutter/material.dart';
import '../bloc/todo_event.dart';

class EmptyStateWidget extends StatelessWidget {
  final TodoFilter? filter;
  final VoidCallback? onAddTodo;

  const EmptyStateWidget({
    Key? key,
    this.filter,
    this.onAddTodo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String message;
    IconData icon;

    switch (filter) {
      case TodoFilter.pending:
        message = 'No pending todos!\nYou\'re all caught up!';
        icon = Icons.check_circle_outline;
        break;
      case TodoFilter.completed:
        message = 'No completed todos yet.\nStart checking off some tasks!';
        icon = Icons.assignment_turned_in_outlined;
        break;
      case TodoFilter.all:
      default:
        message = 'No todos yet.\nTap + to create your first todo!';
        icon = Icons.note_add_outlined;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 100,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          if (onAddTodo != null && filter == TodoFilter.all) ...[
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onAddTodo,
              icon: const Icon(Icons.add),
              label: const Text('Add Todo'),
            ),
          ],
        ],
      ),
    );
  }
}