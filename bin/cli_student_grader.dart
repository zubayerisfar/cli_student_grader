import 'dart:io';

void main() {
  List<Map<String, dynamic>> studentList = [];
  String? userInput;
  do {
    String menu = """

===== Student Grader v1.0 =====

1. Add Student
2. Record Score
3. Add Bonus Points
4. Add Comment
5. View All Students
6. View Report Card
7. Class Summary
8. Exit

Choose an option: """;

    print(menu);
    userInput = stdin.readLineSync();

    switch (userInput) {
      // ====================== Add Student ======================
      case '1':
        print("Enter student name:");
        String? name = stdin.readLineSync();
        while (name == null || name.isEmpty) {
          print("Name cannot be empty. Please enter a valid name:");
          name = stdin.readLineSync();
        }
        final Set<String> availableSubjects = {'Math', 'English', 'Science'};
        final Map<String, dynamic> student = {
          'name': name.trim(),
          'scores': <double>[],
          'subjects': {...availableSubjects},
          'bonus': null,
          'comment': null,
        };
        studentList.add(student);
        print("Student '$name' added successfully.");
        break;

      case '8':
        print("Exiting Student Grader. Goodbye!");
        break;
  
      default:
        print("Invalid option. Please choose a number between 1 and 8.");
    }
  } while (userInput != '8');
}
