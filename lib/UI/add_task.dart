import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../viewmodel/task_view_model.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajout d\'une tache')),
      body: Center(
        child: FormBuilder(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FormBuilderTextField(
                name: 'title',
                decoration: const InputDecoration(
                  labelText: 'Titre de la tâche',
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
              ),
              FormBuilderTextField(
                name: 'description',
                decoration: const InputDecoration(
                  labelText: 'Description de la tâche',
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
              ),
              FormBuilderTextField(
                name: 'tags',
                decoration: const InputDecoration(
                  labelText: 'Tags associés de la tâche',
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
              ),
              FormBuilderTextField(
                name: 'difficulty',
                decoration: const InputDecoration(
                  labelText: 'Difficulté de la tâche',
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.integer(),
                ]),
              ),
              FormBuilderTextField(
                name: 'nbhours',
                decoration: const InputDecoration(
                  labelText: 'Nombre d\'heures de la tâche',
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.integer(),
                ]),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.lightBlue,
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    context.read<TaskViewModel>().insertTask(
                      Task.createTask(
                        _formKey.currentState?.fields['title']?.value,
                        _formKey.currentState?.fields['tags']?.value,
                        int.parse(
                          _formKey.currentState?.fields['nbhours']?.value,
                        ),
                        int.parse(
                          _formKey.currentState?.fields['difficulty']?.value,
                        ),
                        _formKey.currentState?.fields['description']?.value,
                      ),
                    );
                    Navigator.pop(
                      context,
                    ); // Retour à la vue précédente dans l'app
                  }
                },
                child: const Text("Ajouter"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
