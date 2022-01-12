import 'dart:collection';
import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Widget> _messages = <Widget>[];
  final ScrollController _scrollController = ScrollController();
  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("The Next Wappin"),
        backgroundColor: const Color.fromARGB(255, 9, 99, 88),
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(color: Colors.white),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                controller: _scrollController,
                reverse: true,
                padding: const EdgeInsets.all(16.0),
                children: UnmodifiableListView(_messages),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 9, 99, 88)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white
                      ),
                      child: TextField(
                        maxLines: null,
                        controller: myController,
                        style: const TextStyle(
                            color: Colors.black
                        ),
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(16),
                          border: InputBorder.none
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.all(13.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black38,
                    ),
                    child: InkWell(
                      child: const Icon(
                        Icons.message,
                        color: Colors.white,
                      ),
                      onTap: () async {
                        var message = myController.text;

                        myController.text = '';
                        if(message != '') {
                          addOwnMessage(message, DateTime.now());

                          var nextText = message;
                          if(message == '/quote'){
                            var url = Uri.https('api.kanye.rest', '/');

                            var response = await http.get(url);
                            if (response.statusCode == 200) {
                              var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
                              var quote = jsonResponse['quote'];
                              nextText = quote;
                            } else {
                              nextText = "Oops, failed to get quote";
                            }
                            addNextMessage(nextText, DateTime.now());
                          }else{
                            Future.delayed(const Duration(seconds: 1), (){
                              addNextMessage(message, DateTime.now());
                            });
                          }

                        }
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose

    myController.dispose();
    super.dispose();
  }

  void addNextMessage(String message, DateTime now) {

    setState(() {
      _messages.insert(0,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 2),
                decoration: BoxDecoration(
                    color: const Color.fromARGB(44, 9, 99, 88),
                    borderRadius: const BorderRadius.only(topRight: Radius.circular(16), bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
                    border: Border.all(color: const Color.fromARGB(255, 9, 99, 88), width: 0.2)
                ),
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(message,
                      style: const TextStyle(fontSize: 14),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(now.hour.toString().padLeft(2, '0')+":"+now.minute.toString().padLeft(2, '0'),
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
      );
    });
    _scrollController.animateTo(
      0.0,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }

  void addOwnMessage(String message, DateTime now) {

    setState(() {
      _messages.insert(0,
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 2),
                decoration: BoxDecoration(
                    color: const Color.fromARGB(99, 9, 99, 88),
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), bottomRight: Radius.circular(16), bottomLeft: Radius.circular(16)),
                    border: Border.all(color: const Color.fromARGB(255, 9, 99, 88), width: 0.2)
                ),
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(message,
                      style: const TextStyle(fontSize: 14),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(now.hour.toString().padLeft(2, '0')+":"+now.minute.toString().padLeft(2, '0'),
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
      );
    });

    _scrollController.animateTo(
      0.0,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }
}
