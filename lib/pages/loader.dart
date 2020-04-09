import 'package:cfchooser/pages/dashboard.dart';
import 'package:cfchooser/services/ProblemService.dart';
import 'package:flutter/material.dart';

class Loader extends StatefulWidget {
  bool errorState = false; 
  @override
  _LoaderState createState() => _LoaderState();
}

class _LoaderState extends State<Loader> {
  void load(BuildContext context) async {
    bool res = await ProblemService.getProblems();
    if (res)
      Navigator.popAndPushNamed(context, '/dashboard');
    else
      setState(() {
        widget.errorState = true;
      });
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CircularProgressIndicator(),

          SizedBox(height: 20,),

          Column(
            children: <Widget>[
              Text(
                'Loading Problemsets', 
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'OpenSans'
                )
              ),
              Text(
                'This will likely take a while', 
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'OpenSans',
                  color: Colors.black54
                )
              ),
              const SizedBox(height: 50),
              Text(
                'build290320-2', 
                style: TextStyle(
                  fontSize: 10,
                  fontFamily: 'OpenSans',
                  color: Colors.black26
                )
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.warning, size: 80, color: Colors.amber,),
          
          SizedBox(height: 20,),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'An error occurred.\nCheck your internet connection\nand try again.', 
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'OpenSans',
                ),
                textAlign: TextAlign.center,
              )
            ]
          ),          
          
          SizedBox(height: 20,),

          MaterialButton(
            color: Colors.amber,
            elevation: 1,
            hoverElevation: 2,

            child: Text(
              'Retry', 
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'OpenSans',
              ),
              textAlign: TextAlign.center,
            ),

            onPressed: () {
              setState(() {
                widget.errorState = false;
              });
              load(context);
            },
          )
        ]
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    load(context);

    return Scaffold(
      body: SafeArea(
        top: true,

        child: widget.errorState ? _buildError() : _buildLoading()
      ),
    );
  }
}