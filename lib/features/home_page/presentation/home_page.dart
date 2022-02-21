import 'package:advert_list_demo/features/advert_list/presentation/pages/advert_page.dart';
import 'package:advert_list_demo/features/home_page/state/connection/connection_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        title: const Text('API Sample App'),
      ),
      body: BlocBuilder<ConnectionCubit, ConnectionCubitState>(
          builder: (BuildContext context, ConnectionCubitState state) {
        if (state is Connected) {
          return const Advert();
        } else if (state is Disconnected) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCenterText('Disconnected'),
              ElevatedButton(onPressed: (){
                BlocProvider.of<ConnectionCubit>(context).connect();
              }, child: const Text('Connect'))
            ],
          );
        } else {
          return _buildCenterText('Connecting');
        }
      }));

  Widget _buildCenterText(String text) => Center(
        child: Column(
          children: [Text(text), const CircularProgressIndicator()],
        ),
      );
}
