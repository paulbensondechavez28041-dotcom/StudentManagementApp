class Student {
  final int id;
  final String name;
  final String course;
  final String yearLevel;

  Student({
    required this.id,
    required this.name,
    required this.course,
    required this.yearLevel,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: int.parse(json['id'].toString()),
      name: json['name'],
      course: json['course'],
      yearLevel: json['yearLevel'],
    );
  }
}