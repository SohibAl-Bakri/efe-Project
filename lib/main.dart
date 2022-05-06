// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool showCurrency = true;
  bool showDialCode = false;
  bool showUniCode = false;
  bool showFlag = false;
  bool showResult = false;

  Future<List<Map<String, dynamic>>> getCountries() async {
    List<Map<String, dynamic>> fetchedData = [];
    var response = await get(Uri.parse(
        "https://countriesnow.space/api/v0.1/countries/info?returns=${showCurrency ? "currency," : ""}${showFlag ? "flag," : ""}${showUniCode ? "unicodeFlag," : ""}${showDialCode ? "dialCode," : ""}"));
    if (response.statusCode == 200) {
      var result = await jsonDecode(response.body);
      List<dynamic> data = result["data"];
      for (var i in data) {
        fetchedData.add({
          "name": i["name"],
          "currency": i["currency"],
          "unicodeFlag": i["unicodeFlag"],
          "flag": i["flag"],
          "dialCode": i["dialCode"]
        });
      }
    }
    return fetchedData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text(
          "efe Project",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text("Currency"),
                    SizedBox(
                      width: 20.w,
                      child: CheckboxListTile(
                          value: showCurrency,
                          onChanged: (bool? value) {
                            setState(() {
                              showCurrency = value!;
                            });
                          }),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text("DialCode"),
                    SizedBox(
                      width: 20.w,
                      child: CheckboxListTile(
                          value: showDialCode,
                          onChanged: (bool? value) {
                            setState(() {
                              showDialCode = value!;
                            });
                          }),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text("Uni Code"),
                    SizedBox(
                      width: 20.w,
                      child: CheckboxListTile(
                          value: showUniCode,
                          onChanged: (bool? value) {
                            setState(() {
                              showUniCode = value!;
                            });
                          }),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text("Flag"),
                    SizedBox(
                      width: 20.w,
                      child: CheckboxListTile(
                          value: showFlag,
                          onChanged: (bool? value) {
                            setState(() {
                              showFlag = value!;
                            });
                          }),
                    ),
                  ],
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.cyan),
                  ),
                  onPressed: () {
                    setState(() {
                      showResult = !showResult;
                    });
                  },
                  child: const Text(
                    "Get Countries",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
                Visibility(
                  visible: showResult,
                  child: Container(
                    padding: const EdgeInsets.all((5)),
                    child: FutureBuilder(
                      future: getCountries(),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                        if (snapshot.hasData) {
                          List<CountriesCard> cards = [];
                          for (var c in snapshot.data!) {
                            var country = CountriesCard(
                              name: c["name"] ?? "name",
                              unicodeFlag: c["unicodeFlag"] ?? "uniflag",
                              flag: c["flag"] ?? "flag",
                              currency: c["currency"] ?? "curr",
                              dialcode: c["dialCode"] ?? "dialCode",
                              showCurrency: showCurrency,
                              showDialCode: showDialCode,
                              showFlag: showFlag,
                              showUniCode: showUniCode,
                            );
                            cards.add(country);
                          }
                          return Column(
                            children: cards,
                          );
                        }
                        {
                          return const CircularProgressIndicator();
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CountriesCard extends StatelessWidget {
  final name;
  final currency;
  final unicodeFlag;
  final flag;
  final dialcode;
  final showCurrency;
  final showDialCode;
  final showUniCode;
  final showFlag;

  const CountriesCard(
      {this.showUniCode,
      this.showCurrency,
      this.showDialCode,
      this.showFlag,
      this.currency,
      this.name,
      this.flag,
      this.dialcode,
      this.unicodeFlag,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Center(
        child: Card(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 10,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 75.h,
            decoration: BoxDecoration(
              color: Colors.cyan,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    child: Text(
                      name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child:
                              showUniCode ? Text(unicodeFlag) : const Text(""),
                        ),
                        Expanded(
                          child: showCurrency
                              ? Text("  " + currency)
                              : const Text(""),
                        ),
                        Expanded(
                          child: showDialCode ? Text(dialcode) : const Text(""),
                        ),
                        Expanded(
                          child: showFlag
                              ? SvgPicture.network(
                                  flag.toString().trimRight(),
                                  width: 20.w,
                                )
                              : const Text(""),
                        ),
                      ],
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
}
