import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import '../models/task.dart';

class TaskViewModel extends ChangeNotifier {
  late List<Task> liste;
  final Database database;

  TaskViewModel(this.database) {
    liste = [];
    // Attendre que le widget tree soit construit avant de charger les tâches
    WidgetsBinding.instance.addPostFrameCallback((_) {
      refreshTasks();
    });
  }

  // Récupérer toutes les taches de la table correspondante.
  Future<List<Task>> tasks() async {
    // Query the table for all the tasks.
    final List<Map<String, Object?>> taskMaps = await database.query('task');

    // Convertit le Map (dictionnaire) en liste de taches
    // en utilisant une compréhension
    return [
      for (final {
            'id': id as int,
            'title': title as String,
            'description': description as String,
            'tags': tags as String,
            'nbhours': nbhours as int,
            'difficulty': difficulty as int,
            'color': color as String,
          }
          in taskMaps)
        Task(
          id: id,
          title: title,
          description: description,
          tags: tags,
          nbhours: nbhours,
          difficulty: difficulty,
          color: color,
        ),
    ];
  }

  Future<void> refreshTasks() async {
    liste = [];
    List<Task> tasksInBD = await tasks();
    // Parcourir la liste de tâches
    for (Task task in tasksInBD) {
      debugPrint(task.toString());
      liste.add(task);
    }
    notifyListeners();
  }
}
