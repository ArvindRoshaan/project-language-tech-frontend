import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
      routes: {
        '/second': (context) => SecondPage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/siplab.png',
                width: 420,
                height: 120,
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/second',
                      arguments: 'Speech to Speech');
                },
                child: CardWidget(
                  image: 'assets/images/micro.png',
                  text: 'Speech to Speech',
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/second',
                      arguments: 'Text to Text');
                },
                child: CardWidget(
                  image: 'assets/images/text.png',
                  text: 'Text to Text',
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/second',
                      arguments: 'Text to Image');
                },
                child: CardWidget(
                  image: 'assets/images/image.png',
                  text: 'Text to Image',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  final String image;
  final String text;

  const CardWidget({Key? key, required this.image, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.2,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[200],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            image,
            width: 80,
            height: 80,
          ),
          SizedBox(height: 10),
          Text(
            text,
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Speech to Speech'),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Take a break line statement',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                // Dropdown 1
                Expanded(
                  child: DropdownButton<String>(
                    items: ['English', 'Spanish', 'French']
                        .map((String value) => DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            ))
                        .toList(),
                    onChanged: (String? value) {
                      // Handle dropdown change
                    },
                    hint: Text('Select Language'),
                  ),
                ),
                // Icon
                Icon(Icons.swap_horiz, size: 36),
                // Dropdown 2
                Expanded(
                  child: DropdownButton<String>(
                    items: ['English', 'Spanish', 'French']
                        .map((String value) => DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            ))
                        .toList(),
                    onChanged: (String? value) {
                      // Handle dropdown change
                    },
                    hint: Text('Select Language'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            // Input Boxes
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.4,
              child: Column(
                children: [
                  TextField(
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      labelText: 'Input Box 1',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      labelText: 'Input Box 2',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            // Translate Button
            ElevatedButton(
              onPressed: () {
                // Handle translate button click
              },
              child: Text('Translate'),
            ),
          ],
        ),
      ),
    );
  }
}
