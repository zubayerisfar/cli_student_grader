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

  } while (userInput != '8');
}
