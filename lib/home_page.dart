import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      childAspectRatio: 0.6,
      crossAxisCount: 3,
      padding: EdgeInsets.all(10.0),
      children: List.generate(9, (index) {
        return Container(
          margin: EdgeInsets.all(10.0),
          decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
          child: Column(
            children: <Widget>[
              Image.asset('assets/images/ige.jpg'),
              Text('Imperial God Emperor', style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold),)
            ],
          ),
        );
      }),
    );
  }
}
