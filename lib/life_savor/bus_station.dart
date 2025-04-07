import 'package:flutter/material.dart';

class BusStationCard extends StatelessWidget {
  final Function? onMapFunction;
  const BusStationCard({Key? key, this.onMapFunction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                onMapFunction!('Bus Stops near me');
              },
              child: Card(
                elevation: 3,
                color: const Color.fromARGB(255, 33, 24, 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),

                child: Container(
                  height: 50,
                  width: 50,
                  child: Center(
                    child: Image.asset(
                      'assets/bus.png',
                      height: 32,
                    ), //Image.asset
                  ), //Center
                ), //Container
              ),
            ),
            Text(
              '\t \t Bus Stations',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ));
  }
}
