import 'package:flutter/material.dart';
import 'utils/mortgage_utils.dart';

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
  final _amountController = TextEditingController(text: '1000000');
  final _rateController = TextEditingController(text: '3.5');
  final _yearsController = TextEditingController(text: '20');

  double? monthlyPayment;
  double? totalInterest;
  double? totalPayment;

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      final amount = double.parse(_amountController.text);
      final rate = double.parse(_rateController.text);
      final years = int.parse(_yearsController.text);
      final result = MortgageUtils.calculate(amount, rate, years);
      setState(() {
        monthlyPayment = result['monthlyPayment'];
        totalInterest = result['totalInterest'];
        totalPayment = result['totalPayment'];
      });
    }
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
                decoration: InputDecoration(labelText: '贷款总额 (元)'),
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
                controller: _yearsController,
                decoration: InputDecoration(labelText: '贷款年限 (年)'),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? '请输入贷款年限' : null,
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
                Text('每月还款: ¥${monthlyPayment!.toStringAsFixed(2)}'),
                Text('累计利息: ¥${totalInterest!.toStringAsFixed(2)}'),
                Text('全部还款: ¥${totalPayment!.toStringAsFixed(2)}'),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
