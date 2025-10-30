import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entity/favorite_entity.dart';
import '../../bloc/favorite_bloc.dart';
import '../../bloc/favorite_event.dart';
import '../../bloc/favorite_state.dart';

class FavoriteButton extends StatelessWidget {
  final String patientId;
  final String itemId;
  final String itemName;
  final FavoriteType type;
  final String? itemImage;
  final double? itemPrice;
  final double? size;

  const FavoriteButton({
    super.key,
    required this.patientId,
    required this.itemId,
    required this.itemName,
    required this.type,
    this.itemImage,
    this.itemPrice,
    this.size = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteBloc, FavoriteState>(
      builder: (context, state) {
        bool isFavorite = false;

        if (state is FavoritesLoaded) {
          isFavorite = state.favorites.any(
                  (favorite) => favorite.itemId == itemId && favorite.type == type
          );
        }

        return IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : Colors.grey,
            size: size,
          ),
          onPressed: () {
            context.read<FavoriteBloc>().add(
              ToggleFavoriteEvent(
                patientId: patientId,
                itemId: itemId,
                itemName: itemName,
                type: type,
                itemImage: itemImage,
                itemPrice: itemPrice,
              ),
            );
          },
        );
      },
    );
  }
}