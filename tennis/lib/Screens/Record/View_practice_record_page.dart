import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PracticeViewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('練習記録一覧',
            style: TextStyle(color: Color.fromARGB(246, 241, 205, 172))),
        backgroundColor: Color.fromARGB(173, 49, 44, 44),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('practice_records')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          List<QueryDocumentSnapshot> records = snapshot.data!.docs;

          return ListView.builder(
            itemCount: records.length,
            itemBuilder: (context, index) {
              var record = records[index];
              return ListTile(
                title: Text('日付: ${record['date']}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('反省: ${record['reflection']}'),
                    Text('課題: ${record['task']}'),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
