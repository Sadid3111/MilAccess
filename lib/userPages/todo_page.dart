import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/todo_item.dart';
import 'package:flutter_application_1/models/user_data.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({Key? key}) : super(key: key);

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  List<TodoItem> tasks = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    setState(() {
      isLoading = true;
    });
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('user')
          .doc(UserData.uid)
          .collection('todolist')
          .get();

      setState(() {
        tasks = querySnapshot.docs.map((doc) {
          return TodoItem.fromJson(doc.data());
        }).toList();
      });
    } catch (e) {
      // Handle errors (e.g., network issues, permission issues)
      print('Error fetching tasks: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to fetch tasks. Please try again later.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _saveTasks(TodoItem? task) async {
    try {
      final firestore = FirebaseFirestore.instance;
      await firestore
          .collection('user')
          .doc(UserData.uid)
          .collection(
            'todolist',
          ) // Replace 'qnotes' with your Firestore subcollection name
          .doc(task!.id) // Use the task's unique ID as the document ID
          .set(
            task.toJson(),
            SetOptions(merge: true),
          ); // Insert or update the document
    } catch (e) {
      print('Error saving task: $e');
    }
  }

  Future<void> _deleteTasks(String id) async {
    try {
      final firestore = FirebaseFirestore.instance;

      // Delete the task from Firestore
      await firestore
          .collection('user')
          .doc(UserData.uid)
          .collection('todolist')
          .doc(id)
          .delete();

      print('Task $id deleted successfully');
    } catch (e) {
      print('Error deleting task: $e');
    }
  }

  Future<bool?> _showTodoDialog({TodoItem? task}) {
    final isEditing = task != null;
    final titleController = TextEditingController(text: task?.title);
    DateTime? selectedDate = task?.dueDate;
    TimeOfDay? selectedTime = task?.time;
    String? selectedCategory = task?.category;
    String? selectedType = task?.type;

    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext ctx) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
                left: 20,
                right: 20,
                top: 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isEditing ? 'Edit Task' : 'Add Task',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Task Title',
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.calendar_today),
                            label: Text(
                              selectedDate == null
                                  ? 'Pick Due Date'
                                  : '${selectedDate!.toLocal()}'.split(' ')[0],
                            ),
                            onPressed: () async {
                              DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: selectedDate ?? DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2100),
                              );
                              setState(() => selectedDate = picked);
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.access_time),
                            label: Text(
                              selectedTime == null
                                  ? 'Pick Time'
                                  : selectedTime!.format(context),
                            ),
                            onPressed: () async {
                              TimeOfDay? picked = await showTimePicker(
                                context: context,
                                initialTime: selectedTime ?? TimeOfDay.now(),
                              );
                              if (picked != null) {
                                setState(() => selectedTime = picked);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: const InputDecoration(labelText: "Category"),
                      items: ['Training', 'Medical', 'Logistics', 'Admin']
                          .map(
                            (category) => DropdownMenuItem<String>(
                              value: category,
                              child: Text(category),
                            ),
                          )
                          .toList(),
                      onChanged: (value) =>
                          setState(() => selectedCategory = value),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: selectedType,
                      decoration: const InputDecoration(labelText: "Type"),
                      items: ['Urgent', 'Routine', 'Optional']
                          .map(
                            (type) => DropdownMenuItem<String>(
                              value: type,
                              child: Text(type),
                            ),
                          )
                          .toList(),
                      onChanged: (value) =>
                          setState(() => selectedType = value),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      child: Text(isEditing ? "Update Task" : "Save Task"),
                      onPressed: () async {
                        if (titleController.text.isEmpty ||
                            selectedDate == null ||
                            selectedTime == null ||
                            selectedCategory == null ||
                            selectedType == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please fill all fields."),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }
                        TodoItem todoItem;
                        if (isEditing) {
                          final index = tasks.indexWhere(
                            (element) => element.id == task.id,
                          );
                          if (index != -1) {
                            todoItem = TodoItem(
                              id: task.id,
                              title: titleController.text,
                              dueDate: selectedDate!,
                              time: selectedTime!,
                              category: selectedCategory!,
                              type: selectedType!,
                              isDone: task.isDone,
                            );
                            tasks[index] = todoItem;
                            await _saveTasks(todoItem);
                          }
                        } else {
                          todoItem = TodoItem(
                            id: DateTime.now().millisecondsSinceEpoch
                                .toString(),
                            isDone: false,
                            title: titleController.text,
                            dueDate: selectedDate!,
                            time: selectedTime!,
                            category: selectedCategory!,
                            type: selectedType!,
                          );
                          tasks.add(todoItem);
                          await _saveTasks(todoItem);
                        }

                        Navigator.of(
                          ctx,
                        ).pop(true); // return true to indicate change
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _deleteTask(String id) async {
    setState(() {
      tasks.removeWhere((task) => task.id == id);
    });
    await _deleteTasks(id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Task deleted."),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget _buildTaskCard(TodoItem item) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      elevation: 3,
      child: ListTile(
        leading: Checkbox(
          value: item.isDone,
          onChanged: (value) {
            setState(() => item.isDone = value!);
            _saveTasks(item);
          },
        ),
        title: Text(
          item.title,
          style: TextStyle(
            decoration: item.isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(
          'Due: ${item.dueDate.toLocal().toString().split(' ')[0]}, Time: ${item.time.format(context)}\nCategory: ${item.category} | Type: ${item.type}',
        ),
        isThreeLine: true,
        trailing: PopupMenuButton<String>(
          onSelected: (value) async {
            if (value == 'edit') {
              final result = await _showTodoDialog(
                task: item,
              ); // await for dialog to finish
              if (result == true) {
                setState(() {
                  // triggers rebuild of parent so UI updates with new tasks
                });
              }
            } else if (value == 'delete') {
              _deleteTask(item.id);
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(value: 'edit', child: Text('Edit')),
            const PopupMenuItem<String>(value: 'delete', child: Text('Delete')),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("To-Do List"), centerTitle: true),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : tasks.isEmpty
          ? const Center(child: Text("No tasks added yet."))
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (ctx, i) => _buildTaskCard(tasks[i]),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await _showTodoDialog(); // await for dialog to finish
          if (result == true) {
            setState(() {
              // triggers rebuild of parent so UI updates with new tasks
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
