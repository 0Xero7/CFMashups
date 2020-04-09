import 'dart:math';

import 'package:bit_array/bit_array.dart';
import 'package:cfchooser/models/ProblemModel.dart';
import 'package:cfchooser/srcs/lowerBound.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class ProblemService {

  static List<Problem> _problems;
  static Map<String, int> tags;
  static bool loaded = false;

  static Future<bool> getProblems() async {
    if (loaded) return true;
    print('fetching...');

    // http.Response client;

    // try {
    //   client = await http.get('https://codeforces.com/api/problemset.problems');
    // } catch (e) {
    //   return false;
    // }
    // print('done fetching');

    //var json = jsonDecode(client.body);
    
    var json = jsonDecode(await rootBundle.loadString('assets/dev/data.json'));
    
    print('done parsing');
    
    if (json['status'] != 'OK') return false;
    print(json['status']);

    var problems = json['result']['problems'];
    tags = Map<String, int>();

    _problems = List<Problem>();

    for (var i in problems) {
        if (i['tags'] != null && i['tags'].length > 0) {
          for (var j in i['tags']) {
            if (!tags.containsKey(j.toString()))
              tags[j.toString()] = tags.length;
          }
        }

        _problems.add(Problem.fromMap(i));
    }

    print(tags);

    _problems.sort((a, b) => a.rating - b.rating);
    print('done sorting');
    print(_problems[0].rating);

    loaded = true;
    return true;
  }

  static Problem getProblem(int index) => _problems[index];
  static List<Problem> getProblemList() => _problems;

  static int getCountOfRandomProblemWith({@required int rating, List<String> tags}) {
    var s = BitArray(512);
    if (tags != null)
      for (var i in tags)
        s.setBit(ProblemService.tags[i]);

    int i = Algorithms.LowerBound(_problems, rating);
    int ret = 0;
    var r = _problems[i].rating;

    while (i < _problems.length && _problems[i].rating == r) {
      var t = s.clone();
      t.xor(_problems[i].tags);
      if (t.isEmpty)
        ++ret;
      ++i;
    }
    return ret;
  }

  static Problem getRandomProblemWith({@required int rating, List<String> tags}) {
    var s = BitArray(512);
    if (tags != null)
      for (var i in tags)
        s.setBit(ProblemService.tags[i]);

    int i = Algorithms.LowerBound(_problems, rating);
    var temp = List<int>();
    var r = _problems[i].rating;

    while (i < _problems.length && _problems[i].rating == r) {
      var t = s.clone();
      t.xor(_problems[i].tags);
      if (t.isEmpty)
        temp.add(i);
      ++i;
    }

    final rand = Random();
    return _problems[temp[rand.nextInt(temp.length)]];
  }
}