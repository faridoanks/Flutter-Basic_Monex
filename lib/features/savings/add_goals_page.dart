import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monex/core/theme/app_colors.dart';
import 'package:monex/features/savings/saving_model.dart';
import 'package:monex/features/savings/savings_provider.dart';
import 'package:monex/widgets/custom_button.dart';
import 'package:monex/widgets/custom_calendar_picker.dart';
import 'package:monex/widgets/custom_dropdownbutton.dart';
import 'package:monex/widgets/custom_icon_picker.dart';
import 'package:monex/widgets/custom_textfield.dart';

class AddGoalsPage extends ConsumerStatefulWidget {
  const AddGoalsPage({super.key});

  @override
  ConsumerState<AddGoalsPage> createState() => _AddGoalsPageState();
}

class _AddGoalsPageState extends ConsumerState<AddGoalsPage> {
  late final TextEditingController _goalTitleController;
  late final TextEditingController _amountController;
  late final TextEditingController _targetAmountController;

  late final FocusNode _goalTitleFocusNode;
  late final FocusNode _amountFocusNode;
  late final FocusNode _targetAmountFocusNode;

  final List<String> contributionTypes = [
    "Daily",
    "Weekly",
    "Monthly",
    "Yearly",
  ];

  DateTime? deadLine;

  @override
  void initState() {
    super.initState();
    _goalTitleController = TextEditingController();
    _amountController = TextEditingController();
    _targetAmountController = TextEditingController();

    _goalTitleFocusNode = FocusNode();
    _amountFocusNode = FocusNode();
    _targetAmountFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _goalTitleController.dispose();
    _amountController.dispose();
    _targetAmountController.dispose();

    _goalTitleFocusNode.dispose();
    _amountFocusNode.dispose();
    _targetAmountFocusNode.dispose();
    super.dispose();
  }

  String pickIcon(String firstTitle) {
    final title = firstTitle.toLowerCase().trim();
    final iconDictionary = {
      'assets/icons/bike.svg': [
        'bike',
        'motorcycle',
        'car',
        'scooter',
        'vespa',
        'bicycle',
      ],
      'assets/icons/bill.svg': [
        'bill',
        'electricity',
        'water',
        'tax',
        'installment',
        'invoice',
      ],
      'assets/icons/food.svg': [
        'food',
        'restaurant',
        'cafe',
        'diet',
        'snack',
        'meal',
      ],
      'assets/icons/shopping.svg': [
        'shopping',
        'clothes',
        'mall',
        'buy',
        'purchase',
      ],
      'assets/icons/rent.svg': [
        'rent',
        'boarding room',
        'lease',
        'house',
        'apartment',
      ],
      'assets/icons/salary.svg': ['salary', 'bonus', 'payday', 'income'],
      'assets/icons/movie.svg': ['movie', 'cinema', 'theater', 'watch'],
    };

    final titleText = title.toLowerCase().trim();
    final splitTitle = titleText.split(" ");

    for (var eachTitle in splitTitle) {
      if (eachTitle.length < 3) continue;

      final consonantWords = eachTitle.replaceAll(RegExp(r'[aiueo]'), '');

      for (var entry in iconDictionary.entries) {
        final pathSvgIcon = entry.key;
        final titleExample = entry.value;

        for (var titleKeywords in titleExample) {
          final consonantTitle = titleKeywords.replaceAll(
            RegExp(r'[aiueo]'),
            '',
          );
          if (consonantWords == consonantTitle) {
            return pathSvgIcon;
          }
        }
      }
    }
    final reserveIcon = [
      'assets/icons/cashback.svg',
      'assets/icons/price.svg',
      'assets/icons/dashboard_active.svg',
    ];

    return reserveIcon[title.length % reserveIcon.length];
  }

  void _submitGoal() {
    ref.read(savingErrorProvider.notifier).state = false;
    final selectedIcon = pickIcon(_goalTitleController.text);

    if (_goalTitleController.text.trim().isEmpty) {
      ref.read(savingErrorProvider.notifier).state = true;
      ref.read(savingErrorMessageProvider.notifier).state =
          "Goal title cannot be empty.";
      return;
    }
    if (_amountController.text.trim().isEmpty) {
      ref.read(savingErrorProvider.notifier).state = true;
      ref.read(savingErrorMessageProvider.notifier).state =
          "Amount cannot be empty.";
      return;
    }
    if (_targetAmountController.text.trim().isEmpty) {
      ref.read(savingErrorProvider.notifier).state = true;
      ref.read(savingErrorMessageProvider.notifier).state =
          "Target amount cannot be empty.";
      return;
    }

    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final title = _goalTitleController.text;
    final currentAmount = int.parse(_amountController.text);
    final targetAmount = int.parse(_targetAmountController.text);
    final createdAt = DateTime.now();
    final deadline = deadLine;
    final isCompleted = false;

    final _newSaving = SavingModel(
      id: id,
      title: title,
      currentAmount: currentAmount,
      targetAmount: targetAmount,
      createdAt: createdAt,
      deadline: deadline,
      isCompleted: isCompleted,
      icon: selectedIcon,
    );

    ref.read(loadSavingProvider.notifier).createSaving(_newSaving);

    context.go('/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    final hasError = ref.watch(savingErrorProvider);
    final errorMessage = ref.watch(savingErrorMessageProvider);
    final currentContributionType = ref.watch(contributionTypeProvider);

    return Scaffold(
      backgroundColor: AppColors.neutralsSoftGrey2,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Add Goals",
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Goal Title"),
            const SizedBox(height: 12),
            CustomTextfield(
              control: _goalTitleController,
              hint: "Enter goal title",
              prefix: null,
              focus: _goalTitleFocusNode,
              isPassword: false,
              hasError: hasError,
            ),
            const SizedBox(height: 24),
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: hasError
                  ? Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryRedLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error, color: AppColors.error),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              errorMessage,
                              style: GoogleFonts.inter(
                                color: AppColors.error,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),

            if (hasError) const SizedBox(height: 16),

            _buildSectionTitle("Amount"),
            const SizedBox(height: 12),
            CustomTextfield(
              control: _amountController,
              hint: "Enter amount",
              prefix: null,
              focus: _amountFocusNode,
              isPassword: false,
              hasError: hasError,
            ),
            const SizedBox(height: 24),

            _buildSectionTitle("Target Amount"),
            const SizedBox(height: 12),

            CustomTextfield(
              control: _targetAmountController,
              hint: "Enter target amount",
              prefix: null,
              focus: _targetAmountFocusNode,
              isPassword: false,
              hasError: hasError,
            ),
            const SizedBox(height: 24),

            _buildSectionTitle("Contribution Type"),
            const SizedBox(height: 16),
            CustomDropdownbutton(
              value: currentContributionType,
              onChanged: (value) =>
                  ref.read(contributionTypeProvider.notifier).state = value!,
              itemsValue: contributionTypes,
            ),

            const SizedBox(height: 28),

            _buildSectionTitle("Deadline"),
            const SizedBox(height: 12),
            CustomCalendarPicker(
              selectedDate: deadLine,
              onDateSelected: (newDate) => setState(() => deadLine = newDate),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24.0),
        child: CustomButton(onPress: _submitGoal, text: "ADD GOAL"),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(
        color: AppColors.neutralsGrey2,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
