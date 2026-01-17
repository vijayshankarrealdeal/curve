import 'dart:math';
import 'package:curve/services/settings_model.dart';
import 'package:curve/services/language_provider.dart'; // Import
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class KeywordObesseion extends StatelessWidget {
  const KeywordObesseion({super.key});

  Future<void> _showTasksDialog(BuildContext context, String category,
      categoryTasks, LanguageProvider lang) async {
    List<String> tasks = List.of(categoryTasks[category]!);
    String? currentTask = _pickRandomTask(tasks);

    await showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(lang.getText(category)), // Translate title
              content: currentTask == null
                  ? Text(lang.getText('no_more_tasks'))
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
                  child: Text(lang.getText('close')),
                ),
                if (currentTask != null)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        currentTask = _pickRandomTask(tasks);
                      });
                    },
                    child: Text(lang.getText('next_task')),
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
    tasks.removeAt(randomIndex);
    return chosenTask;
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(lang.getText('keyword')),
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
                label: Text(lang.getText(cat.name)), // Translate category name
                onPressed: () => _showTasksDialog(context, cat.name,
                    settingModels.generateCategoryTasks(), lang),
              );
            }).toList(),
          );
        }),
      ),
    );
  }
}
