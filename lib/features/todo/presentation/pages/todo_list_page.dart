// lib/features/todo/presentation/pages/todo_list_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todo_app/features/todo/domain/entities/todo.dart';
import '../../../../core/di/injection_container.dart';
import '../bloc/todo_bloc.dart';
import '../bloc/todo_event.dart';
import '../bloc/todo_state.dart';
import '../../../../core/presentation/cubit/theme_cubit.dart';
import '../widgets/todo_item_widget.dart';
import '../widgets/empty_state_widget.dart';
import 'add_todo_page.dart';

class TodoListPage extends StatelessWidget {
  const TodoListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TodoBloc>()..add(LoadTodosEvent()),
      child: const TodoListView(),
    );
  }
}

class TodoListView extends StatelessWidget {
  const TodoListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<TodoBloc, TodoState>(
            builder: (context, state){
              if(state is TodosLoaded){
                final completed = state.completedCount;
                final total = state.totalCount;

                return
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('TaskFlow - Todo App', style: TextStyle(fontWeight: FontWeight.w900)),
                      Text("$completed of $total tasks completed",
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onBackground.withAlpha(170)
                          ))
                    ],
                  );
              }
              return const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TaskFlow - Todo App',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              );
            }
        ),
        actions: [

          // Replace the theme button in AppBar actions with:
          IconButton(
            icon: BlocBuilder<ThemeCubit, ThemeState>(
              builder: (context, themeState) {
                switch (themeState) {
                  case ThemeState.light:
                    return const Icon(Icons.light_mode);
                  case ThemeState.dark:
                    return const Icon(Icons.dark_mode);
                  case ThemeState.system:
                    return const Icon(Icons.brightness_auto);
                }
              },
            ),
            onPressed: () {
              final themeCubit = context.read<ThemeCubit>();
              final currentTheme = themeCubit.state;

              // Cycle through themes: light -> dark -> system -> light
              ThemeState nextTheme;
              switch (currentTheme) {
                case ThemeState.light:
                  nextTheme = ThemeState.dark;
                  break;
                case ThemeState.dark:
                  nextTheme = ThemeState.system;
                  break;
                case ThemeState.system:
                  nextTheme = ThemeState.light;
                  break;
              }

              themeCubit.setTheme(nextTheme);
            },
            tooltip: 'Toggle theme',
          ),

          PopupMenuButton<TodoFilter>(
            onSelected: (filter) {
              context.read<TodoBloc>().add(FilterTodosEvent(filter));
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: TodoFilter.all,
                child: Text('All'),
              ),
              const PopupMenuItem(
                value: TodoFilter.pending,
                child: Text('Pending'),
              ),
              const PopupMenuItem(
                value: TodoFilter.completed,
                child: Text('Completed'),
              ),
            ],
          ),
        ],
      ),
      body: BlocConsumer<TodoBloc, TodoState>(
        listener: (context, state) {
          if (state is TodoError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is TodoOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is TodoLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TodosLoaded) {
            final todos = state.filteredTodos;

            return Column(
              children: [
                _filterBar(context, state.currentFilter),
                if(todos.isEmpty)
                  Expanded(
                      child: EmptyStateWidget(
                        filter: state.currentFilter,
                        onAddTodo: ()=> _navigateToAddTodo(context),
                      )
                  )else
                  Expanded(
                    child: ListView.builder(
                      itemCount: todos.length,
                      padding: const EdgeInsets.all(8),
                      itemBuilder: (context, index) {
                        return TodoItemWidget(
                          todo: todos[index],
                          onToggle: () {
                            context.read<TodoBloc>().add(
                              ToggleTodoStatusEvent(todos[index].id),
                            );
                          },
                          onDelete: () {
                            _showDeleteConfirmation(context, todos[index].id);
                          },
                          onTap: () {
                            // Navigate to detail/edit page
                          },
                        );
                      },
                    ),
                  ),
              ],
            );
          }

          return const EmptyStateWidget();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddTodo(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _filterBar(BuildContext context, TodoFilter activeFilter) {

    final filters = [TodoFilter.all, TodoFilter.pending, TodoFilter.completed];

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: filters
            .map((filter) => Padding(
          padding: const EdgeInsets.only(right: 8),
          child: _filterButton(
              context,
              activeFilter == filter,
              filter.name.toUpperCase(),
              filter),
        ))
            .toList(),
      ),
    );
  }

  Widget _filterButton(
      BuildContext context,
      bool active,
      String label,
      TodoFilter filter
      ) {
    return ElevatedButton(
        onPressed: (){
          context.read<TodoBloc>().add(FilterTodosEvent(filter));
        },
        style: ElevatedButton.styleFrom(elevation: 0,
            backgroundColor: active
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.surfaceContainerHighest),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium
              ?.copyWith(color: active ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.primary),));
  }

  void _navigateToAddTodo(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<TodoBloc>(),
          child: const AddTodoPage(),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Todo'),
        content: const Text('Are you sure you want to delete this todo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<TodoBloc>().add(DeleteTodoEvent(id));
              Navigator.pop(dialogContext);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}