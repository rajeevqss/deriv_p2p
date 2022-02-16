
import 'package:advert_list_demo/screens/advert/advert_page.dart';
import 'package:advert_list_demo/state/advert/advert_cubit.dart';
import 'package:advert_list_demo/state/connection/connection_cubit.dart';
import 'package:advert_list_demo/state_emitter/home_cubit_state_emitter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_deriv_bloc_manager/bloc_managers/base_bloc_manager.dart';
import 'package:flutter_deriv_bloc_manager/bloc_managers/bloc_manager.dart';
import 'package:flutter_deriv_bloc_manager/event_dispatcher.dart';

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
    home: const MyHomePage(title: 'Sample Demo'),
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
    // _connectionCubit.close();
    super.dispose();

    BlocManager.instance
        .fetch<ConnectionCubit>().api!.disconnect();
  }

  void initializeBlocs() {
    // Register Blocs.

    // BlocManager.instance.register(HomeCubit());
    BlocManager.instance.register(AdvertCubit());
    BlocManager.instance.register(ConnectionCubit());

    // Register State Emitters.
    EventDispatcher(BlocManager.instance)
        .register<AdvertCubit, HomeCubitStateEmitter>(
            (BaseBlocManager blocManager) =>
            HomeCubitStateEmitter(blocManager));
    // ..register<ContractCubit>(
    //    (BaseBlocManager blocManager) => HomeCubitStateEmitter(blocManager));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('API Sample App'),
      ),
      body: BlocBuilder<ConnectionCubit, ConnectionCubitState>(
          bloc: BlocManager.instance.fetch<ConnectionCubit>(),
          builder: (BuildContext context, ConnectionCubitState state) {
            if (state is Connected) {
              return const AdvertPage();
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
