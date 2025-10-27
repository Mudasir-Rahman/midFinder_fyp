import 'package:flutter/material.dart';

const Color kPrimaryLight = Color(0xFF3949AB);
const Color kPrimaryDark = Color(0xFF1A237E);

class LoadingStateWidget extends StatelessWidget {
  const LoadingStateWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [kPrimaryLight, kPrimaryDark],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: kPrimaryLight.withOpacity(0.5),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 5,
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            'Loading Your Dashboard',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: kPrimaryDark,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Preparing your pharmacy data...',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}