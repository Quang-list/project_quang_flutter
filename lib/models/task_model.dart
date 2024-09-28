class Task {
  String id;
  String title;
  String description;
  String deadline;
  bool isDone;

  Task({
    required this.id,  // Cập nhật id trong constructor
    required this.title,
    required this.description,
    required this.deadline,
    this.isDone = false,
  });

  // Tạo một hàm để convert object Task thành Map cho database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'deadline': deadline,
      'isDone': isDone ? 1 : 0,
    };
  }
}
