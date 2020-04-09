import 'package:bit_array/bit_array.dart';
import 'package:cfchooser/services/ProblemService.dart';

class Problem {
  int contestID;
  String index;
  int rating;
  String problemLink;
  String name;
  BitArray tags;
  List<String> tagNames;

  Problem({this.name, this.contestID, this.index, this.rating, this.problemLink, this.tags, this.tagNames});

  factory Problem.fromMap(Map<String, dynamic> arg) {
    var temp = BitArray(512);
    var tnames = List<String>();
    if (arg['tags'] != null && arg['tags'].length > 0) {
      for (var j in arg['tags']) {
        temp.setBit(ProblemService.tags[j.toString()]);
        tnames.add(j.toString());
      }
    }

    return Problem(
      name: arg['name'],
      contestID: arg['contestId'], 
      index: arg['index'], 
      rating: arg['rating'] ?? -1,
      problemLink: 'https://codeforces.com/problemset/problem/${arg['contestId']}/${arg['index']}',
      tags: temp,
      tagNames: tnames
    );
  }
}