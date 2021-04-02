import 'package:flutter/material.dart';

class OfflinePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(alignment: Alignment.center,
            image: AssetImage('assets/need/wifi.png'),
            height: 100.0,
            width: 100.0,
          ),
          SizedBox(height: 5.0),
          Text('Упс, нет соединение', style: TextStyle(color: Colors.blueAccent, fontSize: 18.0, fontWeight: FontWeight.bold),),
          Text('с интернетом!', style: TextStyle(color: Colors.blueAccent, fontSize: 18.0, fontWeight: FontWeight.bold),)
        ]
      ))
    )
    );
  }
}