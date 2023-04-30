import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io' show Platform;

class AddTodoPage extends StatefulWidget {
  final Map? todo;
  const AddTodoPage({
    super.key,
    this.todo,
  });

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;
  bool done = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo['todo'];
      final description = todo['description'];
      titleController.text = title;
      descriptionController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Todo' : 'Neues Todo'),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: Textfield,
      ),
    );
  }

  List<Widget> get Textfield {
    return [
      TextField(
        controller: titleController,
        decoration: const InputDecoration(hintText: 'Todo'),
      ),
      const SizedBox(height: 20),
      TextField(
        controller: descriptionController,
        decoration: const InputDecoration(hintText: 'Beschreibung'),
        keyboardType: TextInputType.multiline,
        minLines: 5,
        maxLines: 8,
      ),
      Checkbox(
          value: done,
          onChanged: (bool? value) {
            setState(() {
              done = value!;
            });
          }),
      const SizedBox(height: 20),
      ElevatedButton(
        onPressed: isEdit ? updateData : submitData,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(isEdit ? 'Ändern' : 'Abschicken'),
        ),
      )
    ];
  }

  Future<void> updateData() async {
    //Get data from form
    final todo = widget.todo;
    if (todo == null) {
      print('cant call update without todo data');
      return;
    }
    final id = todo['id'];
    //final isCompleted = todo['completed'];
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "todo": title,
      "completed": done,
      "userId": 5,
    };

    //Submit update to server
    final url = 'https://dummyjson.com/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.put(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );

    //show success or failure
    if (response.statusCode == 200) {
      showSuccessMessage('Bearbeitung Erfolgreich');
    } else {
      showErrorMessage('Bearbeitung Fehler');
    }
  }

  Future<void> submitData() async {
    //Get data from form
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "todo": title,
      "completed": false,
      "userId": 5,
    };

    //Submit data to server
    final url = 'https://dummyjson.com/todos/add';
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );

    //show success or failure
    if (response.statusCode == 200) {
      titleController.text = '';
      descriptionController.text = '';
      showSuccessMessage('Erfolg');
    } else {
      print('Failed');
      showErrorMessage('Fehler');
    }
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

  //Get Id from device_info_plus
  Future<String?> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.id; // unique ID on Android
    }
    return null;
  }
}
