import 'package:cfchooser/models/ProblemModel.dart';
import 'package:cfchooser/services/ProblemService.dart';
import 'package:cfchooser/srcs/lowerBound.dart';
import 'package:cfchooser/widgets/problemTile.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:js' as js;

class Dashboard extends StatefulWidget {
  List<Problem> problems = [];
  int totalRating = 0;
  int avgRating = 0;

  @override
  State<StatefulWidget> createState() {
    return _Dashboard();
  }  
}

class _Dashboard extends State<Dashboard> {

  Widget _buildProblemList() {
    return ListView.separated(
      separatorBuilder: (context, index) => SizedBox(height: 8),

      itemBuilder: (context, index) {
        return ProblemTile(
          index: index, 
          item: widget.problems[index],
          refreshCallback: (rating, tags) {
            print(rating);
            print(tags);
            setState(() {
              widget.avgRating = widget.totalRating ~/ widget.problems.length;
              widget.problems[index] = 
                ProblemService.getRandomProblemWith(rating: rating, tags: tags);
            });
          },
          deleteCallback: () {
            setState(() {
              widget.totalRating -= widget.problems[index].rating;
              widget.problems.removeAt(index);
              if (widget.problems.length == 0) widget.avgRating = 0;
              else widget.avgRating = widget.totalRating ~/ widget.problems.length;
            });
          },
        );
      },

      itemCount: widget.problems.length,
    );
  }


  @override
  Widget build(BuildContext context) {
    print(widget.problems.length);
    return Scaffold(
      backgroundColor: Color(0xfffafafa),
      body: SafeArea(
        top: true,

        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              right: 0,

              child: Container(
                height: 60,
                
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(offset: Offset(0, 5), color: Colors.black12, blurRadius: 6)
                  ]
                ),

                child: Padding(
                  padding: const EdgeInsets.only(top: 12, left: 25),
                  child: Text(
                    'CF Mashup Creator',
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontSize: 25
                    ),
                  ),
                )
              ),
            ),

            widget.problems.length > 0 ?
              Positioned(
                top: 95,
                left: 65,

                child: Text(
                  'Problem',
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 18
                  ),
                ),
              ) : 
              Container(),

            widget.problems.length > 0 ?
              Positioned(
                top: 95,
                right: 115,

                child: Text(
                  'Rating',
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 18
                  ),
                ),
              ) :
              Container(),

            Positioned(
              top: 130,
              left: 20,
              right: 20,
              bottom: 85,
              
              child: widget.problems.length == 0 ? 
                Center(
                  child: Text(
                    'No problems in this Mashup.\nTap the "+" button\nto continue.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontSize: 15,
                      color: Colors.black54
                    ),
                  ),
                ) :
                _buildProblemList()
              ),


            Positioned(
              bottom: 0,
              left: 0,
              right: 0,

              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(color: Colors.black.withAlpha(12), offset: Offset(0, -6), blurRadius: 6)
                  ],
                  color: Colors.white
                ),

                child: Stack(
                  children: <Widget>[
                    Positioned(
                      right: 75,
                      top: 8,

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            'Overall Rating',
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: 15,
                              color: Colors.black54
                            ),
                          ),
                          Text(
                            widget.avgRating.toString(),
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,

                      child: Container(
                        height: 20,
                        color: Colors.black12,

                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                'Made with <3 by ',
                                style: TextStyle(
                                  fontFamily: 'OpenSans',
                                  fontSize: 10,
                                  color: Colors.black45
                                ),
                              ),

                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  child: Text(
                                    '@0Xero7',
                                    style: TextStyle(
                                      fontFamily: 'OpenSans',
                                      fontSize: 10,
                                      color: Colors.blue
                                    ),
                                  ),

                                  onTap: () => js.context.callMethod('open', ['https://github.com/0Xero7/']),
                                )
                              )
                            ],
                          ),
                        ),
                      ),
                    ),

                    Positioned(
                      left: 10,
                      top: 8,
                      bottom: 27,
                      
                      child: Container(
                        width: 120,
                        height: 30,
                        child: Material(
                          color: Colors.blue.shade200,
                          shape: RoundedRectangleBorder(side: BorderSide(color: Colors.blue.shade200, width: 2), borderRadius: BorderRadius.circular(40)),
                          elevation: 0,
                          child: InkWell(
                            onTap: () { },

                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Icon(Icons.check, color: Colors.white, size: 20,),
                                const SizedBox(width: 5,),
                                Text(
                                  'Done',
                                  style: TextStyle(
                                    fontFamily: 'OpenSans',
                                    fontSize: 17,
                                    color: Colors.white
                                  ),
                                ),
                              ],
                            )
                          )
                        ),
                      ),
                    ),

                    Positioned(
                      right: 15,
                      top: 8,
                      bottom: 27,
                      
                      child: Material(
                        color: Colors.blue.shade300,
                        borderRadius: BorderRadius.circular(40),
                        elevation: 0,
                        child: InkWell(
                          onTap: () {
                            int rating = 700;
                            if (widget.problems.length > 0) rating = (widget.problems.last.rating ~/ 100) * 100 + 100;
                            var l = Algorithms.LowerBound(ProblemService.getProblemList(), rating),
                                r = Algorithms.LowerBound(ProblemService.getProblemList(), rating + 1);

                            final R = Random();
                            var i = l + R.nextInt(r - l);

                            widget.totalRating += rating;

                            setState(() {
                              widget.problems.add(ProblemService.getRandomProblemWith(rating: rating, tags: ['implementation']));
                              widget.avgRating = widget.totalRating ~/ widget.problems.length;
                            }); 
                          },

                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Icon(Icons.add, color: Colors.white),
                          ),
                        ),
                      ),

                    )
                  ],
                ),
              )
            ),
          ],
        ) 
      ),
    );
  }
}