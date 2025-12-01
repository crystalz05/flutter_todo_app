import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(),
    );
  }
}


class MyHomePage extends StatefulWidget{
  const MyHomePage({super.key});

  @override
  State<StatefulWidget> createState() => _MyHomePage();

}


class _MyHomePage extends State<MyHomePage>{

  int counter = 0;

  void incrementCount(){
    setState(() {
      counter++;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo Application"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Text("$counter"),
            SizedBox(height: 18),
            ElevatedButton(onPressed: (){
              incrementCount();
            },
                child: Text("Press me"))
          ],
        ),
      ),
    );
  }
}