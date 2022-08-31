import 'dart:convert';
import 'package:http/http.dart';
import 'price_screen.dart';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'TRY',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const apiKey = "********************";

class CoinData {
  Future getCoinData(selectedCurrency) async {
    Map<String, String> cryptoPrices = {};
    for (var crypto in cryptoList) {
      Response response = await get(Uri.parse(
          "https://rest.coinapi.io/v1/exchangerate/$crypto/$selectedCurrency?apikey=${apiKey}"));

      if (response.statusCode == 200) {
        String data = response.body;
        var coinData = jsonDecode(data);
        try {
          String date = coinData['time'];
          String base = coinData['asset_id_base'];
          String quote = coinData['asset_id_quote'];
          double rate = coinData['rate'];
          cryptoPrices[crypto] = rate.toStringAsFixed(0);
        } catch (e) {
          print(e);
        }
      } else {
        print(response.statusCode);
      }
    }
    return cryptoPrices;
  }
}
