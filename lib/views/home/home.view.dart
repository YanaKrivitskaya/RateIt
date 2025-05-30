import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateit/helpers/colors.dart';
import 'package:rateit/helpers/styles.dart';
import 'package:rateit/helpers/widgets.dart';
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
                  //Navigator.pushNamed(context, tripStartPlanningRoute).then((value) => context.read<TripsBloc>().add(GetAllTrips()));
                },
                tooltip: 'Add new collection',
                backgroundColor: ColorsPalette.algalFuel,
                child: Icon(Icons.add, color: ColorsPalette.white),
            ));
              }
            }
        );
  }
}
