import 'dart:io';

double getGPA(List<double> credits, List<double> grades) {
  double gradeTotal = 0.0, creditTotal = 0.0;
  for (int i = 0; i < credits.length; i++) {
    gradeTotal += grades[i] * credits[i];
    creditTotal += credits[i];
  }
  return (gradeTotal / creditTotal);
}

void main() {
  List<double> credits = [];
  List<double> grades = [];
  while (true) {
    String? str = stdin.readLineSync()!;
    if (str == 'e') break;

    List<String> ls = str.split(' ');
    try {
      if (ls.length != 2 ||
          double.parse(ls[0]) <= 0 ||
          double.parse(ls[1]) <= 0 ||
          double.parse(ls[1]) >= 4.3) throw ();

      credits.add(double.parse(ls[0]));
      grades.add(double.parse(ls[1]));
    } catch (e) {
      print('Invalid input');
      continue;
    }
  }
  print(getGPA(credits, grades));
}
