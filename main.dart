import 'package:flutter/material.dart';

void main() {
  runApp(const StudentApp());
}

class StudentApp extends StatelessWidget {
  const StudentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const StudentPage(),
    );
  }
}

// ---------------- STUDENT MODEL ----------------
class Student {
  final int id;
  String name;
  String course;
  String yearLevel;

  Student({
    required this.id,
    required this.name,
    required this.course,
    required this.yearLevel,
  });
}

// ---------------- MAIN PAGE ----------------
class StudentPage extends StatefulWidget {
  const StudentPage({super.key});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  final List<Student> _students = [];
  int _nextId = 1;

  final TextEditingController _nameCtrl = TextEditingController();

  String? _selectedCourse;
  String? _selectedYear;

  final List<String> _courses = [
    'BSIT',
    'BSCS',
    'BSIS',
    'BSECE',
    'BSBA',
  ];

  final List<String> _yearLevels = [
    '1st Year',
    '2nd Year',
    '3rd Year',
    '4th Year',
  ];

  void _openForm({Student? student}) {
    if (student != null) {
      _nameCtrl.text = student.name;
      _selectedCourse = student.course;
      _selectedYear = student.yearLevel;
    } else {
      _nameCtrl.clear();
      _selectedCourse = null;
      _selectedYear = null;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            16,
            16,
            16,
            MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                student == null ? 'Add Student' : 'Edit Student',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // NAME
              TextField(
                controller: _nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Student Name',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 12),

              // COURSE
              DropdownButtonFormField<String>(
                value: _selectedCourse,
                decoration: const InputDecoration(
                  labelText: 'Course',
                  prefixIcon: Icon(Icons.school),
                ),
                items: _courses
                    .map((course) => DropdownMenuItem(
                          value: course,
                          child: Text(course),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _selectedCourse = value),
              ),
              const SizedBox(height: 12),

              // YEAR LEVEL
              DropdownButtonFormField<String>(
                value: _selectedYear,
                decoration: const InputDecoration(
                  labelText: 'Year Level',
                  prefixIcon: Icon(Icons.grade),
                ),
                items: _yearLevels
                    .map((year) => DropdownMenuItem(
                          value: year,
                          child: Text(year),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _selectedYear = value),
              ),
              const SizedBox(height: 20),

              // SAVE BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: Text(student == null ? 'Save Student' : 'Update Student'),
                  onPressed: () {
                    if (_nameCtrl.text.isEmpty ||
                        _selectedCourse == null ||
                        _selectedYear == null) return;

                    setState(() {
                      if (student == null) {
                        _students.add(
                          Student(
                            id: _nextId++,
                            name: _nameCtrl.text,
                            course: _selectedCourse!,
                            yearLevel: _selectedYear!,
                          ),
                        );
                      } else {
                        student.name = _nameCtrl.text;
                        student.course = _selectedCourse!;
                        student.yearLevel = _selectedYear!;
                      }
                    });

                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _deleteStudent(int index) {
    setState(() {
      _students.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Management'),
      ),
      body: _students.isEmpty
          ? const Center(child: Text('No student records yet'))
          : ListView.builder(
              itemCount: _students.length,
              itemBuilder: (_, index) {
                final student = _students[index];
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.indigo.shade100,
                      child: Text(student.id.toString()),
                    ),
                    title: Text(student.name),
                    subtitle: Text(
                      '${student.course} • ${student.yearLevel}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _openForm(student: student),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteStudent(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(),
        icon: const Icon(Icons.add),
        label: const Text('Add Student'),
      ),
    );
  }
}
