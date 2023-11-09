import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HistoryForm {
  final String formTitle;
  final String formContent;

  HistoryForm({
    required this.formTitle,
    required this.formContent,
  });
}

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key, Key? key1});

  @override
  Widget build(BuildContext context) {
    // Replace 'historyForms' with your actual list of history forms
    final List<HistoryForm> historyForms = [
      HistoryForm(
        formTitle: "Form 1",
        formContent: "This is the content of Form 1.",
      ),
      HistoryForm(
        formTitle: "Form 2",
        formContent: "This is the content of Form 2.",
      ),
      // Add more forms as needed
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'History',
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        toolbarHeight: 65,
        backgroundColor: const Color(0xFFB0B3BF),
      ),
      backgroundColor: const Color.fromARGB(255, 29, 62, 162),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.separated(
          itemCount: historyForms.length,
          separatorBuilder: (context, index) => const SizedBox(height: 20),
          itemBuilder: (context, index) {
            return CustomContainer(
              backgroundColor: Colors.white,
              child: ListTile(
            
                title: Text(
                  historyForms[index].formTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                subtitle: Text(
                  historyForms[index].formContent,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
                trailing: ElevatedButton(
                  onPressed: () {
                    // Implement the action for the button
                    _buttonAction(historyForms[index]);
                  },
                  child: const Text('Generate'),
                ),
              ),
            );
          },
        ),
      ),
    );
  }


  void _buttonAction(HistoryForm form) {
    // Implement the action for the button
  }
}

class CustomContainer extends StatelessWidget {
  final Color backgroundColor;
  final Widget child;

  const CustomContainer({
    Key? key,
    required this.backgroundColor,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }
}

