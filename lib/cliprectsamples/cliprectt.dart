import 'package:flutter/material.dart';
class CliprectSample extends StatelessWidget {
  const CliprectSample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(
        child: Padding(
            padding: const EdgeInsets.all(15),
            child: ClipRect(
               // borderRadius: BorderRadius.circular(100),
                child: Image.network("https://picsum.photos/250?image=9")
      ),


    ))

    );
  }
}
