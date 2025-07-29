<template>
  <div class="finance-main">
    <h1>财报工具</h1>
    <p class="subtitle">这里可以进行财报分析、数据导入、可视化等操作</p>
    <div class="quick-actions">
      <button class="action-btn">上传财报</button>
      <button class="action-btn">查看分析</button>
    </div>
  </div>
</template>

<script setup lang="ts"></script>

<style scoped>
.finance-main {
  max-width: 520px;
  margin: 0 auto;
  padding: 48px 0 0 0;
  text-align: center;
}
.finance-main h1 {
  font-size: 2rem;
  font-weight: 700;
  color: #222;
  margin-bottom: 16px;
}
.subtitle {
  color: #888;
  font-size: 1.1rem;
  margin-bottom: 32px;
}
.quick-actions {
  display: flex;
  justify-content: center;
  gap: 24px;
}
.action-btn {
  display: inline-block;
  padding: 12px 32px;
  background: #3498db;
  color: #fff;
  border-radius: 8px;
  font-size: 1rem;
  border: none;
  cursor: pointer;
  transition: background 0.2s;
}
.action-btn:hover {
  background: #217dbb;
}
</style>
