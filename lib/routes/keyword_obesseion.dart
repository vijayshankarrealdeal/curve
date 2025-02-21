import 'dart:math';
import 'package:curve/services/settings_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class KeywordObesseion extends StatelessWidget {
  const KeywordObesseion({super.key});

  Future<void> _showTasksDialog(
      BuildContext context, String category, categoryTasks) async {
    // We'll manage tasks and current task inside setState of a StatefulBuilder in the dialog
    List<String> tasks = List.of(categoryTasks[category]!);
    String? currentTask = _pickRandomTask(tasks);

    await showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(category),
              content: currentTask == null
                  ? const Text("No more tasks available!")
                  : AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Card(
                        key: ValueKey(currentTask),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.all(8),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            currentTask!,
                            style: const TextStyle(fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text("Close"),
                ),
                if (currentTask != null)
                  ElevatedButton(
                    onPressed: () {
                      // Pick next task
                      setState(() {
                        currentTask = _pickRandomTask(tasks);
                      });
                    },
                    child: const Text("Next Task"),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  static String? _pickRandomTask(List<String> tasks) {
    if (tasks.isEmpty) return null;
    final randomIndex = Random().nextInt(tasks.length);
    final chosenTask = tasks[randomIndex];
    tasks.removeAt(randomIndex); // remove chosen to avoid repetition
    return chosenTask;
  }

  @override
  Widget build(BuildContext context) {
    // Display categories as Chips inside a Wrap
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keyword Obsession'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<SettingsModel>(builder: (context, settingModels, _) {
          return Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                settingModels.categories.where((e) => e.isSelected).map((cat) {
              return ActionChip(
                label: Text(cat.name),
                onPressed: () => _showTasksDialog(
                    context, cat.name, settingModels.generateCategoryTasks()),
              );
            }).toList(),
          );
        }),
      ),
    );
  }
}
