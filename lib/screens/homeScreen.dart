import 'package:flutter/material.dart';
import '../services/todo_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> tasks = [];
  List<dynamic> filteredTasks = [];
  bool isLoading = true;

  TextEditingController taskController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  void fetchTasks() async {
    var data = await TodoService().getTodos();

    setState(() {
      tasks = data;
      filteredTasks = data;
      isLoading = false;
    });
  }

  // ✅ ADD TASK
  void showAddTaskForm() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Add Task", style: TextStyle(fontSize: 20)),
              SizedBox(height: 20),
              TextField(controller: taskController),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (taskController.text.isEmpty) return;

                  await TodoService().addTodo(taskController.text);

                  taskController.clear();
                  Navigator.pop(context);
                  fetchTasks();
                },
                child: Text("Add"),
              ),
            ],
          ),
        );
      },
    );
  }


  void showEditTaskForm(int index) {
  taskController.text = filteredTasks[index]['title'];
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Edit task", style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            TextField(controller: taskController),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await TodoService().updateTodo(
                  filteredTasks[index]['_id'],
                  taskController.text,
                );
                taskController.clear();
                Navigator.pop(context);
                fetchTasks();
              },
              child: Text("Update task"),
            )
          ],
        ),
      );
    },
  );
}

  void searchTasks(String query) {
    setState(() {
      filteredTasks = tasks.where((task) {
        return task['title']
            .toLowerCase()
            .contains(query.toLowerCase());
      }).toList();
    });
  }


  Widget taskItem(var task) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 30),
    child: Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.purple.shade50,
          ),
          child: Icon(Icons.task, color: Colors.purple),
        ),
        SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task['title'],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  decoration: task['completed'] == 1
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),
              Text(
                "completed ${task['completed']}",
                style: TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.purple.shade50,
          ),
          child: Text(
            "${task['total']}",
            style: TextStyle(fontSize: 11, color: Colors.purple),
          ),
        ),
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: showAddTaskForm,
        child: Icon(Icons.add),
      ),
      appBar: AppBar(title: Text("Todo App")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: searchController,
                    onChanged: searchTasks,
                    decoration: InputDecoration(
                      hintText: "Search...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      var task = filteredTasks[index];

                      return Dismissible(
                        key: Key(task['_id']),
                        onDismissed: (direction) async {
                          await TodoService()
                              .deleteTodo(task['_id']);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Deleted")),
                          );

                          fetchTasks();
                        },
                        background: Container(color: Colors.red),
                        child: GestureDetector(
                          onTap: () => showEditTaskForm(index),
                          child: taskItem(task),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}