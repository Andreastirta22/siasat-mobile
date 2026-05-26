// daily_sales/utils/daily_sales_calculator.dart

class DailySalesCalculator {
  static double calculateSales({required int quantity, required double price}) {
    return quantity * price;
  }

  static double calculateGrossSales({required List<double> sales}) {
    return sales.fold(0, (total, item) => total + item);
  }
}
