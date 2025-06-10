import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateit/views/home/cubit/home_cubit.dart';
import 'package:rateit/views/profile/cubit/profile_cubit.dart';

import 'home.view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeCubit>(
          create: (_) => HomeCubit()..getUserCollections(),
        ),
        BlocProvider<ProfileCubit>(
          create: (_) => ProfileCubit()..getProfile(),
        ),
      ],
      child: HomeView()
    );
  }
}
