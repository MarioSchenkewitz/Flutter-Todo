import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io' show Platform;

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController completedController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Neues Todo'),
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
        controller: completedController,
        decoration: const InputDecoration(hintText: 'Beschreibung'),
        keyboardType: TextInputType.multiline,
        minLines: 5,
        maxLines: 8,
      ),
      const SizedBox(height: 20),
      ElevatedButton(
        onPressed: submitData,
        child: const Text('Abschicken'),
      )
    ];
  }

  void submitData() async {
    //Get data from form
    final title = titleController.text;
    final description = completedController.text;
    final body = {
      "todo": title,
      "completed": false,
      "userId": _getId(),
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
    if (response.statusCode == 201) {
      print('Success');
      showSuccessMessage('Erfolg');
    } else {
      print('Failed');
      showSuccessMessage('Fehler');
    }
  }

  void showSuccessMessage(String message) {
    final snackBar = SnackBar(content: Text(message));
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
