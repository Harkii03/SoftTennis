import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting

class RecordPage extends StatefulWidget {
  @override
  _RecordPageState createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
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
              child: Text('記録を追加'),
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

  // void _showAddRecordDialog() async {
  //   await showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: Text('記録を追加'),
  //         content: TextField(
  //           controller: _textEditingController,
  //           decoration: InputDecoration(labelText: '記録を入力してください'),
  //         ),
  //         actions: [
  //           ElevatedButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: Text('キャンセル'),
  //           ),
  //           ElevatedButton(
  //             onPressed: () {
  //               setState(() {
  //                 if (_textEditingController.text.isNotEmpty) {
  //                   recordList.add(_textEditingController.text);
  //                   recordList.sort();
  //                   _textEditingController.clear();
  //                 }
  //               });
  //               Navigator.of(context).pop();
  //             },
  //             child: Text('保存'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}
