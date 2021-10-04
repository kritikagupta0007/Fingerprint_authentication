import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:Authentication/secondpage.dart';

void main() {
  runApp(MaterialApp(
    home: _FlutterAuthentication(),
    debugShowCheckedModeBanner: false,
  ));
}

class _FlutterAuthentication extends StatefulWidget {
  @override
  __FlutterAuthenticationState createState() => __FlutterAuthenticationState();
}

class __FlutterAuthenticationState extends State<_FlutterAuthentication> {
  LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometric;
  List<BiometricType> _availableBiometrics;
  String _authorized = "Not autherized";
  bool _isAuthenticating = false;

  Future<void> hasBiometrics() async {
    bool canCheckBiometric;
    try {
      canCheckBiometric = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      canCheckBiometric = false;
      print(e);
    }
    if (!mounted) return;
    setState(() {
      _canCheckBiometric = canCheckBiometric;
    });
  }

  Future<void> getBiometrics() async {
    List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
      availableBiometrics = <BiometricType>[];
    }
    if (!mounted) return;
    setState(() {
      _availableBiometrics = availableBiometrics;
    });
  }

  Future<void> authenticate() async {
    bool authenticated = false;

    try {
      // setState(() {
      //   _isAuthenticating = true;
      //   _authorized = 'Authenticating';
      // });
      authenticated = await auth.authenticateWithBiometrics(
        localizedReason: 'Scan Fingerprint to Authenticate',
        useErrorDialogs: true,
        stickyAuth: true,
      );
      // setState(() {
      //   _isAuthenticating = false;
      // });
    } on PlatformException catch (e) {
      print(e);
      // setState(() {
      //   _isAuthenticating = false;
      //   _authorized = "Error - ${e.message}";
      // });
      // return;
    }
    if (!mounted) return;

    setState(() {
      _authorized =
          authenticated ? "Authentication Success" : "Fail to authenticate";
      if (authenticated) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SecondPage(),
            ));
      }
      print(_authorized);
    });
  }

  @override
  void initState() {
    hasBiometrics();
    getBiometrics();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        elevation: 20,
        title: new Text(
          'Local Auth',
          style: TextStyle(fontSize: 30),
        ),
        toolbarHeight: 80,
      ),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text('Click the Authentication button to confirm'),
              ),
              Icon(Icons.arrow_drop_down),
              SizedBox(
                height: 10,
              ),
              buildAvailability(),
            ],
          ),
        ),
      ),
    ));
  }

  Widget buildAvailability() => buildButton(
      text: "Authentication",
      icon: Icons.event_available,
      onClicked: authenticate);

  Widget buildButton({
    @required String text,
    @required IconData icon,
    @required VoidCallback onClicked,
  }) =>
      RaisedButton.icon(
        icon: Icon(
          icon,
          size: 30,
        ),
        label: Text(
          text,
          style: TextStyle(fontSize: 30),
        ),
        onPressed: onClicked,
      );
}
