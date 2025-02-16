import 'package:flutter/material.dart';
import 'package:onlineclothingstoreapp/ListPage.dart';
import 'package:onlineclothingstoreapp/UserFormPage.dart';
import 'package:onlineclothingstoreapp/api/UserApi.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget
{
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var name=new TextEditingController();
  var password=new TextEditingController();
  var isPasswordVisible=false;
  var isValid=true;
  var remember=false;

  var formKey=GlobalKey<FormState>();

  Future<void> setUser(int userID, String username,String password,bool remember) async {
    SharedPreferences pref=await SharedPreferences.getInstance();

    pref.setInt("UserID", userID);
    pref.setString("Username", username);
    pref.setString("Password", password);
    pref.setBool("Remember", remember);
  }

  Future<int> isValidUser(String username, String password) async {
    List<dynamic> users=await UserApi().getUsers();

    for(var user in users){
      var userMap=user as Map<String, dynamic> ;

      if (
          (
            (userMap['userName'] == username) ||
            (userMap['email'] == username ) ||
            (userMap['contactNo'] == username )
          )
          && userMap['password'] == password) {
        return user['userID'];
      }
    };

    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
                children: [
                  Card(
                    elevation: 5,
                    shadowColor: Colors.brown.shade700,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(width: 3,color: Colors.brown.shade700),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset("assets/NBLogo.jpg",
                          fit: BoxFit.fill,
                          height: 100,
                          width: 150,
                        ),
                      ),
                    ),
                  ),
                  Form(
                      key: formKey,
                      child: Column(
                        children: [
                          Container(
                            child: TextFormField(controller: name,
                              validator: (value) {
                                // RegExp emailRegExp=RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                                // RegExp contactRegExp=RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');
          
                                if(value==""){
                                  return "Enter username";
                                }
                                // else if(!(emailRegExp.hasMatch(value!) || contactRegExp.hasMatch(value))){
                                //   return "Enter valid Email, ContactNo";
                                // }
                                return null;
                              },
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: Colors.brown.shade700),),
                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: Colors.brown.shade700),),
                                  focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: Colors.red.shade900),),
                                  errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(color: Colors.red.shade900),),
                                  errorStyle: TextStyle(fontSize: 15),
                                  labelText: "Enter Username, Email, or Contact number",
                                  floatingLabelStyle: TextStyle(color: Colors.brown.shade700),
                                  hintText: "Username",
                                  prefixIcon: Icon(Icons.email_outlined, color: Colors.brown.shade700)
                              ),
                            ),
                            margin: EdgeInsets.all(20),
                          ),
                          Container(
                            child: TextFormField(controller: password,
                              onTap: () {
                                setState(() {
          
                                });
                              },
                              validator: (value) {
                                // RegExp passwordRegExp = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
          
                                if (value==null || value=="") {
                                  return 'Enter password';
                                }
                                else {
                                  // if (!passwordRegExp.hasMatch(value!)) {
                                  //   return 'Enter valid password';
                                  // }
                                  if (value.trim()==0) {
                                    return 'Enter valid password';
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
                            margin: EdgeInsets.fromLTRB(20,0,20,0),
                          ),
                          CheckboxListTile(
                            side: BorderSide(color: Colors.brown.shade700,),
                            // visualDensity: VisualDensity.maximumDensity,
                            title: Text("REMEMBER ME?",
                              style: TextStyle(
                                  color: Colors.brown.shade700,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold
                              ),
                              textAlign: TextAlign.right,
                            ),
                            activeColor: Colors.brown.shade700,
                            contentPadding: EdgeInsets.fromLTRB(0,30,30,0),
                            value: remember,
                            onChanged: (value) {
                              setState(() {
                                remember=value!;
                              });
                            },
                          ),
                          !isValid?Text("INVALID USERNAME & PASSWORD",
                            style: TextStyle(
                                color: Colors.red.shade900,
                                fontSize: 15,
                                fontWeight: FontWeight.bold
                            ),
                          ):Text(""),
                          InkWell(
                            onTap: () async {
                              if(formKey.currentState!.validate()){
                                int validuserID= await isValidUser(name.text, password.text);
                                if(validuserID!=0){
                                  setState(() {
                                    isValid=true;
                                    setUser(validuserID,name.text, password.text,remember);
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => ListPage(validuserID),));
                                  });
                                }
                                else{
                                  setState(() {
                                    isValid=false;
                                  });
                                }
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
                              margin: EdgeInsets.all(20),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => UserFormPage(user: null),));
                            },
                            child: Container(
                              decoration: BoxDecoration(color: Colors.brown.shade700,borderRadius: BorderRadius.circular(20)),
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              child: Center(
                                child: Text("Create Account",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: MediaQuery.of(context).size.height*0.025
                                  ),
                                ),
                              ),
                              margin: EdgeInsets.fromLTRB(20,10,20,10),
                            ),
                          )
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