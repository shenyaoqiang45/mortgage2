import 'dart:math';
import 'package:flutter/material.dart';

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

  /// 计算最优贷款年限
  /// [amount] 贷款总额
  /// [rate] 年利率（百分比）
  /// [disposableIncome] 月可支配收入
  /// [riskThreshold] 风险阈值（月供占收入比例）
  static Map<String, dynamic> calculateOptimalYears(double amount, double rate, double disposableIncome, [double riskThreshold = 0.4]) {
    // 最小还款年限为1年
    int minYears = 1;
    
    // 最大还款年限为30年或根据其他因素确定
    int maxYears = 30;
    
    // 初始化最优方案
    int optimalYears = maxYears;
    double minTotalInterest = double.infinity;
    double bestMonthlyPayment = 0;
    
    // 遍历所有可能的还款年限，找到最优解
    for (int years = minYears; years <= maxYears; years++) {
      final result = calculate(amount, rate, years);
      final monthlyPayment = result['monthlyPayment']!;
      
      // 检查是否超出风险阈值
      if (monthlyPayment / disposableIncome > riskThreshold) {
        continue;
      }
      
      // 找到利息最少的方案
      if (result['totalInterest']! < minTotalInterest) {
        minTotalInterest = result['totalInterest']!;
        optimalYears = years;
        bestMonthlyPayment = monthlyPayment;
      }
    }
    
    return {
      'optimalYears': optimalYears,
      'monthlyPayment': bestMonthlyPayment,
      'totalInterest': minTotalInterest,
      'safety': calculateSafetyLevel(disposableIncome, bestMonthlyPayment, riskThreshold)
    };
  }
  
  /// 计算安全等级
  /// [disposableIncome] 月可支配收入
  /// [monthlyPayment] 月还款额
  /// [riskThreshold] 风险阈值
  static String calculateSafetyLevel(double disposableIncome, double monthlyPayment, double riskThreshold) {
    final ratio = monthlyPayment / disposableIncome;
    final safetyRatio = 1 - ratio / riskThreshold;
    
    if (safetyRatio > 0.75) {
      return '极安全';
    } else if (safetyRatio > 0.5) {
      return '较安全';
    } else if (safetyRatio > 0.25) {
      return '一般';
    } else {
      return '危险';
    }
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
