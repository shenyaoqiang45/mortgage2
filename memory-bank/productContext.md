# 产品背景

## 项目起源
房贷计算器应用的开发源于普通购房者在选择房贷方案时面临的挑战。大多数购房者需要贷款来购买房产，但面对各种贷款方案时往往难以做出最优选择。通过提供基础房贷计算和智能推荐功能，本应用旨在帮助用户更好地理解和比较不同的贷款方案。

## 解决的问题
1. **房贷计算复杂性**：普通用户难以手动计算每月还款额和总利息支出
2. **最优方案选择困难**：用户不知道在不同贷款年限之间如何权衡（短期贷款月供高但利息少 vs 长期贷款月供低但利息多）
3. **风险评估缺失**：用户难以判断某个贷款方案是否在其经济承受范围内
4. **决策支持不足**：缺乏直观的数据可视化和方案对比，导致决策过程主观性强

## 应该如何工作
1. **基础房贷计算**
   - 用户输入贷款金额、年利率和贷款年限
   - 系统即时计算并展示每月还款额、总利息和总还款额
   - 提供清晰的费用明细展示

2. **最优贷款年限计算**
   - 用户额外输入家庭月可支配收入
   - 系统根据默认或自定义的风险阈值（月供占收入比例）
   - 计算出利息支出最小且在风险可控范围内的贷款方案
   - 展示推荐年限、对应月还款额、总利息支出和风险等级

3. **风险评估可视化**
   - 使用文字描述（"极安全"、"较安全"等）和颜色编码的进度条直观显示风险等级
   - 不同风险等级使用不同颜色标识：绿色（极安全）、浅绿色（较安全）、橙色（一般）、红色（危险）

## 用户体验目标
1. **简单易用**：直观的界面设计，使用户能够快速上手
2. **快速响应**：实时计算，无需等待
3. **数据准确**：确保所有计算结果精确可靠
4. **决策支持**：提供清晰的数据展示和智能推荐，帮助用户做出明智决策
5. **风险意识**：通过可视化风险评估，增强用户对贷款风险的认知
