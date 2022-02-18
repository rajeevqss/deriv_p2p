import 'dart:async';

import 'package:advert_list_demo/state/advert/advert_cubit.dart';
import 'package:advert_list_demo/state/advert/models/advert_response.dart';
import 'package:advert_list_demo/state/connection/connection_cubit.dart';
import 'package:advert_list_demo/util/time_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Advert extends StatelessWidget {
  const Advert({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocProvider(
      create: (BuildContext context) =>
          AdvertCubit(api: BlocProvider.of<ConnectionCubit>(context).api),
      child: const AdvertPage(),
    );
}

class AdvertPage extends StatefulWidget {
  const AdvertPage({Key? key}) : super(key: key);

  @override
  State<AdvertPage> createState() => _AdvertPageState();
}

class _AdvertPageState extends State<AdvertPage> {
  final List<AdvertList> list = [];
  final ScrollController _scrollController = ScrollController();
  int count = 0;
  String? _selectedValue = 'buy';
  StreamSubscription<void>? _periodicFetchdata;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<AdvertCubit>(context).getAdvertList(0, _selectedValue!);
    _periodicFetchdata?.cancel();
    _periodicFetchdata = Stream<void>.periodic(
      const Duration(minutes: 1),
    ).listen((_) {
      BlocProvider.of<AdvertCubit>(context).getAdvertList(0, _selectedValue!);
    });
  }
@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _periodicFetchdata?.cancel();
  }
  @override
  Widget build(BuildContext context) => Column(
      children: [
        Container(
            margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
            decoration: const BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
              ),
            ),
            child: _search()),
        Container(
          margin: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Type:'),
              const SizedBox(
                width: 50,
              ),
              DropdownButton(
                key: ValueKey('dropdown'),
                hint: const Text('Please select type'),
                // Not necessary for Option 1
                value: _selectedValue,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedValue = newValue;
                    FocusScope.of(context).requestFocus(FocusNode());
                    BlocProvider.of<AdvertCubit>(context)
                        .getAdvertList(0, _selectedValue!);
                  });
                },
                items: ['buy', 'sell']
                    .map((String location) => DropdownMenuItem(
                          child: Text(location),
                          value: location,
                        ))
                    .toList(),
              ),
              const Divider(),
            ],
          ),
        ),
        Expanded(
          child: BlocBuilder<AdvertCubit, AdvertCubitState>(
              builder: (BuildContext context, AdvertCubitState state) {
            if (state is AdvertCubitLoadedState) {
              list.clear();
              list.addAll(state.advertList!);
              print(
                  '------------------list data ${list.length}-------------------');
            } else if (state is AdvertCubitLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AdvertError) {
              return Text(state.message!);
            } else {
              return Container();
            }

            return ListView.separated(
                controller: _scrollController
                  ..addListener(() {
                    if (_scrollController.position.pixels ==
                        _scrollController.position.maxScrollExtent) {
                      print('------------------scroll-------------------');
                      // count = count + 11;
                      // BlocProvider.of<AdvertCubit>(context)
                      //     .getAdvertList(count);

                    }
                  }),
                itemBuilder: (buildContext, index) {
                  // if(index==list.length){
                  //   return const Center(child: CircularProgressIndicator());
                  // }
                  print(
                      '-----------------advert page data -${state.advertList?.length}-------------------');
                  final int time = list[index].createdTime!.toInt();
                  final DateTime date = DateTime.fromMillisecondsSinceEpoch(time*1000);
                  return Container(
                    margin: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Id: ${list[index].id}'),
                        Text(
                            'Advertise Name: ${list[index].advertiserDetails?.name}'),
                        Text('Advertise order id: ${list[index].advertiserDetails?.id}'),
                        Text('Advertise completed order count: ${list[index].advertiserDetails?.completedOrdersCount}'),
                        Text('Advertise total completion rate: ${list[index].advertiserDetails?.totalCompletionRate}'),
                        Text('Date: ${TimeUtil().formatDateTime(date,TimeUtil.outputLogHistoryDateFormat)}'),
                        Text('Country: ${list[index].country}'),
                        Text('Currency: ${list[index].accountCurrency}'),
                        Text('Price: ${list[index].priceDisplay}'),
                        Text('rate: ${list[index].rateDisplay}'),
                        Text('max order amount: ${list[index].maxOrderAmountLimitDisplay}'),
                        Text('min order amount: ${list[index].minOrderAmountLimitDisplay}'),
                        Text('Type: ${list[index].counterpartyType}'),
                        Text('Payment method: ${list[index].paymentMethod}'),
                        Text('local currency: ${list[index].localCurrency}'),
                        Text('Description: ${list[index].description}'),
                      ],
                    ),
                  );
                },
                separatorBuilder: (BuildContext buildContext, index) => const Divider(),
                itemCount: list.length);
          }),
        ),
      ],
    );

  Widget _search() => BlocConsumer<AdvertCubit, AdvertCubitState>(
      listener: (BuildContext context, AdvertCubitState state) {},
      builder: (BuildContext context, AdvertCubitState state) => Stack(
          alignment: const Alignment(0.7, 0),
          children: [
            TextFormField(
              textInputAction: TextInputAction.go,
              onFieldSubmitted: (value) {
                // if (value.isEmpty) {
                //   ShowMessage.showToast(context, 'Please search post');
                //   return;
                // }
                //
                // BlocProvider.of<PostListBloc>(context, listen: false)
                //     .add(GetSearchContentOnlineEvent(value));
              },
              onChanged: (content) {
                context.read<AdvertCubit>().search(content);
              },
              decoration: InputDecoration(
                hintText: 'Search post',
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SvgPicture.asset(
                    'assets/feather_search.svg',
                  ),
                ),
                suffixIcon: GestureDetector(
                  onTapDown: (TapDownDetails details) {
                    _showFilterPopupMenu(
                      context,
                      details.globalPosition,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SvgPicture.asset('assets/sort.svg',
                        width: 5, height: 5),
                  ),
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: const BorderSide(
                    color: Colors.grey,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: const BorderSide(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ],
        ),
    );

  void _showFilterPopupMenu(BuildContext context, Offset offset) async {
    double left = offset.dx;
    double top = offset.dy;
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(left, top, 0, 0),
      items: [
        PopupMenuItem<String>(
            child: const Text('Price'),
            value: 'Price',
            onTap: () {
              BlocProvider.of<AdvertCubit>(context).sortPrice();
            }),
        PopupMenuItem<String>(
            child: const Text('Date'),
            value: 'Date',
            onTap: () {
              BlocProvider.of<AdvertCubit>(context).sortDate();
            })
      ],
      elevation: 8.0,
    );
  }
}
