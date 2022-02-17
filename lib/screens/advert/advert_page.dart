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
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AdvertCubit(api: BlocProvider.of<ConnectionCubit>(context).api),
      child: const AdvertPage(),
    );
  }
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<AdvertCubit>(context).getAdvertList(0, _selectedValue!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
              Divider(),
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
                  var time = list[index].createdTime!.toInt();
                  var date = DateTime.fromMillisecondsSinceEpoch(time*1000);
                  return Container(
                    margin: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Advertise Name: ${list[index].advertiserDetails?.name!}'),
                        Text('Date: ${TimeUtil().formatDateTime(date,TimeUtil.outputLogHistoryDateFormat)}'),
                        Text('Country: ${list[index].country}'),
                        Text('Currency: ${list[index].accountCurrency}'),
                        Text('Price: ${list[index].priceDisplay}'),
                        Text('Type: ${list[index].counterpartyType}'),
                        Text('Description: ${list[index].description}'),
                      ],
                    ),
                  );
                },
                separatorBuilder: (buildContext, index) {
                  return const Divider();
                },
                itemCount: list.length);
          }),
        ),
      ],
    );
  }

  Widget _search() {
    return BlocConsumer<AdvertCubit, AdvertCubitState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Stack(
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
        );
      },
    );
  }

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
