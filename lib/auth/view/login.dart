import 'package:flutter/material.dart';
import 'package:mesibo_chat_assignment/utility/mesibo_service.dart';
import 'package:mesibo_chat_assignment/utility/model/user_model.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool  mLoginDone = false;
  bool  userLoginLoader1 = false;
  bool  userLoginLoader2 = false;
  MesiboService mesiboService = MesiboService();
  String remoteUser = "";
  User user1 = User("fec49e925239782ef1971fe93c2d92ff6bd8951399837211fe774ba63dza2d19b487b8", 'imran@mesibo.com');
  User user2 = User("35970c6f080a5321b5c8dfdaae40259eea83c9f581b9939931e114ba63ezaeab3f8fd1c", 'hussain@mesibo.com');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
              child: Text('Login as user -1 from one device  and as user-2 from another deivice')),
          !userLoginLoader1?ElevatedButton(
            child: Text("Login as User-1"),
            onPressed: _loginUser1,
          ):CircularProgressIndicator(
            strokeWidth: 2,
            color:Colors.black,
          ),
          !userLoginLoader2?ElevatedButton(
            child: Text("Login as User-2"),
            onPressed: _loginUser2,
          ):CircularProgressIndicator(
            strokeWidth: 2,
            color:Colors.black,
          ),
        ],
      ),
    ),);
  }

  Future<void> _loginUser1() async {
    setState(() {
      userLoginLoader1=true;
    });
    if(null ==  MesiboService.mesibo) {
      showAlert("Mesibo NULL", "mesibo null");
      return;
    }
    if(mLoginDone) {
      setState(() {
        userLoginLoader1=false;
      });
      showAlert("Failed", "You have already initiated login. If the connection status is not 1, check the token and the package name/bundle ID");
      return;
    }
    mLoginDone = true;
    await mesiboService.initMesibo(user1.token);
    remoteUser = user2.address;
    await Future.delayed(Duration(seconds: 4));
    setState(() {
      userLoginLoader1=false;
    });
    mesiboService.showUserList();
  }
  Future<void> _loginUser2() async {
    setState(() {
      userLoginLoader2=true;
    });
    if(mLoginDone) {
      setState(() {
        userLoginLoader2=false;
      });
      showAlert("Failed", "You have already initiated login. If the connection status is not 1, check the token and the package name/bundle ID");
      return;
    }
    mLoginDone = true;
    await mesiboService.initMesibo(user2.token);
    remoteUser = user1.address;
    await Future.delayed(Duration(seconds: 4));
    setState(() {
      userLoginLoader2=false;
    });
    mesiboService.showUserList();
  }

  void showAlert(String title, String body) {
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(body),
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
