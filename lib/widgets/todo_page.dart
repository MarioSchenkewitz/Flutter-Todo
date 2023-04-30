import 'package:flutter/material.dart';
import 'package:flutter_vorlesung/repository/todo_model.dart';
import 'package:flutter_vorlesung/repository/todo_repository.dart';


class TodoPage extends StatelessWidget{
  final TodoRepository todoRepository = TodoRepository();
  TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: todoRepository.getTodos(), builder: (context, snapshot){
      if(!snapshot.hasData){
        return const Center(child: CircularProgressIndicator());
      }
    //return const SizedBox.shrink();
    return SingleChildScrollView(
              child: Column(
                children: snapshot.data?.todos.map((e) => _TodoElement(e)).toList() ?? [],
              ),
            );
    });
    
  }

}

class _TodoElement extends StatelessWidget {
  final Todo todo;

  const _TodoElement(this.todo);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: ListTile(
          title: Text(todo.title),
          leading: Icon(todo.done ? Icons.check : Icons.question_mark),
        ),
      ),
    );
  }
}
