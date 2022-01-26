import 'dart:convert';

import 'package:cryptocontrol/themes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  final OurTheme _theme = OurTheme();
  bool isVisible = false;
  late List<bool> isVisibleList;
  List coinsList = [];
  String coinSearch = "";

  @override
  void initState() {
    super.initState();
    fetchCoins();
  }

  fetchCoins() async {
    var url = 'https://api.coingecko.com/api/v3/coins/';
    var snapshot = await get(Uri.parse(url));
    if (snapshot.statusCode == 200) {
      var items = json.decode(snapshot.body);
      setState(() {
        coinsList = items;
      });
    } else {
      setState(() {
        coinsList = [];
      });
    }
    isVisibleList = List<bool>.generate(coinsList.length, (i) => isVisible);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: _theme.primaryColor,
          body: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 16,
                  ),
                  _buildSearchCoinTF(),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 16,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                      itemCount: coinsList.length,
                      itemBuilder: (context, index) {
                        if (coinSearch.isEmpty) {
                          return Column(
                            children: [
                              _buildCoinCard(index),
                              _buildDropDown(index),
                            ],
                          );
                        } else if (coinsList[index]['id'] == coinSearch) {
                          return Column(
                            children: [
                              _buildCoinCard(index),
                              _buildDropDown(index),
                            ],
                          );
                        } else if (coinsList[index]['symbol'] == coinSearch) {
                          return Column(
                            children: [
                              _buildCoinCard(index),
                              _buildDropDown(index),
                            ],
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildSearchCoinTF() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: TextFormField(
        onChanged: (value) {
          coinSearch = value;
        },
        controller: _controller,
        style: GoogleFonts.roboto(
          textStyle: TextStyle(color: _theme.primaryColor),
        ),
        decoration: InputDecoration(
          hintText: "Search Coin",
          hintStyle: GoogleFonts.roboto(
            textStyle: TextStyle(color: _theme.primaryColor),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          fillColor: Colors.white,
          filled: true,
          suffixIcon: IconButton(
            onPressed: () {
              coinSearch = _controller.text;
              setState(() {
                _controller.clear();
              });
              FocusScope.of(context).unfocus();
            },
            icon: Icon(
              Icons.search,
              size: 35,
              color: _theme.primaryColor,
            ),
          ),
        ),
      ),
    );
  }

  _buildCoinCard(int index) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 30, 35, 0),
      child: Container(
        decoration: BoxDecoration(
            color: _theme.primaryColor,
            boxShadow: [
              BoxShadow(
                  color: Colors.black,
                  blurRadius: 3.0,
                  offset: Offset.fromDirection(7, 3)),
            ],
            borderRadius: isVisibleList[index]
                ? const BorderRadius.only(
                    topLeft: Radius.circular(10), topRight: Radius.circular(10))
                : BorderRadius.circular(10)),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 20, 0),
              child: CircleAvatar(
                child: Image.network(
                  coinsList[index]['image']['large'],
                ),
                radius: 25,
              ),
            ),
            Text(
              coinsList[index]['symbol'].toString().toUpperCase(),
              style: GoogleFonts.roboto(
                  textStyle: TextStyle(color: _theme.secondaryColor),
                  fontSize: 28),
            ),
            const Spacer(),
            Text(
              (coinsList[index]['market_data']
                              ['price_change_percentage_1h_in_currency']['usd']
                          .toString()
                          .substring(0, 1) ==
                      '-')
                  ? coinsList[index]['market_data']
                              ['price_change_percentage_1h_in_currency']['usd']
                          .toString()
                          .substring(0, 5) +
                      "%"
                  : "+" +
                      coinsList[index]['market_data']
                              ['price_change_percentage_1h_in_currency']['usd']
                          .toString()
                          .substring(0, 4) +
                      "%",
              style: GoogleFonts.roboto(
                  textStyle: TextStyle(color: _theme.secondaryColor),
                  fontSize: 20,
                  color: (coinsList[index]['market_data']
                                      ['price_change_percentage_1h_in_currency']
                                  ['usd']
                              .toString()
                              .substring(0, 1) ==
                          '-')
                      ? const Color(0xFFDA7474)
                      : const Color(0xFF74DAA3)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 10, 20),
              child: IconButton(
                  icon: isVisibleList[index]
                      ? Icon(
                          Icons.keyboard_arrow_up_rounded,
                          color: _theme.secondaryColor,
                          size: 36,
                        )
                      : Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: _theme.secondaryColor,
                          size: 36,
                        ),
                  onPressed: () {
                    isVisibleList[index] = !isVisibleList[index];
                    setState(() {});
                  }),
            ),
          ],
        ),
      ),
    );
  }

  _buildDropDown(int index) {
    return Visibility(
      visible: isVisibleList[index],
      child: Padding(
        padding: const EdgeInsets.fromLTRB(40, 0, 35, 10),
        child: Container(
          decoration: BoxDecoration(
              color: _theme.primaryColor,
              boxShadow: [
                BoxShadow(
                    color: Colors.black,
                    blurRadius: 3.0,
                    offset: Offset.fromDirection(7.1, 3)),
              ],
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10))),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
            child: Row(
              children: [
                Column(
                  children: [
                    Text(
                      (coinsList[index]['id']
                                          .toString()
                                          .substring(0, 1)
                                          .toUpperCase() +
                                      coinsList[index]['id']
                                          .toString()
                                          .substring(1))
                                  .length >
                              8
                          ? coinsList[index]['id']
                                  .toString()
                                  .substring(0, 1)
                                  .toUpperCase() +
                              coinsList[index]['id'].toString().substring(1, 9)
                          : coinsList[index]['id']
                                  .toString()
                                  .substring(0, 1)
                                  .toUpperCase() +
                              coinsList[index]['id'].toString().substring(1),
                      style: GoogleFonts.roboto(
                          textStyle: TextStyle(color: _theme.secondaryColor),
                          fontSize: 34),
                    ),
                    TextButton(
                        onPressed: () {},
                        child: Text(
                          "View Performance",
                          style: GoogleFonts.roboto(
                              textStyle: const TextStyle(color: Colors.white),
                              fontSize: 15,
                              decoration: TextDecoration.underline),
                        ))
                  ],
                ),
                const Spacer(),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 6),
                      child: Text(
                        "Current Value",
                        style: GoogleFonts.roboto(
                            textStyle: TextStyle(color: _theme.secondaryColor),
                            fontSize: 18),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              "₹",
                              style: GoogleFonts.roboto(
                                  textStyle:
                                      TextStyle(color: _theme.secondaryColor),
                                  fontSize: 18),
                            ),
                            Text(
                              "\$",
                              style: GoogleFonts.roboto(
                                  textStyle:
                                      TextStyle(color: _theme.secondaryColor),
                                  fontSize: 18),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              coinsList[index]['market_data']['current_price']
                                      ['inr']
                                  .toString(),
                              style: GoogleFonts.roboto(
                                  textStyle:
                                      const TextStyle(color: Colors.white),
                                  fontSize: 18),
                            ),
                            Text(
                              coinsList[index]['market_data']['current_price']
                                      ['usd']
                                  .toString(),
                              style: GoogleFonts.roboto(
                                  textStyle:
                                      const TextStyle(color: Colors.white),
                                  fontSize: 18),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
