import 'package:advert_list_demo/state/advert/advert_cubit.dart';
import 'package:advert_list_demo/state/advert/models/advert_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_deriv_bloc_manager/bloc_managers/bloc_manager.dart';

class AdvertPage extends StatefulWidget {
  const AdvertPage({Key? key}) : super(key: key);

  @override
  State<AdvertPage> createState() => _AdvertPageState();
}

class _AdvertPageState extends State<AdvertPage> {
  final List<AdvertList> list = [];
  final ScrollController _scrollController = ScrollController();
  int count = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocManager.instance.fetch<AdvertCubit>().getAdvertList(0);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdvertCubit, AdvertCubitState>(
        bloc: BlocManager.instance.fetch<AdvertCubit>(),
        builder: (BuildContext context, AdvertCubitState state) {
          if (state is AdvertCubitLoadedState) {
            list.addAll(state.p2pAdvertList!.list!);
            return ListView.separated(
                controller: _scrollController
                  ..addListener(() {
                    if (_scrollController.offset ==
                        _scrollController.position.maxScrollExtent) {
                      // BlocManager.instance
                      //     .fetch<AdvertCubit>()
                      //     .getAdvertList(count);
                      // count = count + 10;
                    }
                  }),
                itemBuilder: (buildContext, index) {
                  return Text(
                      '${state.p2pAdvertList!.list![index].description}');
                },
                separatorBuilder: (buildContext, index) {
                  return const Divider();
                },
                itemCount: list.length);
          } else if (state is AdvertCubitLoadingState) {
            return const CircularProgressIndicator();
          } else if (state is AdvertError) {
            return Text(state.message!);
          } else {
            return Container();
          }
        });
  }
}
