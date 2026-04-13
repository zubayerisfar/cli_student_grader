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

      // ====================== Student Record Add ======================
      case '2': // record score
        if (studentList.isEmpty) {
          print("No students available. Please add a student first.");
          break;
        }
        print("Pick a student to record score:");
        for (int i = 0; i < studentList.length; i++) {
          print("${i + 1}. ${studentList[i]['name']}");
        }

        String? choice = stdin.readLineSync();
        int? index = int.tryParse(choice ?? '');
        if (index == null || index < 1 || index > studentList.length) {
          print("Invalid index. Please select a valid student number.");
          break;
        }

        Map<String, dynamic> student = studentList[index - 1];
        print("Available subjects for ${student['name']}:");
        Set<String> subjects = student['subjects'];
        for (String subject in subjects) {
          print("- $subject");
        }

        print("Enter score (0-100):");
        String? input = stdin.readLineSync();
        double? score = double.tryParse(input ?? '');
        while (score == null || score < 0 || score > 100) {
          print("Invalid score. Enter a number between 0 and 100:");
          input = stdin.readLineSync();
          score = double.tryParse(input ?? '');
        }
        student['scores'].add(score);
        print("Score $score added for ${student['name']}.");
        break;
      
      // ======================== Bonus Points Add ==========================
      case '3':
        print("Enter name of the student and bonus point (1-10):");
        print("Enter input like: Rakib,10");
        String? line = stdin.readLineSync();

        if (line != null) {
          List<String> parts = line.split(',');

          if (parts.length == 2) {
            String name = parts[0].trim();
            int? bonus = int.tryParse(parts[1].trim());
            if (bonus == null || bonus < 1 || bonus > 10) {
              print("Invalid bonus value. Enter a number between 1 and 10.");
              break;
            }
            int bonusValue = bonus;
            int input = studentList.indexWhere(
              (student) =>
                  student['name'].toString().toLowerCase() ==
                  name.toLowerCase(),
            );
            if (input != -1) {
              // -1 mean end of loop and no match found
                if (studentList[input]['bonus'] == null) {
                  studentList[input]["bonus"] ??= bonusValue;
                  print("Bonus points added for ${studentList[input]['name']}.");
                } else {
                  print("Bonus already set for ${studentList[input]['name']}.");
                }
            } else {
              print("Student not found.");
            }
          }
        }
        break;

      // ======================== Comment Add ==========================      
      case '4':
        print("Enter name of the student and comment:");
        print("Enter input like: Rakib,Excellent work!");
        String? line = stdin.readLineSync();

        if (line != null) {
          List<String> parts = line.split(',');

          if (parts.length == 2) {
            String name = parts[0].trim();
            String comment = parts[1].trim();

            int input = studentList.indexWhere(
              (student) =>
                  student['name'].toString().toLowerCase() ==
                  name.toLowerCase(),
            );
            if (input != -1) {
              // -1 mean end of loop and no match found
                if (studentList[input]['comment'] == null) {
                  studentList[input]["comment"] ??= comment;
                  print("Comment added for ${studentList[input]['name']}.");
                } else {
                  print("Comment already set for ${studentList[input]['name']}.");
                }
            } else {
              print("Student not found.");
            }
          }
        }
        break;       

      // ======================== All Students Print ==========================      
      case '5':
        if (studentList.isEmpty) {
          print("No students available.");
        }
        else{
          print("STUDENT LIST:");
          for (var student in studentList) {
            var tags = [
              student["name"],
              "${student["scores"].length} scores",
              if (student["bonus"] != null) "⭐ Has Bonus",
            ];
            print(tags.join(" | "));
          }
        }
        break;
      
      // ======================== View Report Card ==========================      
      case '6':
        if (studentList.isEmpty) {
          print("No students available. Please add a student first.");
          break;
        }

        print("Pick a student to view report card:");
        for (int i = 0; i < studentList.length; i++) {
          print("${i + 1}. ${studentList[i]['name']}");
        }

        String? choice = stdin.readLineSync();
        int? index = int.tryParse(choice ?? '');
        while (index == null || index < 1 || index > studentList.length) {
          print("Invalid index. Please select a valid student number.");
          choice = stdin.readLineSync();
          index = int.tryParse(choice ?? '');
        }

        Map<String, dynamic> student = studentList[index - 1];
        List<double> scores = List<double>.from(student['scores']);

        double total = 0;
        if (scores.isNotEmpty) {
          for (double score in scores) {
            total += score;
          }
        }
        double currAvg = scores.isEmpty ? 0 : total / scores.length;
        int bonus = student['bonus'] ?? 0;
        double finalAvg = currAvg + bonus;
        if (finalAvg > 100) {
          finalAvg = 100;
        }
        String grade;
        if (finalAvg >= 90) {
          grade = 'A';
        } else if (finalAvg >= 80) {
          grade = 'B';
        } else if (finalAvg >= 70) {
          grade = 'C';
        } else if (finalAvg >= 60) {
          grade = 'D';
        } else {
          grade = 'F';
        }
        String displayComment =
            student['comment']?.toString().toUpperCase() ?? "No comment provided";

        String feedback = switch (grade) {
          "A" => "Outstanding performance!",
          "B" => "Good work, keep it up!",
          "C" => "Satisfactory. Room to improve.",
          "D" => "Needs improvement.",
          "F" => "Failing. Please seek help.",
          _ => "Unknown grade.",
        };

        String reportCard = '''
╔═══════════════════════════════╗
║       REPORT CARD             ║
╠═══════════════════════════════╣
║  Name:    ${student['name']}              ║
║  Scores:  $scores             ║
║  Bonus:   +$bonus                 ║
║  Average: ${finalAvg.toStringAsFixed(1)}                ║
║  Grade:   $grade                   ║
║  Comment: $displayComment  ║
╚══════════════════════════════╝
      ''';
        print(reportCard);
        print('Feedback: $feedback');
        break;

      // ======================== Class Summary ==========================
      case '7':
        if (studentList.isEmpty) {
          print("No students available.");
          break;
        }

        int totalStudents = 0;

        double classTotal = 0;
        int passCount = 0;
        double highestAvg = 0;
        double lowestAvg = 101;
        Set<String> uniqueGrades = {};

        for (var student in studentList) {
          List<double> scores = List<double>.from(student['scores']);
          if (scores.isEmpty) {
            continue;
          }
          // total marks calculation  
          double sum = 0;
          for (double score in scores) {
            sum += score;
          }
          // student wise average marks calculation with bonus
          double average = sum / scores.length;
          average = average + (student['bonus'] ?? 0);
          if (average > 100) {
            average = 100;
          }

          // grade finder
          String grade;
          if (average >= 90) {
            grade = 'A';
          } 
          else if (average >= 80) {
            grade = 'B';
          } 
          else if (average >= 70) {
            grade = 'C';
          } 
          else if (average >= 60) {
            grade = 'D';
          } 
          else {
            grade = 'F';
          }

          classTotal += average;
          totalStudents++;

          if (average > highestAvg) {
            highestAvg = average;
          }
          if (average < lowestAvg) {
            lowestAvg = average;
          }

          if (scores.isNotEmpty && average >= 60) {
            passCount++;
          }

          uniqueGrades.add(grade);
        }

        if (totalStudents == 0) {
          print("No student has scores yet.");
          break;
        }

        // class wise average
        double classAverage = classTotal / totalStudents;

        // generate summary lines
        var summaryLines = [
          for (var s in studentList)
            "${s['name']}: ${s['scores'].length} scores",
        ];

        print("===== CLASS SUMMARY =====");
        print("Total students: ${studentList.length}");
        print("Students with scores: $totalStudents");
        print("Passing students: $passCount");
        print("Class average: ${classAverage.toStringAsFixed(2)}");
        print("Highest average: ${highestAvg.toStringAsFixed(2)}");
        print("Lowest average: ${lowestAvg.toStringAsFixed(2)}");
        print("Unique grades: $uniqueGrades");
        print("====== INDIVIDUAL STUDENT SUMMARY ======");
        for (var line in summaryLines) {
          print(line);
        }
        break;

      case '8':
        print("Exiting Student Grader. Goodbye!");
        break;
  
      default:
        print("Invalid option. Please choose a number between 1 and 8.");
    }
  } while (userInput != '8');
}
