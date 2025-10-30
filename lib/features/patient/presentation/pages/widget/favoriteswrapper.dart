import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../init_dependence.dart';
import '../../bloc/favorite_bloc.dart';
import '../../bloc/favorite_event.dart';


class FavoritesWrapper extends StatelessWidget {
  final String patientId;
  final Widget child;

  const FavoritesWrapper({
    super.key,
    required this.patientId,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        // ✅ FIXED: Use service locator to get the FavoriteBloc
        return sl<FavoriteBloc>()..add(LoadFavoritesEvent(patientId: patientId));
      },
      child: child,
    );
  }
}