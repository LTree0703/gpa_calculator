class GradeData {
  int numCourses;
  List<String> assignments = [];
  List<String> componentGradesInput = [];
  List<double> componentGrades = [];
  List<double> weights = [];

  double get totalGrades {
    double totalGrades = 0.0;
    for (int i = 0; i < numCourses; i++) {
      totalGrades += componentGrades[i];
    }
    return totalGrades;
  }

  double get totalWeights {
    double totalWeights = 0.0;
    for (int i = 0; i < numCourses; i++) {
      totalWeights += weights[i];
    }
    return totalWeights / 100;
  }

  double get averageGrade {
    double sum = 0.0;
    for (int i = 0; i < numCourses; i++) {
      sum += componentGrades[i] * (weights[i] / 100);
    }
    return sum / totalWeights;
  }

  bool get hasCompleted {
    return totalWeights > 100;
  }

  GradeData(this.numCourses) {
    for (int i = 0; i < numCourses; i++) {
      addEmptyCourse();
    }
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
