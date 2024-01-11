import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  //.............................
  final _formkey = GlobalKey<FormState>();
  var _email = ' ';
  var _password = ' ';
  bool isloginPage = false;
  var _username = ' ';

  //........................
  startauthentication() {
    final validity = _formkey.currentState!.validate();
    FocusScope.of(context).unfocus();
    submitform(String email,String password,String username) async{
      final auth = FirebaseAuth.instance;
      UserCredential authResult;
      try{
        if(isloginPage){
          authResult = await auth.signInWithEmailAndPassword(email: email, password: password);
        }
        else{
          authResult = await auth.createUserWithEmailAndPassword(email: email, password: password);
          String uid = authResult.user!.uid;
          await FirebaseFirestore.instance.collection('users').doc(uid).set(
              {
                'username':username,
                'email':email
              });
        }
      }
      catch(err){
        print(err);
      }
    }

    if(validity){
      _formkey.currentState!.save();
      submitform(_email,_password,_username);
    }


  }

  //.....................
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10,right: 10,top: 10),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        children: [
          Container(
            margin: EdgeInsets.all(30),
            height: 200,
            child: Image.asset('assets/abc.jpeg'),
          ),
          Container(
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if(!isloginPage)
                  TextFormField(
                    obscureText: true,//stars come when you type to concel
                    keyboardType: TextInputType.emailAddress,
                    key: ValueKey('username'),
                    validator: (value){
                      if(value!.isEmpty){
                        return 'Incorrect Username';
                      }
                      return null;
                    },
                    onSaved: (value){
                      _username = value!;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(8.0),
                        borderSide: new BorderSide(),
                      ),
                      labelText: "Enter Username",
                      labelStyle: GoogleFonts.roboto(),
                    ),
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    key: ValueKey('email'),
                    validator: (value){
                      if(value!.isEmpty || !value.contains('@')){
                        return 'Incorrect Email';
                      }
                      return null;
                    },
                    onSaved: (value){
                      _email = value!;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(8.0),
                        borderSide: new BorderSide(),
                      ),
                      labelText: "Enter Email",
                      labelStyle: GoogleFonts.roboto(),
                    ),
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    key: ValueKey('password'),
                    validator: (value){
                      if(value!.isEmpty){
                        return 'Incorrect Password';
                      }
                      return null;
                    },
                    onSaved: (value){
                      _password = value!;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(8.0),
                        borderSide: new BorderSide(),
                      ),
                      labelText: "Enter Password",
                      labelStyle: GoogleFonts.roboto(),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    padding: EdgeInsets.all(5),
                      height: 70,
                      width: double.infinity,
                      child: ElevatedButton(
                        child: isloginPage? Text('Login',style:GoogleFonts.roboto(fontSize: 16),):Text('SignUp',style:GoogleFonts.roboto(fontSize: 16)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),  
                        onPressed: (){startauthentication();},)),
                  SizedBox(height: 10,),
                  Container(
                    child: TextButton(onPressed: (){
                    setState(() {
                      isloginPage = !isloginPage;
                    });
                  },child: isloginPage
                        ?Text('Not a Member',
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        color: Colors.white),
                    )
                        : Text('Already a Member',
                        style: GoogleFonts.roboto(
                            fontSize: 16,
                            color: Colors.white)
                    ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
