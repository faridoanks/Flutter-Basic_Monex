import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:monex/core/theme/app_colors.dart';
import 'package:monex/features/savings/saving_model.dart';
import 'package:monex/features/savings/savings_provider.dart';
import 'package:monex/features/transactions/transaction_helper.dart';

class SavingsPage extends ConsumerWidget {
  const SavingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savings = ref.watch(loadSavingProvider);

    final categories = Categories();

    final total = savings.fold<int>(
      0,
      (sum, saving) => sum + saving.currentAmount,
    );
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Savings",
          style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
      ),

      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),

        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Current Savings",
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 36),
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(
                        0xff1d4ed8,
                      ), // Warna biru solid sesuai desain gambar
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xff1d4ed8).withOpacity(0.15),
                          blurRadius: 30,
                          spreadRadius: 8,
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "Rp $total",
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 44),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.neutralsWhite,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 24,
                          top: 32,
                          right: 24,
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Your Goals",
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.more_horiz,
                                    color: AppColors.neutralsDark1,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 32),
                            Expanded(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: savings.length,
                                itemBuilder: (context, index) {
                                  SavingModel currentSaving = savings[index];
                                  double progress = 0.0;
                                  if (currentSaving.targetAmount > 0) {
                                    progress =
                                        currentSaving.currentAmount /
                                        currentSaving.targetAmount;
                                  }
                                  final saving = savings[index];
                                  return ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: AppColors.neutralsSoftGrey2,

                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: const EdgeInsets.all(8),
                                      child: SvgPicture.asset(
                                        categories.getCategoryIcon(
                                          saving.icon ?? "",
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      saving.title,
                                      style: GoogleFonts.inter(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    subtitle: Column(
                                      children: [
                                        ClipRRect(
                                          child: LinearProgressIndicator(
                                            value: progress > 1.0
                                                ? 1.0
                                                : progress,
                                                minHeight: 6,
                                                backgroundColor: AppColors.neutralsSoftGrey2,
                                                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryBrand),
                                          ),
                                        ),
                                        SizedBox(height: 6),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Rp ${saving.currentAmount}",
                                              style: GoogleFonts.inter(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              "Rp ${saving.targetAmount}",
                                              style: GoogleFonts.inter(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
