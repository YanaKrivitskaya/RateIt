import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateit/helpers/colors.dart';
import 'package:rateit/helpers/route_constants.dart';
import 'package:rateit/helpers/styles.dart';
import 'package:rateit/helpers/widgets.dart';
import 'package:rateit/main.dart';
import 'package:rateit/models/collection.model.dart';
import 'package:rateit/views/profile/cubit/profile_cubit.dart';

import 'cubit/home_cubit.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return  BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state){
          if(state is ProfileInitial || state is ProfileStateLoading){
            return loadingWidget(ColorsPalette.algalFuel);
          }else{
            return BlocListener<HomeCubit, HomeState>(
                listener: (context, state){
                  if(state is HomeStateLoading){
                    var duration = Duration(seconds: 3);
                    globalScaffoldMessenger.currentState!
                      ..hideCurrentSnackBar()
                      ..showSnackBar(customSnackBar(SnackBarState.loading, null, duration));
                  }
                  if(state is HomeStateSuccess){
                    globalScaffoldMessenger.currentState!
                        .hideCurrentSnackBar();
                  }
                  if(state is HomeStateError){
                    var duration = Duration(days: 1);
                    globalScaffoldMessenger.currentState!
                      ..hideCurrentSnackBar()
                      ..showSnackBar(customSnackBar(SnackBarState.error, state.error, duration));
                  }
                },
                child: BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state){
                    return Scaffold(
                        appBar: AppBar(
                            elevation: 0,
                            title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                              Text('Hello, ', style:appTextStyle(fontSize: accentFontSize)),
                              InkWell(
                                child: Text('${BlocProvider.of<ProfileCubit>(context).state.user?.name}!', style:appTextStyle(color: ColorsPalette.boyzone, fontSize: accentFontSize)),
                                onTap: (){
                                  /*Navigator.pushNamed(context, profileRoute).then((value) =>
                      BlocProvider.of<ProfileBloc>(context)..add(GetProfile())
                      );*/
                                },
                              )
                            ]),
                            backgroundColor: ColorsPalette.white
                        ),
                        floatingActionButton: FloatingActionButton(
                          onPressed: () {
                            Navigator.pushNamed(context, editCollectionRoute).then((value)
                            {
                              if(value != null && value is int){
                                context.read<HomeCubit>().getCollectionBasic(value);
                              }
                            });
                          },
                          tooltip: 'Add new collection',
                          backgroundColor: ColorsPalette.algalFuel,
                          child: Icon(Icons.add, color: ColorsPalette.white),
                        ),
                        body: BlocBuilder<HomeCubit, HomeState>(
                            builder: (context, state){
                              if(state is HomeInitial || state is HomeStateLoading){
                                return loadingWidget(ColorsPalette.algalFuel);
                              }else if(state is HomeStateSuccess && state.collections.isNotEmpty){
                                var collections = state.collections;
                                return Container(
                                    padding: EdgeInsets.only(bottom: formPaddingHeight),
                                    child: Column(children: [
                                      Center(child: Text("Your collections", style: appTextStyle(fontSize: smallHeaderFontSize))),
                                      SizedBox(height: formPaddingHeight),
                                      Expanded(child:
                                      SingleChildScrollView(
                                          child: Column(mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center, children: [
                                                GridView.count(
                                                    crossAxisCount: 2,
                                                    shrinkWrap: true,
                                                    scrollDirection: Axis.vertical,
                                                    physics: NeverScrollableScrollPhysics(),
                                                    children: List.generate(collections.length,(i){
                                                      return InkWell(
                                                          child: collectionListItem(collections[i], context),
                                                          onTap: () {
                                                            Navigator.pushNamed(context, viewCollectionRoute, arguments: collections[i].id);
                                                          }
                                                      );
                                                      //return collectionListItem(collections[i], context);
                                                    })
                                                )
                                              ])
                                      )
                                      )
                                    ])
                                );
                              } else {
                                return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                    Text("You have no collections. \nClick the '+' button to add one!")
                                  ])
                                ]);
                              }
                            }));
                  })
            );
          }
        });
  }

  Widget collectionListItem(Collection collection, BuildContext context) => Column(
      children: [
        SizedBox(
          width: width30,
          height: width30,
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0), // Adjust for rounded corners
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    collection.colorPrimary ?? ColorsPalette.boyzone, // Start color
                    collection.colorAccent ?? ColorsPalette.algalFuel
                  ],
                ),
              ),
              child: Icon(collection.icon ?? Icons.collections, color: Colors.white, size: iconSize)
          ),
        ),
        Text(collection.name!, style: appTextStyle(fontSize: accentFontSize, weight: FontWeight.bold))
      ]
  );
}
