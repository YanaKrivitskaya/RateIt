import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateit/helpers/colors.dart';
import 'package:rateit/helpers/route_constants.dart';
import 'package:rateit/helpers/styles.dart';
import 'package:rateit/helpers/widgets.dart';
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
            return Scaffold(
              appBar: AppBar(
                elevation: 0,
                title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Text('Hello, ', style:appTextStyle(fontSize: accentFontSize)),
                  InkWell(
                    child: Text('${state.user?.name}!', style:appTextStyle(color: ColorsPalette.boyzone, fontSize: accentFontSize)),
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
                  Navigator.pushNamed(context, createCollectionRoute);
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
                    return Column(children: [
                      Center(child: Text("Your collections", style: appTextStyle(fontSize: smallHeaderFontSize),)),
                      SingleChildScrollView(
                      child: Column(children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: collections.length,
                          itemBuilder: (context, position){
                            final collection = collections[position];
                            return  Container(
                                margin: EdgeInsets.all(borderPadding),
                                //width: width60,
                                height: height30,
                                child: InkWell(
                                    child: collectionListItem(collection, context),
                                    onTap: (){
                                      /*TripDetailsArguments args = new TripDetailsArguments(isRoot: true, tripId: trip.id!);
                                      Navigator.pushNamed(context, tripDetailsRoute, arguments: args).then((value) => {
                                        context.read<TripsBloc>().add(GetAllTrips())
                                      });*/
                                    }
                                )
                            );},
                        )]),
                    )]);
                  } else {
                    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Text("You have no collections. \nClick the '+' button to add one!")
                      ],),

                    ],);
                  }
              }));
          }
        });
  }

  Widget collectionListItem(Collection collection, BuildContext context) => Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        Container(
          padding: EdgeInsets.only(bottom: imageCoverPadding),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0), // Adjust for rounded corners
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                collection.color ?? ColorsPalette.boyzone, // Start color
                ColorsPalette.algalFuel
              ],
            ),
          ),
          child: collection.imageSrc != null ? Image.memory(collection.imageSrc!) : Container()
        ),
        Positioned(
            bottom: 0,
            child: Material(
                elevation: 10.0,
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color:  ColorsPalette.white
                ,
                child: Container(
                    margin: EdgeInsets.all(sizerHeightMd),
                    width: width60,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.center ,children: [
                      Text(collection.name!, style: appTextStyle(fontSize: accentFontSize, weight: FontWeight.bold))
                    ]))))
      ]
  );
}
