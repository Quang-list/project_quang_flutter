import 'package:flutter/material.dart';

import '../db/db_helper.dart';
import '../models/task_model.dart';
import '../widgets/task_tile.dart';
import 'task_form_screen.dart';


class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Task> _tasks = [];
  List<Task> _overdueTasks = [];
  List<Task> _upcomingTasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  void _loadTasks() async {
    final tasks = await DBHelper.getTasks();
    final now = DateTime.now();
    setState(() {
      _tasks = tasks;
      _overdueTasks = tasks.where((task) => DateTime.parse(task.deadline).isBefore(now) && !task.isDone).toList();
      _upcomingTasks = tasks.where((task) => DateTime.parse(task.deadline).isAfter(now) || task.isDone).toList();
    });
  }

  void _toggleDone(Task task) {
    task.isDone = !task.isDone;
    DBHelper.updateTask(task);
    _loadTasks();
  }

  void _deleteTask(Task task) {
    DBHelper.deleteTask(task.id);
    _loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý công việc'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadTasks,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8.0),
              children: [
                Text('Công việc còn hạn:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ..._upcomingTasks.map((task) => Dismissible(
                  key: Key(task.id),
                  onDismissed: (direction) {
                    _deleteTask(task);
                  },
                  child: TaskTile(task: task, toggleDone: _toggleDone),
                )),
                SizedBox(height: 16),
                Text('Công việc đã hết hạn:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ..._overdueTasks.map((task) => Dismissible(
                  key: Key(task.id),
                  onDismissed: (direction) {
                    _deleteTask(task);
                  },
                  child: TaskTile(task: task, toggleDone: _toggleDone),
                )),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TaskFormScreen()),
          ).then((_) => _loadTasks());
        },
        child: Icon(Icons.add),
        tooltip: 'Thêm công việc mới',
      ),
    );
  }
}
