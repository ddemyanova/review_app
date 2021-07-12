import 'package:connectivity/connectivity.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future <bool> checkLogin() async{
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  print(sharedPreferences.getString("token"));
  if(sharedPreferences.getString("token")!=null) {
    return true;
  }
  else {
    return false;
  }
}
Future <bool> checkConn() async{
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {
    return false;
  }
  else
  {
    return true;
  }
}