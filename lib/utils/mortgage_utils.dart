import 'dart:math';

class MortgageUtils {
  /// 计算房贷月供、总利息、总还款
  /// [amount] 贷款总额
  /// [rate] 年利率（百分比）
  /// [years] 贷款年限
  static Map<String, double> calculate(double amount, double rate, int years) {
    final monthlyRate = rate / 12 / 100;
    final months = years * 12;
    final monthlyPayment = amount * (monthlyRate * pow(1 + monthlyRate, months)) /
        (pow(1 + monthlyRate, months) - 1);
    final totalPayment = monthlyPayment * months;
    final totalInterest = totalPayment - amount;
    return {
      'monthlyPayment': monthlyPayment,
      'totalInterest': totalInterest,
      'totalPayment': totalPayment,
    };
  }
}
