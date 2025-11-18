import 'package:flutter/material.dart';
import 'package:peekit_app/utils/app_colors.dart';

class SearchBarWidget extends StatelessWidget {
  final VoidCallback onTap;
  const SearchBarWidget({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Row(
            children: [
              const SizedBox(width: 16),
              Icon(Icons.search, color: AppColors.textHint),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Search News',
                  style: TextStyle(color: AppColors.textHint, fontSize: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Icon(Icons.tune_rounded, color: AppColors.textHint),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
