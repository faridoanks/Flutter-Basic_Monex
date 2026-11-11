import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monex/core/theme/app_colors.dart';
import 'package:monex/widgets/custom_add_card.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Add",
          style: GoogleFonts.inter(
            color: AppColors.neutralsDark1,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.neutralsWhite,
        leading: IconButton(
          onPressed: () => context.go('/dashboard'),
          icon: const Icon(Icons.arrow_back, color: AppColors.neutralsDark1),
        ),
      ),
      backgroundColor: AppColors.neutralsSoftGrey2,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 24,
              right: 24,
              top: 32,
              bottom: 32,
            ),
            child: Row(
              children: [
                CustomAddCard(onTap: () {}, isAddIconButton: true),
                SizedBox(width: 16),
                CustomAddCard(
                  onTap: () {
                    context.go('/custom-add-card?type=income');
                  },
                  isAddIconButton: false,
                  title: "Add Income",
                ),
                SizedBox(width: 16),
                CustomAddCard(
                  onTap: () {
                    context.go('/custom-add-card?type=expense');
                  },
                  isAddIconButton: false,
                  title: "Add Expense",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
