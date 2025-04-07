import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:women/life_savor/hospital.dart';
import 'package:women/life_savor/bus_station.dart';
import 'package:women/life_savor/pharmacy.dart';
import 'package:women/life_savor/police.dart';

class LiveSafe extends StatelessWidget {
  const LiveSafe({super.key});

  static Future<void> openMap(String location) async {
    String googleUrl = 'https://www.google.com/maps/search/$location';
    final Uri url = Uri.parse(googleUrl);
    try {
      await launchUrl(url);
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'Something went wrong! call emergency numbers');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(child: PoliceStationCard(onMapFunction: openMap)),
          Flexible(child: HospitalCard(onMapFunction: openMap)),
          Flexible(child: PharmacyCard(onMapFunction: openMap)),
          Flexible(child: BusStationCard(onMapFunction: openMap)),
        ],
      ),
    );
  }
}
