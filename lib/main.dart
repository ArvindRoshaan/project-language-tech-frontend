import 'package:flutter/material.dart';
import 'text.dart';
import 'image.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Indian Language Technology',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(),
      routes: {
        '/text': (context) => const TranslatorPage(),
        '/image': (context) => const ImageGeneratorPage(),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Indian Language Technology'),
        /*
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Implement settings navigation
            },
          ),
        ],
        */
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: <Widget>[
          FeatureCard(
            title: 'Text',
            iconData: Icons.text_fields,
            onTap: () {
              // TODO: Navigate to Text feature
              Navigator.of(context).pushNamed('/text'); // Navigate to the TranslatorPage
            },
          ),
          /*
          FeatureCard(
            title: 'Image',
            iconData: Icons.image,
            onTap: () {
              // TODO: Navigate to Voice feature
              Navigator.of(context).pushNamed('/image'); // Navigate to the ImageGeneratorPage
            },
          ),
          */
        ],
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final String title;
  final IconData iconData;
  final VoidCallback onTap;

  const FeatureCard({
    super.key,
    required this.title,
    required this.iconData,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(iconData, size: 50),
            Text(title, style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
      ),
    );
  }
}
