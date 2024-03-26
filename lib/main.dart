import 'package:bus_finder/firebase_options.dart';
import 'package:bus_finder/pages/add_bus.dart';
import 'package:bus_finder/pages/busses.dart';
import 'package:bus_finder/providers/snackbarprovider.dart';
import 'package:bus_finder/widgets/textformfield.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SnackBarProvider()),
      ],
      child: const BusFinderApp(),
    ),
  );
}

class BusFinderApp extends StatelessWidget {
  const BusFinderApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SnackBarProvider()),
      ],
      builder: (context, child) {
        return MaterialApp(
          title: 'BusWay',
          theme: ThemeData(primarySwatch: Colors.deepPurple),
          home: const BusFinderHomePage(),
        );
      },
    );
  }
}

class BusFinderHomePage extends StatefulWidget {
  const BusFinderHomePage({super.key});

  @override
  _BusFinderHomePageState createState() => _BusFinderHomePageState();
}

class _BusFinderHomePageState extends State<BusFinderHomePage> {
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var time = [
    'Morning  6AM - 12PM',
    'AfterNoon  12PM - 4PM',
    'Evening  4PM - 8PM',
    'Night  8PM - 2AM',
    'Dawn  2AM - 6AM',
  ];
  String initialTime = 'Morning  6AM - 12PM';

//   Future<void> fetchBuses() async {
//   String from = _fromController.text;
//   String to = _toController.text;
//   TimeOfDay time = _timeController.text;

//   // Convert time to a DateTime object
//   DateTime dateTime = DateTime(
//     DateTime.now().year,
//     DateTime.now().month,
//     DateTime.now().day,
//     time.hour,
//     time.minute,
//   );

//   // Convert DateTime to a Timestamp object
//   Timestamp timestamp = Timestamp.fromDate(dateTime);

//   // Fetch buses for the given route and time from Firebase
//   QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//       .collection('buses')
//       .where('from', isEqualTo: from)
//       .where('to', isEqualTo: to)
//       .where('time', isEqualTo: timestamp)
//       .get();

//   // Process the fetched buses
//   // ...
// }

  @override
  Widget build(BuildContext context) {
    final snackBarProvider =
        Provider.of<SnackBarProvider>(context, listen: false);
    snackBarProvider.setContext(context);
    return ChangeNotifierProvider<SnackBarProvider>.value(
      value: snackBarProvider,
      child: Scaffold(
        backgroundColor: Colors.deepPurple.shade200,
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Container(
                        child: Lottie.asset(
                          'lib/assets/lottie/bus.json',
                        ),
                      ),
                    ),
                    const Positioned(
                      top: 40,
                      left: 30,
                      child: Text(
                        'BusWay',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 45),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      CustomTextField(
                        controller: _fromController,
                        hintText: 'From',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            final snackBarProvider =
                                Provider.of<SnackBarProvider>(context,
                                    listen: false);
                            snackBarProvider.showSnackBar(
                              'Please fill in both "from" and "to" fields.',
                            );
                            return 'Please fill in this field';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _fromController.text = value!;
                        },
                        snackBarProvider: snackBarProvider,
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      CustomTextField(
                        controller: _toController,
                        hintText: 'To',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            final snackBarProvider =
                                Provider.of<SnackBarProvider>(context,
                                    listen: false);
                            snackBarProvider.showSnackBar(
                              'Please fill in both "from" and "to" fields.',
                            );
                            return 'Please fill in this field';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _toController.text = value!;
                        },
                        snackBarProvider: snackBarProvider,
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.deepPurple.shade400,
                        ),
                        width: double.infinity,
                        height: 60,
                        child: Center(
                          child: DropdownButton(
                              value: initialTime,
                              icon: const Padding(
                                padding: EdgeInsets.only(left: 100),
                                child: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.white,
                                ),
                              ),
                              items: time.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(
                                    items,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  initialTime = newValue!;
                                });
                              },
                              dropdownColor: Colors.deepPurple.shade400,
                              underline: const SizedBox()),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        height: 60,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_fromController.text.isNotEmpty &&
                                _toController.text.isNotEmpty) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FindBus(),
                                ),
                              );
                            } else {
                              final snackBarProvider =
                                  Provider.of<SnackBarProvider>(context,
                                      listen: false);
                              snackBarProvider.showSnackBar(
                                'Please fill in both "FROM" and "TO" fields.',
                              );
                            }
                          },
                          child: const Text(
                            'Find Buses',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddBusses(),
                              ),
                            );
                          },
                          child: Text('Add Busses'))
                    ],
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
