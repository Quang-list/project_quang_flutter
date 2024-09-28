import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart'; // Thư viện để tạo ID duy nhất
import '../db/db_helper.dart';
import '../models/task_model.dart';

class TaskFormScreen extends StatefulWidget {
  final Task? task;

  TaskFormScreen({this.task});

  @override
  _TaskFormScreenState createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _deadline = DateTime.now(); // Mặc định deadline là ngày hiện tại

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
      _deadline = DateTime.parse(widget.task!.deadline);
    }
  }

  Future<void> _saveTask() async {
    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng nhập đầy đủ thông tin!')),
      );
      return;
    }

    if (widget.task == null) {
      // Tạo ID mới cho task mới
      String taskId = Uuid().v4(); // Sinh ID ngẫu nhiên bằng thư viện UUID
      await DBHelper.insertTask(Task(
        id: taskId,
        title: _titleController.text,
        description: _descriptionController.text,
        deadline: _deadline.toIso8601String(),
      ));
    } else {
      widget.task!.title = _titleController.text;
      widget.task!.description = _descriptionController.text;
      widget.task!.deadline = _deadline.toIso8601String();
      await DBHelper.updateTask(widget.task!);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Thêm công việc' : 'Chỉnh sửa công việc'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveTask,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Tiêu đề',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Mô tả',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ListTile(
              title: Text('Hạn chót: ${_deadline.toLocal()}'.split(' ')[0]),
              trailing: Icon(Icons.calendar_today),
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: _deadline,
                  firstDate: DateTime.now(),  // Ngày bắt đầu chọn
                  lastDate: DateTime(2101),// Ngày kết thúc chọn
                );
                if (picked != null && picked != _deadline) {
                  setState(() {
                    _deadline = picked; // Cập nhật deadline
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
