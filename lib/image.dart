// text.dart
import 'package:flutter/material.dart';
import 'service/image_generation.dart';

class ImageGeneratorPage extends StatefulWidget {
  const ImageGeneratorPage({super.key});

  @override
  _TextPageState createState() => _TextPageState();
}

class LanguageSelectionDropdown extends StatelessWidget {
  final String selectedLanguage;
  final ValueChanged<String?> onLanguageChanged;
  final List<String> languages;

  const LanguageSelectionDropdown({
    super.key,
    required this.selectedLanguage,
    required this.onLanguageChanged,
    required this.languages,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.white,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedLanguage,
          onChanged: onLanguageChanged,
          items: languages.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          //isExpanded: true,
          //iconSize: 24,
          elevation: 16,
          style: const TextStyle(color: Colors.black),
          dropdownColor: Colors.white,
        ),
      ),
    );
  }
}


class _TextPageState extends State<ImageGeneratorPage> {
  String selectedLanguage = 'English';
  final TextEditingController _editableTextController = TextEditingController();
  TextEditingController controller = TextEditingController();
  bool isFetching = false;
  String imageUrl = '';
  bool isVisible = false; // Initially, the image container is not visible


  @override
  void dispose() {
    _editableTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.of(context).pop(); // Go back to the previous screen
          },
        ),
        title: const Text('Image', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 0.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: LanguageSelectionDropdown(
                    selectedLanguage: selectedLanguage,
                    onLanguageChanged: (String? newValue) {
                      setState(() {
                        selectedLanguage = newValue!;
                      });
                    },
                    languages: const ['English', 'Lambani'], // Add other languages if necessary
                  ),
                ),
              ]
            ),
            Column(
              children: [
                const SizedBox(height: 15), // Add some spacing between the two fields
                Visibility(
                  visible: isVisible, // Controlled by the isVisible state variable
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 400, // Adjust the height based on your needs
                    decoration: BoxDecoration(
                      color: Colors.grey[300], // Placeholder color
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: imageUrl.isNotEmpty
                          ? Image.network(
                              imageUrl,
                              width: 400, // Set the width as per your requirement
                              height: 400, // Set the height as per your requirement
                            )
                          : Container(), // Placeholder widget when image URL is empty or when isVisible is false
                    ),
                  ),
                ),
                const SizedBox(height: 15), // Add some spacing between the two fields
                Center(
                  child: SizedBox(
                    height: 100,
                    child: TextField(
                      controller: _editableTextController,
                      onTap: () {
                        isVisible = false;
                      },
                      maxLines: 2,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                        labelText: 'Enter the text to be visualized',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  )
                ),
                const SizedBox(height: 8), // Add some spacing between the two fields
                ElevatedButton(
                  onPressed: isFetching
                      ? null // 2. Make the button non-clickable when translating
                      : () async {
                          // Dismiss the keyboard
                          FocusScope.of(context).unfocus();
                          setState(() {
                            isFetching = true; // Start translating
                          });

                          final text = selectedLanguage;
                          final userText = _editableTextController.text;

                          // Simulate translation logic
                          String? newImageUrl = await generateImage(userText, text);

                          if (newImageUrl != null) {
                            setState(() {
                              imageUrl = newImageUrl;
                              isVisible = true; // Show the image container only when newImageUrl is not null
                            });
                          } else {
                            print("Failed to translate text or received an empty response.");
                          }

                          setState(() {
                            isFetching = false; // End translating
                          });
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isFetching ? Colors.red : Colors.green, // 4. Change color based on state
                    minimumSize: const Size(double.infinity, 50), // Makes the button wide and tall
                  ),
                  child: Text(
                    isFetching ? 'Generating...' : 'Generate', // 3. Update button text based on state
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ]
            )
          ],
        )
      ),
    );
  }
}

