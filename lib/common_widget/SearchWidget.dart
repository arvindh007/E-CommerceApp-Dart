import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();

  SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.search),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'What would you like to buy?',
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
