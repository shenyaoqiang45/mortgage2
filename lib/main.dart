import 'package:flutter/material.dart';
import 'utils/mortgage_utils.dart';

const double defaultRiskThreshold = 0.4; // 默认风险阈值为月供占收入的40%
const int minLoanYears = 1;      // 贷款最短期限
const int maxLoanYears = 30;     // 贷款最长期限

void main() => runApp(MortgageApp());

class MortgageApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '房贷计算器',
      home: MortgageCalculatorPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MortgageCalculatorPage extends StatefulWidget {
  @override
  _MortgageCalculatorPageState createState() => _MortgageCalculatorPageState();
}

class _MortgageCalculatorPageState extends State<MortgageCalculatorPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController(text: '100.0');
  final _rateController = TextEditingController(text: '3.5');
  final _yearsController = TextEditingController(text: '30');
  final _incomeController = TextEditingController(text: '2.0');

  double? monthlyPayment;
  double? optimalMonthlyPayment;
  double? totalInterest;
  double? optimalTotalInterest;
  double? totalPayment;

  int? optimalYears;
  String? safetyLevel;

  List<Map<String, dynamic>>? yearlyPlan;

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      final amount = double.parse(_amountController.text) * 10000;
      final rate = double.parse(_rateController.text);
      final years = int.parse(_yearsController.text);
      final result = MortgageUtils.calculate(amount, rate, years);
      setState(() {
        monthlyPayment = result['monthlyPayment'];
        totalInterest = result['totalInterest'];
        totalPayment = result['totalPayment'];
        yearlyPlan = MortgageUtils.getYearlyPaymentPlan(amount, rate, years);
        
        // 计算最优方案
        final incomeText = _incomeController.text ?? '';
        final income = double.tryParse(incomeText) ?? 0.0;
        
        if (income <= 0) {
          // 如果收入无效，使用当前贷款年限计算的月供作为安全等级判断依据
          final monthlyPaymentForSafety = result['monthlyPayment']!;
          final disposableIncome = monthlyPaymentForSafety / defaultRiskThreshold;
          safetyLevel = MortgageUtils.calculateSafetyLevel(disposableIncome, monthlyPaymentForSafety, defaultRiskThreshold);
        } else {
          final optimalResult = MortgageUtils.calculateOptimalYears(amount, rate, 
              income * 10000, defaultRiskThreshold);
          
          optimalYears = optimalResult['optimalYears'];
          optimalMonthlyPayment = optimalResult['monthlyPayment'];
          optimalTotalInterest = optimalResult['totalInterest'];
          safetyLevel = optimalResult['safety'] ?? '一般';
        }
      });
    }
  }

  void _showOptimalInfo() {
    if (optimalYears == null) return;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('最优贷款方案'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('推荐年限: ${optimalYears} 年'),
            SizedBox(height: 10),
            Text('每月还款: ${optimalMonthlyPayment!.toStringAsFixed(2)} 万元'),
            SizedBox(height: 10),
            Text('总利息支出: ${optimalTotalInterest!.toStringAsFixed(2)} 万元'),
            SizedBox(height: 10),
            Text('风险等级: $safetyLevel'),
            SizedBox(height: 10),
            LinearProgressIndicator(
              value: calculateSafetyProgress(safetyLevel!),
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                getSafetyColor(safetyLevel!)
              ),
            )
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('关闭'),
          ),
        ],
      ),
    );
  }

  double calculateSafetyProgress(String safetyLevel) {
    switch (safetyLevel) {
      case '极安全': return 0.9;
      case '较安全': return 0.7;
      case '一般': return 0.5;
      default: return 0.2;
    }
  }

  Color getSafetyColor(String safetyLevel) {
    switch (safetyLevel) {
      case '极安全': return Colors.green;
      case '较安全': return Colors.lightGreen;
      case '一般': return Colors.orange;
      default: return Colors.red;
    }
  }

  void _showPaymentPlan() {
    if (yearlyPlan == null) return;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('每年还款计划'),
        content: Container(
          constraints: BoxConstraints(maxHeight: 500),
          width: 500,
          child: Column(
            children: [
              // Fixed header row
              LayoutBuilder(
                builder: (context, constraints) {
                  return SizedBox(
                    width: constraints.maxWidth,
                    child: DataTable(
                      headingRowHeight: 40,
                      columns: const [
                        DataColumn(label: SizedBox(width: 80, child: Text('年份'))),
                        DataColumn(label: SizedBox(width: 100, child: Text('本金(万元)'))),
                        DataColumn(label: SizedBox(width: 100, child: Text('利息(万元)'))),
                        DataColumn(label: SizedBox(width: 100, child: Text('剩余(万元)'))),
                      ],
                      rows: const [],
                    ),
                  );
                },
              ),
              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  child: DataTable(
                    headingRowHeight: 0, // Hide duplicate header
                    columns: const [
                      DataColumn(label: SizedBox(width: 80, child: Text(''))),
                      DataColumn(label: SizedBox(width: 100, child: Text(''))),
                      DataColumn(label: SizedBox(width: 100, child: Text(''))),
                      DataColumn(label: SizedBox(width: 100, child: Text(''))),
                    ],
                    rows: yearlyPlan!.map((year) {
                      return DataRow(cells: [
                        DataCell(Text('第${year['year']}年')),
                        DataCell(Text(year['principal'].toStringAsFixed(2))),
                        DataCell(Text(year['interest'].toStringAsFixed(2))),
                        DataCell(Text(year['remaining'].toStringAsFixed(2))),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('关闭'),
          ),
        ],
      ),
    );
  }

  void _showRewardDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Transform.scale(
          scale: 0.5,
          child: Image.asset('assets/reward_qr.png'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('关闭'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('房贷计算器')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(labelText: '贷款总额 (万元)'),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? '请输入贷款总额' : null,
              ),
              TextFormField(
                controller: _rateController,
                decoration: InputDecoration(labelText: '年利率 (%)'),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? '请输入年利率' : null,
              ),
              TextFormField(
                controller: _incomeController,
                decoration: InputDecoration(labelText: '月可支配收入 (万元)'),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? '请输入月可支配收入' : null,
              ),
              TextFormField(
                controller: _yearsController,
                decoration: InputDecoration(
                  labelText: '贷款年限 (年)', 
                  hintText: '请输入$minLoanYears-$maxLoanYears年的贷款期限'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入贷款年限';
                  }
                  final years = int.tryParse(value);
                  if (years == null || years < minLoanYears || years > maxLoanYears) {
                    return '贷款年限必须在$minLoanYears-$maxLoanYears年之间';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _calculate,
                  child: Text('计算'),
                ),
              ),
              SizedBox(height: 30),
              if (monthlyPayment != null) ...[
                Text('每月还款: ${monthlyPayment!.toStringAsFixed(2)}万元'),
                Text('累计利息: ${totalInterest!.toStringAsFixed(2)}万元'),
                Text('全部还款: ${totalPayment!.toStringAsFixed(2)}万元'),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _showPaymentPlan,
                      child: Text('每年还款计划'),
                    ),
                    ElevatedButton(
                      onPressed: _showOptimalInfo,
                      child: Text('查看最优方案'),
                    ),
                    ElevatedButton(
                      onPressed: _showRewardDialog,
                      child: Text('打赏支持'),
                    ),
                  ],
                ),
                if (safetyLevel != null)
                  Column(
                    children: [
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('风险等级: ${safetyLevel ?? "未知"} | ',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          Container(
                            width: 100,
                            height: 20,
                            child: LinearProgressIndicator(
                              value: calculateSafetyProgress(safetyLevel!),
                              backgroundColor: Colors.grey[300],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                getSafetyColor(safetyLevel!)
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  )
              ]
            ],
          ),
        ),
      ),
    );
  }
}
