import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monex/core/theme/app_colors.dart';
import 'package:monex/features/auth/auth_provider.dart';
import 'package:monex/features/savings/savings_provider.dart';
import 'package:monex/features/transactions/transaction_helper.dart';
import 'package:monex/features/transactions/transaction_model.dart';
import 'package:monex/features/transactions/transaction_provider.dart';
import 'package:monex/widgets/custom_button.dart';
import 'package:monex/widgets/custom_dropdownbutton.dart';
import 'package:monex/widgets/custom_table_calendar.dart';
import 'package:monex/widgets/custom_textfield.dart';
import 'package:table_calendar/table_calendar.dart';

class AddTransactionPage extends ConsumerStatefulWidget {
  final String type;
  const AddTransactionPage({super.key, required this.type});

  @override
  ConsumerState<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends ConsumerState<AddTransactionPage> {
  DateTime focusedDay = DateTime.now();
  late DateTime selectedDay = DateTime.now();
  final DateTime firstDay = DateTime(2020);
  final DateTime lastDay = DateTime(2030);

  CalendarFormat _calendarFormat = CalendarFormat.week;

  late String _currentType;
  late List<String> _categories;
  late String _selectedCategories;
  final Categories _getCategories = Categories();
  late String _choosenCategories;

  late TextEditingController _titleController;
  late TextEditingController _amountController;
  late TextEditingController _noteController;

  late final FocusNode _titleFocusNode;
  late final FocusNode _amountFocusNode;
  late final FocusNode _noteFocusNode;

  @override
  void initState() {
    super.initState();
    _currentType = widget.type;
    _categories = _currentType == "Income"
        ? _getCategories.incomeCategories
        : _getCategories.expenseCategories;
    _selectedCategories = _categories.first;

    _titleController = TextEditingController();
    _amountController = TextEditingController();
    _noteController = TextEditingController();

    _titleFocusNode = FocusNode();
    _amountFocusNode = FocusNode();
    _noteFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();

    _titleFocusNode.dispose();
    _amountFocusNode.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submitTransaction() async {
  ref.read(transactionErrorProvider.notifier).state = false;
  ref.read(transactionErrorMessageProvider.notifier).state = '';

  void showError(String message) {
    ref.read(transactionErrorProvider.notifier).state = true;
    ref.read(transactionErrorMessageProvider.notifier).state = message;
  }

  if (_titleController.text.trim().isEmpty) {
    showError("Title cannot be empty");
    return;
  }

  final amount = int.tryParse(_amountController.text.trim());
  if (amount == null || amount <= 0) {
    showError("Amount must be a valid number");
    return;
  }

  final userId = ref.read(loadAuthProvider)?.uid;
  if (userId == null) {
    showError("User not logged in");
    return;
  }

  final noteText = _noteController.text.trim();

  final newTransaction = TransactionModel(
    id: '',
    title: _titleController.text.trim(),
    type: _currentType,
    category: _choosenCategories,
    amount: amount,
    createdAt: selectedDay,
    note: noteText.isEmpty ? null : noteText,
  );

  await ref
      .read(loadTransactionProvider.notifier)
      .createTransaction(userId, newTransaction);

  if (mounted) context.pop();
}

  @override
  Widget build(BuildContext context) {
    final hasError = ref.watch(transactionErrorProvider);
    final errorMessage = ref.watch(transactionErrorMessageProvider);
    final category = Categories();
    final transaction = ref.watch(loadTransactionProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(Icons.arrow_back, color: AppColors.neutralsDark1),
        ),
        centerTitle: true,
        title: Text(
          _currentType,
          style: GoogleFonts.inter(
            color: AppColors.neutralsDark1,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppColors.neutralsWhite,
                    ),
                    child: CustomTableCalendar(
                      focusedDay: focusedDay,
                      firstDay: firstDay,
                      lastDay: lastDay,
                      calendarFormat: _calendarFormat,
                      selectedDay: selectedDay,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _calendarFormat = _calendarFormat == CalendarFormat.week
                            ? CalendarFormat.month
                            : CalendarFormat.week;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Icon(
                        _calendarFormat == CalendarFormat.week
                            ? Icons.keyboard_arrow_down
                            : Icons.keyboard_arrow_up,
                        color: AppColors.neutralsDark1,
                        size: 28,
                      ),
                    ),
                  ),
                  SizedBox(height: 32),
                  _buildSectionTitle(
                    _currentType == 'Income' ? "Income Title" : "Expense Title",
                  ),
                  const SizedBox(height: 12),
                  CustomTextfield(
                    control: _titleController,
                    hint: "Ex: my salary",
                    prefix: null,
                    focus: _titleFocusNode,
                    isPassword: null,
                    hasError: hasError,
                    isOnlyNumber: false,
                  ),
                  SizedBox(height: 32),
                  _buildSectionTitle("Amount"),
                  SizedBox(height: 12),
                  CustomTextfield(
                    control: _amountController,
                    hint: "Ex : 500000",
                    prefix: null,
                    focus: _amountFocusNode,
                    isPassword: null,
                    hasError: hasError,
                    isOnlyNumber: true,
                  ),
                  SizedBox(height: 32),
                  _buildSectionTitle(
                    _currentType == "Income"
                        ? "Income Category"
                        : "Expense Category",
                  ),
                  CustomDropdownbutton(
                    value: _choosenCategories,
                    onChanged: (value) {
                      setState(() {
                        _choosenCategories = value!;
                      });
                    },
                    itemsValue: _categories,
                  ),
                  SizedBox(height: 32),
                  _buildSectionTitle("Note"),
                  SizedBox(height: 12),
                  CustomTextfield(
                    control: _noteController,
                    hint: "Write your note if important (optional)",
                    prefix: null,
                    focus: _noteFocusNode,
                    isPassword: false,
                    hasError: hasError,
                    isOnlyNumber: false,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24.0),
        child: CustomButton(
          onPress: _submitTransaction,
          text: _currentType == "Income" ? "ADD INCOME" : "ADD EXPENSE",
        ),
      ),
    );
  }
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
