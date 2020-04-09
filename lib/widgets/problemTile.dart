import 'package:cfchooser/models/ProblemModel.dart';
import 'package:cfchooser/services/ProblemService.dart';
import 'package:cfchooser/widgets/filters.dart';
import 'package:flutter/material.dart';
import 'dart:js' as js;

class ProblemTile extends StatefulWidget {
  Problem item;
  final int index;
  TextEditingController controller;
  Function deleteCallback, refreshCallback;
  FocusNode focus;
  int lastRating = -1;

  ProblemTile({this.index, this.item, this.refreshCallback, this.deleteCallback}) {
    controller = TextEditingController();
    controller.text = item.rating.toString();
    focus = FocusNode();
    focus.addListener(() { 
      if (int.parse(controller.text) != lastRating) 
        refreshCallback(int.parse(controller.text), item.tagNames); 
      lastRating = int.parse(controller.text);
    });
    lastRating = item.rating;
  }

  @override
  _ProblemTileState createState() => _ProblemTileState();
}

class _ProblemTileState extends State<ProblemTile> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, boxSize) {
        print(boxSize.biggest);
        return Container(
          //height: 60,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black.withAlpha(20), width: 2),
              borderRadius: BorderRadius.circular(10)),
              
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),

            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('${widget.index + 1}',
                        style: TextStyle(fontSize: 16, fontFamily: 'OpenSans')),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                            child: new Text(
                              boxSize.biggest.width > 500 ?
                              '[${widget.item.contestID}-${widget.item.index}]\t\t${widget.item.name}' :
                              '[${widget.item.contestID}-${widget.item.index}]\n${widget.item.name}',
                              style: TextStyle(
                                fontSize: 18, 
                                fontFamily: 'OpenSans',
                              ),
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () {
                              js.context.callMethod('open', [widget.item.problemLink]);
                            }),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Row(children: [
                      Container(
                          width: 60,
                          height: 38,
                          child: TextField(
                            controller: widget.controller,
                            focusNode: widget.focus,
                            decoration: InputDecoration(
                              isDense: true,
                              // enabledBorder: InputBorder.none,
                              // focusedBorder: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                            ),
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                            ),
                            textAlign: TextAlign.center,
                            cursorWidth: 1,
                          )),
                      SizedBox(
                        width: 10,
                      ),
                      Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () { widget.refreshCallback(int.parse(widget.controller.text), widget.item.tagNames); }, 
                            child: Icon(Icons.refresh, size: 27))
                          ),
                      SizedBox(
                        width: 10,
                      ),
                      Material(
                          color: Colors.transparent,
                          child: InkWell(
                              onTap: () => widget.deleteCallback(),
                              child: Icon(Icons.delete,
                                  size: 24, color: Colors.red.shade400))),
                    ])
                  ],
                ),

                Container(
                  width: double.infinity,
                  height: 50,

                  child: Row(
                    children: <Widget>[
                      Material(
                        child: InkWell(
                          child: Icon(Icons.filter_list),

                          onTap: () async {
                            var changedTags = List<String>();
                            await showDialog(
                              context: context,
                              builder: (context) => Filters(
                                activeTags: widget.item.tagNames,
                                tagChangedCallback: (arg) => changedTags = arg,
                                rating: widget.item.rating,
                              ),                              
                            );

                            print(changedTags);
                            var p = ProblemService.getRandomProblemWith(rating: widget.item.rating, tags: changedTags);
                            setState(() {
                              widget.item = p;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: ListView.separated(
                          separatorBuilder: (context, _) => const SizedBox(width: 5,),
                          itemBuilder: (context, index) {
                            return FilterChip(label: Text(widget.item.tagNames[index]), onSelected: (s) {},);
                          },
                          itemCount: widget.item.tagNames.length,
                          scrollDirection: Axis.horizontal,
                        ),
                      )
                    ],
                  )
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
