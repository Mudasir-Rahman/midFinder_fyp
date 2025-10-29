import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constant/app_color.dart';
import '../../../domain/entity/favorite_entity.dart';
import '../../bloc/favorite_bloc.dart';
import '../../bloc/favorite_event.dart';
import '../../bloc/favorite_state.dart';

class PatientFavoritesScreen extends StatelessWidget {
  final String patientId;

  const PatientFavoritesScreen({super.key, required this.patientId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favorites'),
        backgroundColor: AppColor.kPatientPrimary,
        actions: [
          BlocBuilder<FavoriteBloc, FavoriteState>(
            builder: (context, state) {
              if (state is FavoritesLoaded && state.favorites.isNotEmpty) {
                return IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () {
                    _showClearAllDialog(context);
                  },
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
      body: BlocListener<FavoriteBloc, FavoriteState>(
        listener: (context, state) {
          if (state is FavoriteError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }

          // ✅ HANDLE SUCCESS MESSAGES FROM FavoritesLoaded
          if (state is FavoritesLoaded && state.message != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message!),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );

            // Clear the message after showing it to prevent showing again on rebuild
            Future.delayed(const Duration(milliseconds: 100), () {
              context.read<FavoriteBloc>().add(LoadFavoritesEvent(patientId: patientId));
            });
          }

          // ✅ HANDLE SEPARATE SUCCESS STATE
          if (state is FavoriteSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
        child: BlocBuilder<FavoriteBloc, FavoriteState>(
          builder: (context, state) {
            if (state is FavoriteLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is FavoriteError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading favorites',
                      style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<FavoriteBloc>().add(LoadFavoritesEvent(patientId: patientId));
                      },
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              );
            }

            if (state is FavoritesLoaded) {
              if (state.favorites.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No favorites yet',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Tap the heart icon to add favorites',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${state.favorites.length} ${state.favorites.length == 1 ? 'item' : 'items'} in favorites',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                        if (state.favorites.isNotEmpty)
                          TextButton.icon(
                            onPressed: () {
                              _showClearAllDialog(context);
                            },
                            icon: const Icon(Icons.delete_outline, size: 16),
                            label: const Text('Clear All'),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.favorites.length,
                      itemBuilder: (context, index) {
                        final favorite = state.favorites[index];
                        return _buildFavoriteItem(favorite, context);
                      },
                    ),
                  ),
                ],
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget _buildFavoriteItem(FavoriteEntity favorite, BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 2,
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: favorite.type == FavoriteType.medicine
                ? Colors.blue[50]
                : Colors.green[50],
            borderRadius: BorderRadius.circular(10),
          ),
          child: favorite.itemImage != null
              ? ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              favorite.itemImage!,
              width: 40,
              height: 40,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  favorite.type == FavoriteType.medicine
                      ? Icons.medication
                      : Icons.local_pharmacy,
                  color: favorite.type == FavoriteType.medicine
                      ? Colors.blue
                      : Colors.green,
                );
              },
            ),
          )
              : Icon(
            favorite.type == FavoriteType.medicine
                ? Icons.medication
                : Icons.local_pharmacy,
            color: favorite.type == FavoriteType.medicine
                ? Colors.blue
                : Colors.green,
          ),
        ),
        title: Text(
          favorite.itemName,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: favorite.type == FavoriteType.medicine
                    ? Colors.blue[100]
                    : Colors.green[100],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                favorite.type == FavoriteType.medicine ? 'Medicine' : 'Pharmacy',
                style: TextStyle(
                  fontSize: 12,
                  color: favorite.type == FavoriteType.medicine
                      ? Colors.blue[800]
                      : Colors.green[800],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (favorite.itemPrice != null) ...[
              const SizedBox(height: 4),
              Text(
                '\$${favorite.itemPrice!.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.green,
                ),
              ),
            ],
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.favorite, color: Colors.red),
          onPressed: () {
            context.read<FavoriteBloc>().add(
              RemoveFavoriteEvent(
                patientId: patientId,
                favoriteId: favorite.id,
              ),
            );
          },
        ),
        onTap: () {
          _showItemDetails(favorite, context);
        },
      ),
    );
  }

  void _showClearAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear All Favorites'),
          content: const Text('Are you sure you want to remove all items from your favorites? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.read<FavoriteBloc>().add(ClearFavoritesEvent(patientId: patientId));
                Navigator.of(context).pop();

                // Show immediate feedback
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('All favorites cleared'),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: const Text(
                'Clear All',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showItemDetails(FavoriteEntity favorite, BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 60,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              favorite.itemName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              favorite.type == FavoriteType.medicine ? 'Medicine' : 'Pharmacy',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
            if (favorite.itemPrice != null) ...[
              const SizedBox(height: 8),
              Text(
                'Price: \$${favorite.itemPrice!.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.read<FavoriteBloc>().add(
                    RemoveFavoriteEvent(
                      patientId: patientId,
                      favoriteId: favorite.id,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Remove from Favorites'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}