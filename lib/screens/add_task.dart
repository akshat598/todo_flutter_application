import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  //async functions run int he background and wait for the task to run
  //this function which is going to save data to the firebase
  addtaskoffirebase()async{
    FirebaseAuth auth = FirebaseAuth.instance;
    final User user = await auth.currentUser!;
    String uid = user.uid;
    var time = DateTime.now();
    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(uid)
        .collection('mytasks')
        .doc(time.toString())
        .set({
     'title':titleController.text,
    'description':descriptionController.text,
    'time':time.toString(),
    'timestamp': time,//will add timestamp in firebase,then it can be used to display time on the home.dart
    });
    Fluttertoast.showToast(msg:'Data Added');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Task'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              child: TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Enter Title',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 10,),
            Container(
              child: TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Enter Description',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 10,),
            Container(
              width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: (){
                    addtaskoffirebase();
                  },
                  child: Text('Add Task',style: GoogleFonts.roboto(fontSize: 18),),
                  style: ButtonStyle(backgroundColor:
                  MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if(states.contains(MaterialState.pressed))
                              return Colors.purple.shade100;
                            return Theme.of(context).primaryColor;
                  }
                  ),
                ),
            )
            )],
        ),
      ),
    );
  }
}
