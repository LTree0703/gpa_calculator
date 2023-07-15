class GradeData {
  int numAssignments = 5;
  List<String> assignments = [];
  List<String> componentGradesInput = [];
  List<double> componentGrades = [];
  List<double> weights = [];

  GradeData() {
    for (int i = 0; i < numAssignments; i++) {
      addEmptyCourse();
    }
  }

  double get totalGrades {
    double totalGrades = 0.0;
    for (int i = 0; i < numAssignments; i++) {
      totalGrades += componentGrades[i];
    }
    return totalGrades;
  }

  double get totalWeights {
    double totalWeights = 0.0;
    for (int i = 0; i < numAssignments; i++) {
      totalWeights += weights[i];
    }
    return totalWeights / 100;
  }

  double get averageGrade {
    double sum = 0.0;
    for (int i = 0; i < numAssignments; i++) {
      sum += componentGrades[i] * (weights[i] / 100);
    }
    return sum / totalWeights;
  }

  bool get hasCompletedCourse {
    return totalWeights == 100;
  }

  void addEmptyCourse() {
    assignments.add('');
    componentGradesInput.add('');
    componentGrades.add(0.0);
    weights.add(4.3);
  }

  void deleteCourse() {
    assignments.removeLast();
    componentGradesInput.removeLast();
    componentGrades.removeLast();
    weights.removeLast();
  }
}
