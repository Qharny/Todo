import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // background,
        appBar: AppBar(
          title: const Text(
            "TODO APP",
            style: TextStyle(fontSize: 20, ),
          ),
          // backgroundColor: primary,
          elevation: 1,
          shadowColor: Colors.black,
          actions: [
            IconButton(onPressed: ()=>(
              // todo: them switch
            ), icon: const Icon(Icons.sunny, ))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          // backgroundColor: primary,
          onPressed: () => (
            // todo: add action
          ),
          child: const Icon(
            Icons.add,
            
          ),
        ),
      ),
    );
  }
}
