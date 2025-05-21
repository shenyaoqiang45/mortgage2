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
      'monthlyPayment': monthlyPayment / 10000,
      'totalInterest': totalInterest / 10000,
      'totalPayment': totalPayment / 10000
    };
  }

  /// 计算每年还款计划
  /// [amount] 贷款总额
  /// [rate] 年利率（百分比）
  /// [years] 贷款年限
  static List<Map<String, dynamic>> getYearlyPaymentPlan(double amount, double rate, int years) {
    final monthlyRate = rate / 12 / 100;
    final months = years * 12;
    final monthlyPayment = amount * (monthlyRate * pow(1 + monthlyRate, months)) /
        (pow(1 + monthlyRate, months) - 1);
    
    List<Map<String, dynamic>> plan = [];
    double remaining = amount;
    
    for (int year = 1; year <= years; year++) {
      double yearlyPrincipal = 0;
      double yearlyInterest = 0;
      
      for (int month = 1; month <= 12; month++) {
        double interest = remaining * monthlyRate;
        double principal = monthlyPayment - interest;
        
        yearlyInterest += interest;
        yearlyPrincipal += principal;
        remaining -= principal;
      }
      
      plan.add({
        'year': year,
        'principal': yearlyPrincipal / 10000,
        'interest': yearlyInterest / 10000,
        'remaining': remaining > 0 ? remaining / 10000 : 0,
      });
    }
    
    return plan;
  }
}
