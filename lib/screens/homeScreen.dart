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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchTasks();
    });
  }

  void fetchTasks() async {
    var data = await TodoService().getTodos();
    setState(() {
      tasks = data;
      filteredTasks = data;
      isLoading = false;
    });
  }

  void showAddTaskForm() {
    List<String> subtasks = [];
    TextEditingController subtaskController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [Text("Add Task", style: TextStyle(fontSize: 20)),
                    SizedBox(height: 15),
                    TextField(
                      controller: taskController,
                      decoration: InputDecoration(
                        labelText: "Task Title",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: subtaskController,
                            decoration: InputDecoration(
                              labelText: "Subtask",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            if (subtaskController.text.isNotEmpty) {
                              setModalState(() {
                                subtasks.add(subtaskController.text);
                              });
                              subtaskController.clear();
                            }
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Column(
                      children: subtasks.map((s) {
                        return ListTile(
                          title: Text(s),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setModalState(() {
                                subtasks.remove(s);
                              });
                            },
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(style: ElevatedButton.styleFrom(
                       minimumSize: Size(double.infinity, 50),
                    ),
                      onPressed: () async {
                     if(taskController.text.isEmpty) return;
                     await TodoService().addTodo(
                     taskController.text,
                     subtasks: subtasks,
                    );
                    taskController.clear();
                    Navigator.pop(context);
                     fetchTasks();
                    },
                    child: Text("Add Task"),
                   ),
                  ],
                ),
              ),
            );
          },
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
              ),
            ],
          ),
        );
      },
    );
  }

  void searchTasks(String query) {
    setState(() {
      filteredTasks = tasks.where((task) {
        return task['title'].toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  Widget taskItem(var task, int index) {
  List subtasks = task['subtasks'] ?? [];
  int total = subtasks.length;
  int completed = subtasks.where((t) => t['isCompleted'] == true).length;
  int remaining = total - completed;

  double progress = total== 0 ? 0 :completed / total;
  bool allDone = total> 0 && completed == total;

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(horizontal: 12),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                task['title'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: allDone ? Colors.green : Colors.black,
                ),
              ),
            ),

            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.edit, size: 20),
                  onPressed: () => showEditTaskForm(index),
                ),
                IconButton(
                  icon: Icon(Icons.delete, size: 20, color: Colors.red),
                  onPressed: () async {
                    await TodoService().deleteTodo(task['_id']);
                    fetchTasks();
                  },
                ),
              ],
            ),
          ],
        ),

        children: [
          ...subtasks.map<Widget>((subtask) {
            return CheckboxListTile(
              title: Text(
                subtask['title'],
                style: TextStyle(
                  decoration: subtask['isCompleted']
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                  color: subtask['isCompleted']
                      ? Colors.grey
                      : Colors.black,
                ),
              ),
              value: subtask['isCompleted'],
              onChanged: (value) async {
                await TodoService().toggleSubtask(
                  task['_id'],
                  subtask['_id'],
                );
                fetchTasks();
              },
            );
          }).toList(),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Add subtask...",
                suffixIcon: Icon(Icons.add),
              ),
              onSubmitted: (value) async {
                if (value.isEmpty) return;
                await TodoService().addSubtask(task['_id'], value);
                fetchTasks();
              },
            ),
          ),

          SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LinearProgressIndicator(
                  value: progress,
                  minHeight: 6,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    progress == 1 ? Colors.green : Colors.blue,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "$completed completed • $remaining remaining",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
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
                          await TodoService().deleteTodo(task['_id']);
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text("Deleted")));
                          fetchTasks();
                        },
                        background: Container(color: Colors.red),
                        child: taskItem(task,index),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
