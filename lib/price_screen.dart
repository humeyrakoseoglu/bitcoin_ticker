// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:bitcoin_ticker/coin_data.dart';

import 'coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  var cryptocurrency;
  String selectedCurrency = 'AUD';
  late CoinData coinData;
  String coinValue = '?';

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (int i = 0; i < currenciesList.length; i++) {
      var currency = currenciesList[i];
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropDownItems.add(newItem);
    }
    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropDownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value!;
          getCoinData();
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getCoinData();
  }

  Widget? getPicker() {
    if (Platform.isIOS) {
      return Center(child: iOSPicker());
    } else if (Platform.isAndroid) {
      return androidDropdown();
    }
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      var newItem = Text(
        currency,
        style: TextStyle(color: Colors.white),
      );
      pickerItems.add(newItem);
    }
    return CupertinoPicker(
      backgroundColor: Color.fromARGB(255, 17, 60, 80),
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        print(selectedIndex);
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
          getCoinData();
        });
      },
      children: pickerItems,
    );
  }

  Map<String, String> coinValues = {};
  void updateCard() {
    setState(() {});
  }

  bool isWaiting = false;

  void getCoinData() async {
    isWaiting = true;
    try {
      var data = await CoinData().getCoinData(selectedCurrency);
      isWaiting = false;
      setState(() {
        coinValues = data;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('💰 Coin Ticker 💰'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          CryptoCard(
            coinValue: coinValues['BTC'] ?? '?',
            selectedCurrency: selectedCurrency,
            cryptoCurrency: 'BTC',
          ),
          CryptoCard(
            coinValue: coinValues['ETH'] ?? '?',
            selectedCurrency: selectedCurrency,
            cryptoCurrency: 'ETH',
          ),
          CryptoCard(
            coinValue: coinValues['LTC'] ?? '?',
            selectedCurrency: selectedCurrency,
            cryptoCurrency: 'LTC',
          ),
          Container(
              height: 150.0,
              alignment: Alignment.center,
              padding: EdgeInsets.only(bottom: 30.0),
              color: Color.fromARGB(255, 17, 60, 80),
              child: iOSPicker()
              // ya da getPicker() yerine => Platform.isIOS ? iOSPicker() : androidDropdown(),
              ),
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  const CryptoCard({
    Key? key,
    required this.coinValue,
    required this.selectedCurrency,
    required this.cryptoCurrency,
  }) : super(key: key);

  final String coinValue;
  final String selectedCurrency;
  final String cryptoCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Color.fromARGB(255, 17, 60, 80),
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $cryptoCurrency = $coinValue $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
