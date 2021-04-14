import 'package:flutter/cupertino.dart';
import 'login.dart';
import 'signout.dart';
import 'models/user.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users>(context);

    if (user == null) {
      return Login();
    } else {
      print("user");
      return Signout();
    }
  }
}
