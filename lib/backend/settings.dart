import 'package:shared_preferences/shared_preferences.dart';

class UserConfig {
  final SharedPreferences prefs;

  UserConfig(this.prefs);

  void alter(String key, int value) {
    prefs.setInt(key, value);
  }

  int get defaultCourses {
    return prefs.getInt('defaultCourses') ?? 6;
  }

  int get defaultAssignments {
    return prefs.getInt('defaultAssignments') ?? 5;
  }
}
