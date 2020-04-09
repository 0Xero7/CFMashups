import 'package:cfchooser/services/ProblemService.dart';
import 'package:flutter/material.dart';

class Filters extends StatefulWidget {
  List<String> activeTags;
  TextEditingController tagTextController;
  List<String> tags, filteredTags;
  Function tagChangedCallback;
  int problemCount;
  int rating;

  Filters({this.activeTags, this.tagChangedCallback, this.rating});// { this.activeTags = arg; }

  @override
  State<StatefulWidget> createState() {
    tagTextController = TextEditingController();
    tags = ProblemService.tags.keys.toList();
    filteredTags = ProblemService.tags.keys.toList();
    problemCount = ProblemService.getCountOfRandomProblemWith(rating: rating, tags: activeTags);

    return _FiltersState();
  }
}

class _FiltersState extends State<Filters> {

  @override
  void initState() {
    super.initState();

    widget.tagChangedCallback(widget.activeTags);

    widget.tagTextController.addListener(() {
      var temp = List<String>();
      for (var i in widget.tags)
        if (i.toString().contains(widget.tagTextController.text))
          temp.add(i.toString());

      setState(() {
        widget.filteredTags = temp;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 300,
          height: 400,

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10)
          ),

          child: Stack(
            children: <Widget>[
              Positioned(
                top: 18,
                left: 20,

                child: Text(
                  'Tags [${widget.problemCount}]',
                  style: const TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 20
                  )
                ),
              ),

              Positioned(
                top: 18,
                right: 20,

                child: Material(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: (widget.problemCount > 0 ? Colors.blue.shade200 : Colors.black12), width: 2),                  
                    borderRadius: BorderRadius.circular(40),
                  ),
                  color: Colors.black.withAlpha(6),
                  child: InkWell(
                    onTap: (widget.problemCount > 0 ? (() { Navigator.pop(context); }) : null),

                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                      child: Text(
                        'Done',
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontSize: 16,
                          color: (widget.problemCount > 0 ? Colors.black : Colors.black38)
                        )
                      ),
                    ),
                  ),
                ),
              ),

              Positioned(
                top: 60,
                left: 15,
                right: 15,

                child: TextField(
                  autofocus: true,
                  controller: widget.tagTextController,
                  textCapitalization: TextCapitalization.none,
                  textInputAction: TextInputAction.search,

                  decoration: InputDecoration(
                    isDense: true,
                    suffixIcon: Icon(Icons.search),
                    suffixIconConstraints: BoxConstraints.tight(Size(30, 30)),
                  ),
                ),
              ),

              Positioned(
                top: 100,
                bottom: 15,
                left: 15,
                right: 15,

                child: SingleChildScrollView(
                  child: Container(
                    child: Wrap(
                      spacing: 5,
                      runSpacing: 0,
                      children: List.generate(widget.filteredTags.length, (index) => 
                        FilterChip(
                          showCheckmark: false,
                          selectedColor: Colors.blue.shade200,
                          selected: widget.activeTags.contains(widget.filteredTags[index]),
                          label: Text(widget.filteredTags[index]), 
                          onSelected: (e) {
                            setState(() {                              
                              if (e)
                                widget.activeTags.add(widget.filteredTags[index]);
                              else
                                widget.activeTags.remove(widget.filteredTags[index]);

                              widget.tagChangedCallback(widget.activeTags);
                              widget.problemCount = 
                                ProblemService.getCountOfRandomProblemWith(rating: widget.rating, tags: widget.activeTags);
                            });
                          },),
                        ),
                    ),
                  ),
                ),
              ),


            ],
          ),
        ),
      ),
    );  
  }
}