import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_crypto_bazaar/data/constant/constants.dart';
import 'package:flutter_project_crypto_bazaar/data/model/crypto.dart';
import 'package:flutter_project_crypto_bazaar/pages/crypto_list_page.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
              image: AssetImage('images/logo.png'),
            ),
            const SizedBox(
              height: 50,
            ),
            loadingAnimation
          ],
        ),
      ),
    );
  }

  void getData() async {
    var response = await Dio().get('https://api.coincap.io/v2/assets/');
    List<Crypto> cryptoList = response.data['data'].map<Crypto>((jsonMap) => Crypto.getFromJsonMap(jsonMap)).toList();

    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => CryptoPricePage(
            cryptoList: cryptoList,
          ),
        ),
        (route) {
          return false;
        },
      );
    }
  }

  final loadingAnimation = const SpinKitWave(
    color: Colors.white,
    size: 40.0,
  );
}
