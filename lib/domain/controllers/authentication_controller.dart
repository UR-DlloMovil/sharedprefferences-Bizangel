import 'package:get/get.dart';
import 'package:f_authentication_template/data/repositories/local_preferences.dart';

class AuthenticationController extends GetxController {
  LocalPreferences lp = LocalPreferences();

  var _logged = false.obs;

  bool get logged => _logged.value;

  void setLogged(bool l) {
    _logged.value = l;
    update();
  }

  AuthenticationController() {
    init();
  }

  void init() async {
    _logged.value = await lp.retrieveData<bool>("logged") ?? false;
    //_logged.value = false;
    setLogged(false);
  }

  Future<bool> registerUser(String user, String pass) async {
    await lp.storeData<String>("email", user);
    await lp.storeData<String>("password", pass);
    return Future.value(true);
  }

  Future<bool> login(user, password) async {
    String userT = await lp.retrieveData<String>("email") ?? "";
    String passwordT = await lp.retrieveData<String>("password") ?? "";
    //print("$userT $passwordT $user $password");
    if (userT == user && passwordT == password) {
      await lp.storeData<bool>("logged", true);
      //_logged.value = true;
      setLogged(true);
    } else {
      await lp.storeData<bool>("logged", false);
      //_logged.value = false;
      setLogged(false);
    }
    return Future.value(_logged.value);
  }

  Future<bool> signup(user, password) async {
    String userT = await lp.retrieveData<String>("email") ?? "";
    if (userT != user) {
      await registerUser(user, password);
      //_logged.value = false;
      //setLogged(false);
      return Future.value(true);
    }

    return Future.value(false);
  }

  Future<bool> logout() async {
    await lp.storeData<bool>("logged", false);
    //_logged.value = false;
    setLogged(false);
    return Future.value(true);
  }
}
