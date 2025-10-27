import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              'Hai, Nama!',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Divider(color: Colors.black),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.all(8),
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      boxShadow: [
                        BoxShadow(blurRadius: 12, color: Colors.black),
                      ],
                    ),
                    child: TextButton(
                      onPressed: () {
                        debugPrint('DPR');
                        setState(() {});
                      },
                      child: Text('DPR', style: TextStyle(fontSize: 20)),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(8),
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.cyanAccent,
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      boxShadow: [
                        BoxShadow(blurRadius: 12, color: Colors.black),
                      ],
                    ),
                    child: TextButton(
                      onPressed: () {
                        debugPrint('DPD');
                        setState(() {});
                      },
                      child: Text('DPD', style: TextStyle(fontSize: 20)),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(8),
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      boxShadow: [
                        BoxShadow(blurRadius: 12, color: Colors.black),
                      ],
                    ),
                    child: TextButton(
                      onPressed: () {
                        debugPrint('DPRD');
                        setState(() {});
                      },
                      child: Text('DPRD', style: TextStyle(fontSize: 20)),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(8),
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.limeAccent,
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      boxShadow: [
                        BoxShadow(blurRadius: 12, color: Colors.black),
                      ],
                    ),
                    child: TextButton(
                      onPressed: () {
                        debugPrint('Presiden & Wakil Presiden');
                        setState(() {});
                      },
                      child: Text(
                        'Presiden\n'
                        '&\n'
                        'Wakil Presiden',
                        style: TextStyle(fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
