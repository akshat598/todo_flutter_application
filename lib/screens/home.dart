import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo_firebase/screens/add_task.dart';
import 'package:todo_firebase/screens/description.dart';
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String uid = ' ';
  @override

  getuid()async{
    FirebaseAuth auth = FirebaseAuth.instance;
    final User user = await auth.currentUser!;
    setState(() {
      uid = user.uid;
    });
  }

  void initState(){
    getuid();
    super.initState();
  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('TODO'),
      actions: [
        IconButton(
            onPressed: ()async{
              await FirebaseAuth.instance.signOut();
            },
            icon: Icon(Icons.logout))
      ],
      backgroundColor: Colors.purple,),
      body: Container(
        padding: EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder(stream: FirebaseFirestore.instance.collection('tasks').doc(uid).collection('mytasks').snapshots(),
        builder: (context,snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(),);
          }
          else{
            final docs = snapshot.data?.docs;
            return ListView.builder(itemCount: docs?.length,
            itemBuilder: (context,index){
              //to convert timestamp to string.so it can be used in a text field
              var time = (docs![index]['timestamp'] as Timestamp)
                  .toDate();
                  //.toString();
              return InkWell(
                onTap: (){
                  Navigator.push(context,MaterialPageRoute(builder: (context)=>Description(
                    title: docs[index]['title'],
                    description: docs[index]['description'],
                  )
                  ));
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Color(0xff121211),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: 90,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 20),
                            child: Text(docs[index]['title'],
                            style: GoogleFonts.roboto(fontSize: 20),),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 20),
                          //to display time in a format from timestamp
                          child: Text(DateFormat.yMd().add_jm().format(time)),
                        ),
                      ],
                ),
                      Container(child: IconButton(icon: Icon(Icons.delete),
                        //to delete the entry of tasks
                        onPressed: () async{
                        await FirebaseFirestore.instance
                            .collection('tasks')
                            .doc(uid)
                            .collection('mytasks')
                            .doc(docs[index]['time'])
                            .delete();
                        },
                      )
                        ,)
                    ],
                  ),
                ),
              );
            },);
          }
        },
        ),
        //color: Colors.red,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add,color: Colors.white,),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>AddTask()));
        },
      ),
    );
  }
}
