class GradeData {
  int numCourses;
  List<String> assignments = [];
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
    return totalWeights;
  }

  double get averageGrade {
    
    return 0;
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
    componentGrades.add(0.0);
    weights.add(4.3);
  }

  void deleteCourse() {
    assignments.removeLast();
    componentGrades.removeLast();
    weights.removeLast();
  }
}
