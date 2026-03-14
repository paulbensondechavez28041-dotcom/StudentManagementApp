import 'package:flutter/material.dart';
import 'api_service.dart';
import 'student_model.dart';
import 'student_form.dart';

class StudentList extends StatefulWidget {
  const StudentList({super.key});

  @override
  State<StudentList> createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {

  List<Student> students = [];
  bool loading = true;

  loadStudents() async {

    students = await ApiService.getStudents();

    setState(() {
      loading = false;
    });
  }

  deleteStudent(int id) async {

    await ApiService.deleteStudent(id);

    loadStudents();
  }

  @override
  void initState() {
    super.initState();
    loadStudents();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Student Records")),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {

                final student = students[index];

                return ListTile(
                  title: Text(student.name),
                  subtitle: Text(
                      "${student.course} - ${student.yearLevel}"),

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {

                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => StudentForm(
                                student: student,
                              ),
                            ),
                          );

                          if (result == true) loadStudents();
                        },
                      ),

                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          deleteStudent(student.id);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {

          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const StudentForm(),
            ),
          );

          if (result == true) loadStudents();
        },
      ),
    );
  }
}