// text.dart
import 'package:flutter/material.dart';
import 'service/machine_translation.dart';

class TranslatorPage extends StatefulWidget {
  const TranslatorPage({super.key});

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


class _TextPageState extends State<TranslatorPage> {
  String selectedLanguage1 = 'English';
  String selectedLanguage2 = 'Lambani';
  final TextEditingController _editableTextController = TextEditingController();
  TextEditingController controller = TextEditingController();
  bool isTranslating = false;

  void swapLanguages() {
    setState(() {
      final temp = selectedLanguage1;
      selectedLanguage1 = selectedLanguage2;
      selectedLanguage2 = temp;
    });
  }

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
        title: const Text('Text', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: LanguageSelectionDropdown(
                    selectedLanguage: selectedLanguage1,
                    onLanguageChanged: (String? newValue) {
                      setState(() {
                        selectedLanguage1 = newValue!;
                      });
                    },
                    languages: const ['English', 'Kannada', 'Lambani', 'Tamil'], // Add other languages if necessary
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.swap_horiz, color: Colors.green),
                  onPressed: swapLanguages,
                ),
                Expanded(
                  child: LanguageSelectionDropdown(
                    selectedLanguage: selectedLanguage2,
                    onLanguageChanged: (String? newValue) {
                      setState(() {
                        selectedLanguage2 = newValue!;
                      });
                    },
                    languages: const ['English', 'Kannada', 'Lambani', 'Tamil'], // Add other languages if necessary
                  ),
                ),
              ]
            ),
            Column(
              children: [
                const SizedBox(height: 15), // Add some spacing between the two fields
                Center(
                  child: TextField(
                    controller: controller,
                    maxLines: 4,
                    readOnly: true,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      labelText: 'Translated sentence appears here',
                      fillColor: Colors.green.shade50, // Sets the fill color to a light green
                      filled: true, // Don't forget to set filled to true to enable the fillColor
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0), // Rounded edges
                        borderSide: BorderSide(
                          color: Colors.grey.shade400, // Sets the border color to grey
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0), // Rounded edges for the enabled state
                        borderSide: BorderSide(
                          color: Colors.grey.shade400, // Sets the enabled border color to grey
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0), // Rounded edges for the focused state
                        borderSide: BorderSide(
                          color: Colors.grey.shade500, // Optionally, change the color for when the field is focused
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15), // Add some spacing between the two fields
                Center(
                  child: TextField(
                    controller: _editableTextController,
                    maxLines: 4,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                      labelText: 'Enter the sentence to be translated',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 8), // Add some spacing between the two fields
                ElevatedButton(
                  onPressed: isTranslating
                      ? null // 2. Make the button non-clickable when translating
                      : () async {
                          // Dismiss the keyboard
                          FocusScope.of(context).unfocus();
                          setState(() {
                            isTranslating = true; // Start translating
                          });

                          final text1 = selectedLanguage1;
                          final text2 = selectedLanguage2;
                          final userText = _editableTextController.text;

                          // Simulate translation logic
                          String? translatedText = await translateText(text1, text2, userText);

                          if (translatedText != null) {
                            setState(() {
                              controller.text = translatedText;
                            });
                          } else {
                            print("Failed to translate text or received an empty response.");
                          }

                          setState(() {
                            isTranslating = false; // End translating
                          });
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isTranslating ? Colors.red : Colors.green, // 4. Change color based on state
                    minimumSize: const Size(double.infinity, 50), // Makes the button wide and tall
                  ),
                  child: Text(
                    isTranslating ? 'Translating...' : 'Translate', // 3. Update button text based on state
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

