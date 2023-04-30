import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vorlesung/blocs/bloc/counter_bloc.dart';
import 'package:flutter_vorlesung/repository/todo_repository.dart';
import 'package:flutter_vorlesung/widgets/hit_counter.dart';
import 'package:flutter_vorlesung/widgets/todo_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? appTitle;
  int _selectedIndex = 0;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void _setAppTitle(String newAppTitle) {
    setState(() {
      appTitle = newAppTitle;
    });
  }

  @override
  void initState() {
    _widgetOptions = <Widget>[
      _HomeContent(
        onNameChange: (name) => _setAppTitle(name),
      ),
      TodoPage(),
      const Text(
        'Index 2: School',
        style: optionStyle,
      ),
    ];
    super.initState();
  }

  late List<Widget> _widgetOptions;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(appTitle ?? "Standard Title"),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Business',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'School',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  final Function(String) onNameChange;

  const _HomeContent({super.key, required this.onNameChange});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CounterBloc(),
      child: Center(
        child: BlocBuilder<CounterBloc, CounterState>(
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                HitCounter(counter: state.counter),
                const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                ElevatedButton(
                    onPressed: () => BlocProvider.of<CounterBloc>(context)
                        .add(CounterIncrease()),
                    child: const Text('Increment')),
                const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                ElevatedButton(
                    onPressed: () => BlocProvider.of<CounterBloc>(context)
                        .add(CounterDecrease()),
                    child: const Text('Decrease')),
                TextField(
                  decoration: const InputDecoration(labelText: "App Title"),
                  onChanged: (value) {
                    onNameChange(value);
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
