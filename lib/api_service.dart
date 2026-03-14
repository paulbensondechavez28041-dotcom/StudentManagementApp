import 'dart:convert';
import 'package:http/http.dart' as http;
import 'student_model.dart';

class ApiService {

  static const String url = "http://10.0.2.2/api/addstudents.php";

  // GET STUDENTS
  static Future<List<Student>> getStudents() async {

    final response = await http.get(Uri.parse(url));

    final data = jsonDecode(response.body);

    List list = data["data"];

    return list.map((e) => Student.fromJson(e)).toList();
  }

  // ADD STUDENT
  static Future<void> addStudent(
      String name, String course, String year) async {

    await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "course": course,
        "yearLevel": year
      }),
    );
  }

  // UPDATE STUDENT
  static Future<void> updateStudent(
      int id, String name, String course, String year) async {

    await http.put(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "id": id,
        "name": name,
        "course": course,
        "yearLevel": year
      }),
    );
  }

  // DELETE STUDENT
  static Future<void> deleteStudent(int id) async {

    await http.delete(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"id": id}),
    );
  }
}