import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/todo.dart';

class Ecran3 extends StatefulWidget {
  const Ecran3({super.key});

  @override
  _Ecran3State createState() => _Ecran3State();
}

class _Ecran3State extends State<Ecran3> {
  late Future<List<Todo>> _todosFuture;

  @override
  void initState() {
    super.initState();
    _todosFuture = fetchTodos();
  }

  Future<List<Todo>> fetchTodos() async {
    final response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/todos'),
      headers: {"Accept": "application/json"},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => Todo.fromJson(e)).toList();
    } else {
      throw Exception("Erreur serveur: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Todo>>(
      future: _todosFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erreur: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Aucune donnée trouvée'));
        }

        final todos = snapshot.data!;
        return ListView.builder(
          itemCount: todos.length,
          itemBuilder: (context, index) {
            final todo = todos[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: todo.completed ? Colors.green : Colors.red,
                  child: Text(todo.id.toString()),
                ),
                title: Text(todo.title),
                subtitle: Text(todo.completed ? "Complété" : "Non complété"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TodoDetail(todo: todo),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

class TodoDetail extends StatelessWidget {
  final Todo todo;

  const TodoDetail({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Détail du Todo ${todo.id}")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Titre : ${todo.title}",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            Text("Complété : ${todo.completed ? "Oui" : "Non"}"),
          ],
        ),
      ),
    );
  }
}
