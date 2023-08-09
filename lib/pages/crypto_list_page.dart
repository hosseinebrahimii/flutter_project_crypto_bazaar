import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_crypto_bazaar/data/constant/constants.dart';

import '../data/model/crypto.dart';

class CryptoPricePage extends StatefulWidget {
  const CryptoPricePage({super.key, required this.cryptoList});

  final List<Crypto> cryptoList;

  @override
  State<CryptoPricePage> createState() => _CryptoPricePageState();
}

class _CryptoPricePageState extends State<CryptoPricePage> {
  List<Crypto>? cryptoList;
  List<Crypto>? maincryptolist;
  @override
  void initState() {
    super.initState();
    cryptoList = widget.cryptoList;
    maincryptolist = widget.cryptoList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _getAppBar(),
      backgroundColor: blackColor,
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: '  لطفا رمز ارز مورد نظر را وارد کنید',
                hintTextDirection: TextDirection.rtl,
                hintStyle: const TextStyle(
                  fontFamily: 'mr',
                  color: Colors.white,
                  fontSize: 16,
                ),
                fillColor: greenColor,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
              ),
              style: const TextStyle(fontSize: 18),
              onChanged: (value) {
                _search(value);
              },
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              backgroundColor: greenColor,
              color: blackColor,
              onRefresh: _getData,
              child: ListView.builder(
                itemBuilder: ((context, index) {
                  return _getListTile(cryptoList![index]);
                }),
                itemCount: cryptoList!.length,
              ),
            ),
          ),
        ],
      )),
    );
  }

  PreferredSizeWidget _getAppBar() {
    return AppBar(
      title: const Text(
        'کریپتوبازار',
        style: TextStyle(fontFamily: 'mr'),
      ),
      centerTitle: true,
      automaticallyImplyLeading: false,
      backgroundColor: blackColor,
    );
  }

  Widget _getListTile(Crypto crypto) {
    return ListTile(
      title: Text(
        crypto.name,
        style: TextStyle(
          color: (crypto.changePercent24Hr.isNegative) ? redColor : greenColor,
          fontSize: 18,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      subtitle: Text(
        crypto.symbol,
        style: const TextStyle(color: greyColor, fontSize: 16),
      ),
      leading: Container(
        alignment: Alignment.center,
        height: 50,
        width: 50,
        child: Text(
          crypto.rank.toString(),
          style: const TextStyle(color: greyColor, fontSize: 18),
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${crypto.priceUsd.toStringAsFixed(5)} \$',
                style: const TextStyle(color: greyColor, fontSize: 16),
              ),
              Text(
                '${crypto.changePercent24Hr.toStringAsFixed(5)} %',
                style: TextStyle(color: _getPriceColor(crypto.changePercent24Hr), fontSize: 15),
              ),
            ],
          ),
          const SizedBox(
            width: 10,
          ),
          Container(
            width: 50,
            height: 80,
            alignment: Alignment.center,
            child: _getTrailingIcon(crypto.changePercent24Hr),
          ),
        ],
      ),
    );
  }

  Widget _getTrailingIcon(double priceChange) {
    return (priceChange < 0)
        ? const Icon(
            Icons.trending_down,
            color: redColor,
            size: 25,
          )
        : const Icon(
            Icons.trending_up,
            color: greenColor,
            size: 25,
          );
  }

  Color _getPriceColor(double priceChange) {
    return (priceChange < 0) ? redColor : greenColor;
  }

  Future<void> _getData() async {
    var response = await Dio().get('https://api.coincap.io/v2/assets/');
    setState(() {
      cryptoList = response.data['data'].map<Crypto>((jsonMap) => Crypto.getFromJsonMap(jsonMap)).toList();
    });
  }

  void _search(String searchKey) {
    cryptoList = maincryptolist;
    List<Crypto> searchList = [];
    searchList = cryptoList!.where((element) => element.name.toLowerCase().contains(searchKey)).toList();
    setState(() {
      cryptoList = searchList;
    });
  }
}
