
import 'package:advert_list_demo/screens/advert/advert_page.dart';
import 'package:advert_list_demo/state/connection/connection_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Sample Demo',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      // This is the theme of your application.
      //
      // Try running your application with "flutter run". You'll see the
      // application has a blue toolbar. Then, without quitting the app, try
      // changing the primarySwatch below to Colors.green and then invoke
      // "hot reload" (press "r" in the console where you ran "flutter run",
      // or simply save your changes to "hot reload" in a Flutter IDE).
      // Notice that the counter didn't reset back to zero; the application
      // is not restarted.
      primarySwatch: Colors.blue,
    ),
    home: BlocProvider(
      create: (context) => ConnectionCubit(),
      child: const MyHomePage(title: 'Sample Demo'),
    ) ,
  );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late ConnectionCubit connectionCubit;
  @override
  void initState() {
    super.initState();

    initializeBlocs();
  }

  @override
  void dispose() {
    super.dispose();
    BlocProvider.of<ConnectionCubit>(context).disConnect();

  }

  void initializeBlocs() {
    BlocProvider.of<ConnectionCubit>(context).connect();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('Deriv P2P Sample App'),
      ),
      body: BlocBuilder<ConnectionCubit, ConnectionCubitState>(
          builder: (BuildContext context, ConnectionCubitState state) {
            if (state is Connected) {
              return const Advert();
            } else if(state is Disconnected){
              return _buildCenterText('Disconnected');
            }
            else {
              return _buildCenterText('Connecting');
            }
          }));

  Widget _buildCenterText(String text) => Center(
    child: Column(
      children: [Text(text), const CircularProgressIndicator()],
    ),
  );
}
