<template>
  <div class="summary-page">
    <h2>本章节答题总结</h2>
    <div class="summary-info">
      <div>章节：{{ section || '全部' }}</div>
      <div>总题数：{{ total }}</div>
      <div>答错题数：{{ wrongList.length }}</div>
    </div>
    <div v-if="wrongList.length > 0" class="wrong-list">
      <h3>错题列表</h3>
      <table class="wrong-table">
        <thead>
          <tr>
            <th>英文</th>
            <th>中文</th>
            <th>章节</th>
            <th>错误次数</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="w in wrongList" :key="w.word + w.section">
            <td>{{ w.word }}</td>
            <td>{{ w.meaning }}</td>
            <td>{{ w.section }}</td>
            <td>{{ w.errorCount }}</td>
          </tr>
        </tbody>
      </table>
    </div>
    <div class="summary-actions">
      <button class="finish-btn" @click="goHome">返回主页</button>
      <button class="finish-btn" @click="restart">重新练习本章节</button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { useRouter } from 'vue-router'
const router = useRouter()
// 通过history.state获取数据
const state = history.state || {}
const section = state.section || ''
const total = state.total || 0
const wrongList = state.wrongList || []
function goHome() {
  router.push('/')
}
function restart() {
  // 返回单词听写页面并带上当前章节
  router.push({ path: '/word-dictation', query: { section } })
}
</script>

<style scoped>
.summary-page {
  width: 100vw;
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: flex-start;
  background: #fcf8f4;
  z-index: 30;
  position: absolute;
  left: 0;
  top: 0;
  padding-top: 60px;
}
.summary-page h2 {
  font-size: 2.2rem;
  color: #3498db;
  margin-bottom: 24px;
}
.summary-info {
  font-size: 1.2rem;
  color: #222;
  margin-bottom: 18px;
  display: flex;
  gap: 32px;
}
.wrong-list {
  margin-bottom: 24px;
  width: 90vw;
  max-width: 600px;
}
.wrong-table {
  width: 100%;
  border-collapse: collapse;
  background: #fff;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(52, 152, 219, 0.08);
}
.wrong-table th,
.wrong-table td {
  border: 1px solid #e0e0e0;
  padding: 8px 12px;
  text-align: center;
}
.wrong-table th {
  background: #f5faff;
  color: #3498db;
}
.summary-actions {
  display: flex;
  gap: 24px;
  margin-top: 24px;
}
</style>
