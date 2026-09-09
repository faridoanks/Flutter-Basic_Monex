class Categories{
  String getCategoryIcon(String category) {
  switch (category) {
    case 'Food':
      return 'assets/icons/food.svg';

    case 'Transport':
      return 'assets/icons/bike.svg';

    case 'Shopping':
      return 'assets/icons/shopping.svg';

    case 'Entertainment':
      return 'assets/icons/movie.svg';

    case 'Bills':
      return 'assets/icons/bill.svg';

    case 'Salary':
      return 'assets/icons/salary.svg';

    case 'Mobile':
      return 'assets/icons/mobile.svg';

    case 'Rent':
      return 'assets/icons/rent.svg';

    case 'Cashback':
      return 'assets/icons/cashback.svg';

    case 'Cinema':
      return 'assets/icons/cinema.svg';

    case 'Uber':
      return 'assets/icons/uber.svg';

    case 'Price':
      return 'assets/icons/price.svg';

    default:
      return 'assets/icons/food.svg';
  }
}

List<String>incomeCategories = ['Salary', 'Cashback', 'Gifts'];

List<String>expenseCategories = [
  'Food',
  'Transport',
  'Shopping',
  'Entertainment',
  'Bills',
  'Mobile',
  'Rent',
  'Cinema',
  'Uber',
];
}
