import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting

class PracticeRecordPage extends StatefulWidget {
  @override
  _PracticeRecordPageState createState() => _PracticeRecordPageState();
}

class _PracticeRecordPageState extends State<PracticeRecordPage> {
  List<String> recordList = [];
  TextEditingController _textEditingController =
      TextEditingController(text: "Default Value");

  // Step 2: Add a DateTime variable to store the selected date
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('記録',
            style: TextStyle(color: Color.fromARGB(246, 241, 205, 172))),
        backgroundColor: Color.fromARGB(173, 49, 44, 44),
      ),
      body: Column(
        children: [
          //日付をにゅうりょくするフォーム
          Container(
            child: Text('日付'),
          ),
          // Center the date selection widget
          Align(
            alignment: Alignment.center,
            child: InkWell(
              onTap: _showDatePicker,
              child: InputDecorator(
                decoration: InputDecoration(
                  hintText: 'Select Date',
                ),
                child: Text(
                  DateFormat('yyyy-MM-dd').format(_selectedDate),
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
          // ... (existing code remains unchanged)
          Container(
            child: Text('反省'),
          ),
          Container(
            // Rectangular Text Form Field for "反省"
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey),
            ),
            child: TextField(
              maxLines: 5, // To allow multiline input
              decoration: InputDecoration(
                border: InputBorder.none, // Remove the default border
              ),
            ),
          ),
          Container(
            child: Text('課題'),
          ),
          Container(
            // Rectangular Text Form Field for "課題"
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey),
            ),
            child: TextField(
              maxLines: 5, // To allow multiline input
              decoration: InputDecoration(
                border: InputBorder.none, // Remove the default border
              ),
            ),
          ),
          Container(
            //テキストを入力するフォーム
            //記録を追加するボタン
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('記録を追加'),
            ),
          ),
        ],
      ),
    );
  }

  // Step 3: Function to show the date picker
  Future<void> _showDatePicker() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark(), // Use dark theme to have a better contrast
          child: child!,
        );
      },
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}
