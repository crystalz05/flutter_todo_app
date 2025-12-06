
import 'package:flutter_todo_app/features/todo/domain/usecases/usecase.dart';
import 'package:flutter_todo_app/features/todo/presentation/bloc/todo_event.dart';
import 'package:flutter_todo_app/features/todo/presentation/bloc/todo_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState>{

  final GetAllTodos getAllTodos;
  final GetTodoById getTodoById;
  final CreateTodo createTodo;
  final UpdateTodo updateTodo;
  final ToggleTodoStatus toggleTodoStatus;
  final DeleteTodo deleteTodo;
  final GetCompletedTodos getCompletedTodos;
  final GetPendingTodos getPendingTodos;

  TodoBloc({
    required this.getAllTodos,
    required this.getTodoById,
    required this.createTodo,
    required this.updateTodo,
    required this.toggleTodoStatus,
    required this.deleteTodo,
    required this.getCompletedTodos,
    required this.getPendingTodos
  }): super(TodoInitial()){
    on<LoadTodosEvent>(_onLoadTodos);
    on<LoadTodoByIdEvent>(_onLoadTodoById);
    on<CreateTodoEvent>(_onCreateTodo);
    on<UpdateTodoEvent>(_onUpdateTodo);
    on<ToggleTodoStatusEvent>(_onToggleTodoStatus);
    on<DeleteTodoEvent>(_onDeleteTodo);
    on<FilterTodosEvent>(_onFilterTodos);
  }

  Future<void> _onLoadTodos (
      LoadTodosEvent event,
      Emitter<TodoState> emit,
      )async {
    emit(TodoLoading());

    final result = await getAllTodos(NoParams());

    result.fold(
        (failure) => emit(TodoError(failure.message)),
        (todos) => emit(TodosLoaded(todos: todos)));
  }

  Future<void> _onLoadTodoById(
      LoadTodoByIdEvent event,
      Emitter<TodoState> emit,
      )async{
    emit(TodoLoading());

    final result = await getTodoById(IdParams(id: event.id));

    result.fold(
        (failure) => emit(TodoError(failure.message)),
        (todo) => emit(TodoLoaded(todo)),
    );
  }

  Future<void> _onCreateTodo(
      CreateTodoEvent event,
      Emitter<TodoState> emit,
      ) async {

    //keep current state while creating
    final currentTodo = state;

    final result = await createTodo(
        TodoParams(
            title: event.title,
            description: event.description,
        ),
    );

    await result.fold(
        (failure) async => emit(TodoError(failure.message)),
        (todo) async {
          emit(TodoOperationSuccess("Todo created successfully"));
          add(LoadTodosEvent());
        },
    );
  }

  Future<void> _onUpdateTodo (
      UpdateTodoEvent event,
      Emitter<TodoState> emit,
      )async {

    final result = await updateTodo(TodoParams.fromTodo(event.todo));

    await result.fold(
        (failure) async => TodoError(failure.message),
        (todo) async {
          emit(TodoOperationSuccess("Todo updated successfully"));
          add(LoadTodosEvent());
        },
    );
  }

  Future<void> _onToggleTodoStatus (
      ToggleTodoStatusEvent event,
      Emitter<TodoState> emit
      )async{

    if(state is TodosLoaded){
      final currentState = state as TodosLoaded;
      final updateTodos = currentState.todos.map((todo){
        if(todo.id == event.id){
          return todo.copyWith(isDone: !todo.isDone);
        }
        return todo;
      }).toList();

      emit(currentState.copyWith(todos: updateTodos));
    }

    final result = await toggleTodoStatus(IdParams(id: event.id));
    
    result.fold(
        (failure){
          add(LoadTodosEvent());
          emit(TodoError(failure.message));
        },
        (_){
          add(LoadTodosEvent());
        },
    );
  }

  Future<void> _onDeleteTodo(
      DeleteTodoEvent event,
      Emitter<TodoState> emit,
      ) async {
    final result = await deleteTodo(IdParams(id: event.id));

    await result.fold(
          (failure) async => emit(TodoError(failure.message)),
          (_) async {
        emit(TodoOperationSuccess('Todo deleted successfully'));
        add(LoadTodosEvent());
      },
    );
  }

  Future<void> _onFilterTodos(
      FilterTodosEvent event,
      Emitter<TodoState> emit,
      ) async {
    if (state is TodosLoaded) {
      final currentState = state as TodosLoaded;
      emit(currentState.copyWith(currentFilter: event.todoFilter));
    }
  }

}