import 'package:flutter/material.dart';

class PoliceStationCard extends StatelessWidget {
  final Function? onMapFunction;
  const PoliceStationCard({Key? key, this.onMapFunction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                onMapFunction!('Police Stations near me');
              },
              child: Card(
                elevation: 3,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),

                child: Container(
                  height: 50,
                  width: 50,
                  child: Center(
                    child: Image.asset(
                      'assets/police.png',
                      height: 32,
                    ), //Image.asset
                  ), //Center
                ), //Container
              ),
            ),
            Text(
              '\t Police Stations',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ));
  }
}
