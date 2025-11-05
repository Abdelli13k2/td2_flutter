class Todo {
  final int id;
  final String title;
  final bool completed;

  Todo({required this.id, required this.title, required this.completed});

  // Constructeur à partir du JSON renvoyé par l'API
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      completed: json['completed'] ?? false,
    );
  }

  // (Optionnel) Convertir en JSON si besoin plus tard
  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'completed': completed};
  }
}
