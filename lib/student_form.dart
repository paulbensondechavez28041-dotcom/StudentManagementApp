import 'package:flutter/material.dart';
import 'api_service.dart';
import 'student_model.dart';

class StudentForm extends StatefulWidget {

  final Student? student;

  const StudentForm({super.key, this.student});

  @override
  State<StudentForm> createState() => _StudentFormState();
}

class _StudentFormState extends State<StudentForm> {

  final nameController = TextEditingController();
  final courseController = TextEditingController();
  final yearController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.student != null) {
      nameController.text = widget.student!.name;
      courseController.text = widget.student!.course;
      yearController.text = widget.student!.yearLevel;
    }
  }

  saveStudent() async {

    if (widget.student == null) {

      await ApiService.addStudent(
        nameController.text,
        courseController.text,
        yearController.text,
      );

    } else {

      await ApiService.updateStudent(
        widget.student!.id,
        nameController.text,
        courseController.text,
        yearController.text,
      );
    }

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.student == null
            ? "Add Student"
            : "Edit Student"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),

            TextField(
              controller: courseController,
              decoration: const InputDecoration(labelText: "Course"),
            ),

            TextField(
              controller: yearController,
              decoration: const InputDecoration(labelText: "Year Level"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: saveStudent,
              child: const Text("Save"),
            )
          ],
        ),
      ),
    );
  }
}