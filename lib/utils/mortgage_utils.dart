import 'dart:math';
import 'package:flutter/material.dart';

class MortgageUtils {
  /// 计算房贷月供、总利息、总还款
  /// [amount] 贷款总额（万元）
  /// [rate] 年利率（百分比）
  /// [years] 贷款年限
  static Map<String, double> calculate(double amount, double rate, int years) {
    final monthlyRate = rate / 12 / 100;
    final months = years * 12;
    
    // 直接以万元为单位计算
    final monthlyPayment = amount * (monthlyRate * pow(1 + monthlyRate, months)) /
        (pow(1 + monthlyRate, months) - 1);
    final totalPayment = monthlyPayment * months;
    final totalInterest = totalPayment - amount;
    
    return {
      'monthlyPayment': monthlyPayment,
      'totalInterest': totalInterest,
      'totalPayment': totalPayment
    };
  }

  /// 计算最优贷款年限
  /// [amount] 贷款总额（万元）
  /// [rate] 年利率（百分比）
  /// [disposableIncome] 月可支配收入（万元）
  /// [riskThreshold] 风险阈值（月供占收入比例）
  static int calculateOptimalYears(double amount, double rate, double disposableIncome, [double riskThreshold = 0.4]) {
    int optimalYears = 30;
    
    // 从最短年限开始寻找第一个满足条件的方案
    for (int years = 1; years <= 30; years++) {
      final result = calculate(amount, rate, years);
      final monthlyPayment = result['monthlyPayment']!;
      
      // 检查月供是否超过可承受范围（万元单位比较）
      if (monthlyPayment <= disposableIncome * riskThreshold) {
        optimalYears = years;
        break; // 找到第一个满足条件的最短年限即停止
      }
    }
    // 如果没有找到合适的年限，则返回最大年限
    return optimalYears;
  }
  
  /// 计算安全等级
  /// [disposableIncome] 月可支配收入（万元）
  /// [monthlyPayment] 月还款额（万元）
  /// [riskThreshold] 风险阈值（月供占收入比例）
  static String calculateSafetyLevel(double disposableIncome, double monthlyPayment, double riskThreshold) {
    final tempRiskThreshold = monthlyPayment / disposableIncome;
    
    if (tempRiskThreshold > riskThreshold) {
      return '危险';
    } else if (tempRiskThreshold > 0.3) {
      return '较安全';
    } else if (tempRiskThreshold > 0.2) {
      return '极安全';
    } else {
      return '较安全';
    }
  }

  /// 计算每年还款计划
  /// [amount] 贷款总额（万元）
  /// [rate] 年利率（百分比）
  /// [years] 贷款年限
  static List<Map<String, dynamic>> getYearlyPaymentPlan(double amount, double rate, int years) {
    final monthlyRate = rate / 12 / 100;
    final months = years * 12;
    
    // 使用calculate方法确保计算一致性
    final result = calculate(amount, rate, years);
    final monthlyPayment = result['monthlyPayment']!;
    
    List<Map<String, dynamic>> plan = [];
    double remaining = amount; // 剩余本金（万元）
    
    for (int year = 1; year <= years; year++) {
      double yearlyPrincipal = 0; // 年度本金（万元）
      double yearlyInterest = 0; // 年度利息（万元）
      
      for (int month = 1; month <= 12; month++) {
        // 月利息 = 剩余本金 * 月利率
        double interest = remaining * monthlyRate;
        // 月本金 = 月供 - 月利息
        double principal = monthlyPayment - interest;
        
        yearlyInterest += interest;
        yearlyPrincipal += principal;
        remaining -= principal;
      }
      
      plan.add({
        'year': year,
        'principal': yearlyPrincipal,
        'interest': yearlyInterest,
        'remaining': remaining > 0 ? remaining : 0,
      });
    }
    
    return plan;
  }
}
