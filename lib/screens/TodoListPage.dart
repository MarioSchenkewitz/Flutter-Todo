import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_vorlesung/screens/TodoAddPage.dart';
import 'package:http/http.dart' as http;

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  bool isLoading = true;
  List items = [];
  @override
  void initState() {
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Taskbuddy'),
      ),
      body: Visibility(
        visible: isLoading,
        child: Center(child: CircularProgressIndicator()),
        replacement: RefreshIndicator(
          onRefresh: fetchTodo,
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index] as Map;
              return ListTile(
                leading: CircleAvatar(child: Text('${index + 1}')),
                title: Text(item['todo']),
                trailing: PopupMenuButton(
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        child: Text('Bearbeiten'),
                        value: 'edit',
                      ),
                      PopupMenuItem(
                        child: Text('Loeschen'),
                        value: 'delete',
                      ),
                    ];
                  },
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToAddPage,
        label: Text('Add To-Do'),
      ),
    );
  }

  void navigateToAddPage() {
    final route = MaterialPageRoute(
      builder: (context) => AddTodoPage(),
    );
    Navigator.push(context, route);
  }

  Future<void> deleteById(String id) async {
    //Delete item
    final url = 'https://dummyjson.com/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);

    if (response.body == 200) {
      //refresh list
      showSuccessMessage('Löschen Erfolgreich');
      fetchTodo();
    } else {
      //error
      showErrorMessage('Löschen fehlgeschlagen');
    }
  }

  Future<void> fetchTodo() async {
    final response = await http.get(Uri.https('dummyjson.com', 'todos'));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['todos'] as List;
      setState(() {
        items = result;
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  void showSuccessMessage(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showErrorMessage(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
