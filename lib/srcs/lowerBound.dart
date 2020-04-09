import 'package:cfchooser/models/ProblemModel.dart';

class Algorithms {
  static int LowerBound(List<Problem> arg, int val) {
    int l = 0, r = arg.length;

    while (l < r) {
      int m = l + (r - l) ~/ 2;
      if (arg[m].rating < val) l = m + 1;
      else r = m;
    }

    return l;
  }
}