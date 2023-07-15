class GPAData {
  double? cumulativeGPA;
  double? creditsObtained;
  int numCourses = 6;
  List<String> courseName = [];
  List<double> credits = [];
  List<double> grades = [];

  GPAData() {
    for (int i = 0; i < numCourses; i++) {
      addEmptyCourse();
    }
  }

  double get totalGrades {
    double totalGrades = 0.0;
    for (int i = 0; i < numCourses; i++) {
      totalGrades += grades[i] * credits[i];
    }
    return totalGrades;
  }

  double get totalCredits {
    double totalCredits = 0.0;
    for (int i = 0; i < numCourses; i++) {
      totalCredits += credits[i];
    }
    return totalCredits;
  }

  double get semGPA {
    return (totalGrades / totalCredits);
  }

  double get cGPA {
    if (cumulativeGPA == null || creditsObtained == null) {
      return semGPA;
    }
    return (cumulativeGPA! * creditsObtained! + semGPA * totalCredits) /
        (creditsObtained! + totalCredits);
  }

  void addEmptyCourse() {
    courseName.add('');
    credits.add(0.0);
    grades.add(4.3);
  }

  void deleteCourse() {
    courseName.removeLast();
    credits.removeLast();
    grades.removeLast();
  }
}
