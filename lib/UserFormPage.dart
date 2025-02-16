import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onlineclothingstoreapp/api/UserApi.dart';

class UserFormPage extends StatefulWidget
{
  @override
  State<UserFormPage> createState() => _UserFormPageState();

  Map<String, dynamic>? user;

  UserFormPage({Map<String, dynamic>? user}){
    if(user!=null){
      this.user=user;
    }
  }
}

class _UserFormPageState extends State<UserFormPage> {
  var userName=new TextEditingController();
  var email=new TextEditingController();
  var password=new TextEditingController();
  var contactNo=new TextEditingController();
  var isPasswordVisible=false;
  var isValid=true;

  var formKey=GlobalKey<FormState>();

  Map<String, dynamic> user=new Map();

  @override
  void initState(){
    super.initState();

    if(widget.user!=null){
      this.user=widget.user!;

      userName.text=this.user!["userName"];
      email.text=this.user!["email"];
      contactNo.text=this.user!["contactNo"];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
        title: Text("User Form"),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Icon(Icons.account_box_outlined, color: Colors.white),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
                  children: [
                    Form(
                        key: formKey,
                        child: Column(
                          children: [
                            Container(
                              child: TextFormField(controller: userName,
                                validator: (value) {
                                  if(value==""){
                                    return "Enter Username";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: Colors.brown.shade700),),
                                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: Colors.brown.shade700),),
                                    focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: Colors.red.shade900),),
                                    errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: Colors.red.shade900),),
                                    errorStyle: TextStyle(fontSize: 15),
                                    labelText: "Enter Username",
                                    floatingLabelStyle: TextStyle(color: Colors.brown.shade700),
                                    hintText: "Username",
                                    prefixIcon: Icon(Icons.abc, color: Colors.brown.shade700)
                                ),
                              ),
                              margin: EdgeInsets.fromLTRB(20,10,20,10),
                            ),
                            Container(
                              child: TextFormField(controller: email,
                                validator: (value) {
                                  RegExp emailRegExp=RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

                                  if(value==""){
                                    return "Enter Email";
                                  }
                                  else if(!(emailRegExp.hasMatch(value!))){
                                    return "Enter valid Email";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: Colors.brown.shade700),),
                                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: Colors.brown.shade700),),
                                    focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: Colors.red.shade900),),
                                    errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: Colors.red.shade900),),
                                    errorStyle: TextStyle(fontSize: 15),
                                    labelText: "Enter Email",
                                    floatingLabelStyle: TextStyle(color: Colors.brown.shade700),
                                    hintText: "Email",
                                    prefixIcon: Icon(Icons.email_outlined, color: Colors.brown.shade700)
                                ),
                              ),
                              margin: EdgeInsets.fromLTRB(20,10,20,10),
                            ),
                            Container(
                              child: TextFormField(controller: password,
                                onTap: () {
                                  setState(() {

                                  });
                                },
                                validator: (value) {
                                  if (value==null || value=="") {
                                    return 'Enter Password';
                                  }
                                  else {
                                    if (value.trim()==0) {
                                      return 'Enter valid Password';
                                    }
                                    else {
                                      return null;
                                    }
                                  }
                                },
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: Colors.brown.shade700),),
                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: Colors.brown.shade700),),
                                  focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: Colors.red.shade900),),
                                  errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: Colors.red.shade900),),
                                  errorStyle: TextStyle(fontSize: 15),
                                  labelText: "Enter Password",
                                  prefixIcon: Icon(Icons.password_rounded,color: Colors.brown.shade700,),
                                  suffixIcon: InkWell(
                                      child: isPasswordVisible?Icon(Icons.visibility_off_outlined,color: Colors.brown.shade700,):Icon(Icons.visibility_outlined,color: Colors.brown.shade700,),
                                      onTap: () {
                                        setState(() {
                                          isPasswordVisible=!isPasswordVisible;
                                        });
                                      }
                                  ),
                                  floatingLabelStyle: TextStyle(color: Colors.brown.shade700,),
                                  hintText: "Password",
                                ),
                                obscureText: !isPasswordVisible,
                                obscuringCharacter: "*",
                              ),
                              margin: EdgeInsets.fromLTRB(20,10,20,10),
                            ),
                            Container(
                              child: TextFormField(controller: contactNo,
                                validator: (value) {
                                  RegExp contactRegExp=RegExp(r'^(\+91[\s-]?)?[0]?[6789]\d{9}$|^\d{5}[-\s]?\d{6}$');

                                  if(value==""){
                                    return "Enter ContactNo";
                                  }
                                  else if(!(contactRegExp.hasMatch(value!))){
                                    return "Enter valid ContactNo";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: Colors.brown.shade700),),
                                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: Colors.brown.shade700),),
                                    focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: Colors.red.shade900),),
                                    errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: Colors.red.shade900),),
                                    errorStyle: TextStyle(fontSize: 15),
                                    labelText: "Enter Contact number",
                                    floatingLabelStyle: TextStyle(color: Colors.brown.shade700),
                                    hintText: "ContactNo",
                                    prefixIcon: Icon(Icons.call, color: Colors.brown.shade700)
                                ),
                              ),
                              margin: EdgeInsets.fromLTRB(20,10,20,10),
                            ),
                            InkWell(
                              onTap: () async {
                                if(formKey.currentState!.validate()){
                                  this.user!['userID']=this.user['userID']??"5";
                                  this.user!['userName']=userName.text;
                                  this.user!['email']=email.text;
                                  this.user!['password']=password.text;
                                  this.user!['contactNo']=contactNo.text;
                                  this.user!['addressID']="2";

                                  var response = widget.user==null
                                                    ? await UserApi().addUser(this.user!)
                                                    : await UserApi().updateUser(this.user!, this.user!['userID']);

                                  if(response){
                                    showCupertinoDialog(context: context, builder: (context) {
                                      return CupertinoAlertDialog(
                                        title: Text("SUCCESS!!",style: TextStyle(color: Colors.green),),
                                        content: Text("User updated successfully!!"),
                                        actions: [
                                          TextButton(onPressed: ()  {
                                            Navigator.pop(context);
                                            setState(() {
                                              Navigator.of(context).pop(true);
                                            });
                                          }, child: Text("Ok"))
                                        ],
                                      );
                                    },);
                                  }

                                  else{
                                    showCupertinoDialog(context: context, builder: (context) {
                                      return CupertinoAlertDialog(
                                        title: Text("FAILURE!!",style: TextStyle(color: Colors.red),),
                                        content: Text("Error occured!! Try Agan!!"),
                                        actions: [
                                          TextButton(onPressed: ()  {
                                            Navigator.pop(context);
                                            setState(() {
                                              Navigator.of(context).pop(true);
                                            });
                                          }, child: Text("Ok"))
                                        ],
                                      );
                                    },);
                                  }
                                }

                                else{
                                  setState(() {
                                    isValid=false;
                                  });
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(color: Colors.brown.shade700,borderRadius: BorderRadius.circular(20)),
                                width: MediaQuery.of(context).size.width,
                                height: 50,
                                child: Center(
                                  child: Text("SUBMIT",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: MediaQuery.of(context).size.height*0.025
                                    ),
                                  ),
                                ),
                                margin: EdgeInsets.fromLTRB(20,50,20,10),
                              ),
                            ),
                            !isValid?Text("INVALID VALUES",
                              style: TextStyle(
                                  color: Colors.red.shade900,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold
                              ),
                            ):Text(""),
                          ],
                        )
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                ),
        ),
      ),
      backgroundColor: Colors.brown.shade50,
    );
  }
}