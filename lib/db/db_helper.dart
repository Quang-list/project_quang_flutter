import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/task_model.dart';

class DBHelper {
  // Phương thức khởi tạo và mở kết nối tới database
  static Future<Database> database() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'todo.db'), // Tên file database là todo.db
      onCreate: (db, version) {
        // Tạo bảng tasks khi database được khởi tạo
        return db.execute(
          'CREATE TABLE tasks(id TEXT PRIMARY KEY, title TEXT, description TEXT, deadline TEXT, isDone INTEGER)',
        );
      },
      version: 1, // Phiên bản của database
    );
  }

  // Phương thức thêm task mới vào database
  static Future<void> insertTask(Task task) async {
    final db = await DBHelper.database(); // Mở kết nối tới database
    await db.insert(
      'tasks', // Tên bảng
      task.toMap(), // Chuyển đổi Task thành map trước khi thêm vào database
      conflictAlgorithm: ConflictAlgorithm.replace, // Thay thế nếu có xung đột
    );
  }

  // Phương thức cập nhật thông tin task
  static Future<void> updateTask(Task task) async {
    final db = await DBHelper.database(); // Mở kết nối tới database
    await db.update(
      'tasks', // Tên bảng
      task.toMap(), // Chuyển đổi Task thành map
      where: 'id = ?', // Điều kiện WHERE để cập nhật task dựa trên ID
      whereArgs: [task.id], // Giá trị của điều kiện WHERE
    );
  }

  // Phương thức xóa task khỏi database
  static Future<void> deleteTask(String id) async {
    final db = await DBHelper.database(); // Mở kết nối tới database
    await db.delete(
      'tasks', // Tên bảng
      where: 'id = ?', // Điều kiện WHERE để xóa task dựa trên ID
      whereArgs: [id], // Giá trị của điều kiện WHERE
    );
  }

  // Phương thức lấy tất cả các task từ database
  static Future<List<Task>> getTasks() async {
    final db = await DBHelper.database(); // Mở kết nối tới database
    final List<Map<String, dynamic>> maps = await db.query('tasks'); // Truy vấn tất cả các task từ bảng

    // Chuyển đổi mỗi bản ghi trong bảng thành object Task
    return List.generate(maps.length, (i) {
      return Task(
        id: maps[i]['id'], // ID của task
        title: maps[i]['title'], // Tiêu đề của task
        description: maps[i]['description'], // Mô tả của task
        deadline: maps[i]['deadline'], // Hạn chót của task
        isDone: maps[i]['isDone'] == 1, // Chuyển đổi giá trị isDone (0/1) thành bool
      );
    });
  }
}
