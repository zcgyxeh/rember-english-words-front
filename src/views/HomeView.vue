<script setup lang="ts">
import { Card as ACard, Row as ARow, Col as ACol } from 'ant-design-vue'
import { BookOutlined, FileTextOutlined, FundOutlined, BulbOutlined } from '@ant-design/icons-vue'
import { useRouter } from 'vue-router'
const router = useRouter()
const modules = [
  {
    title: '单词听写',
    desc: '练习英语单词的听写，提高听力识别能力',
    icon: BookOutlined,
    path: '/word-dictation',
    color: '#3498db',
    bg: '#eaf6fd',
  },
  {
    title: '短句听写',
    desc: '练习英语短句的听写，提升整体听力理解',
    icon: FileTextOutlined,
    path: '/sentence-dictation',
    color: '#3498db',
    bg: '#eaf6fd',
  },
  {
    title: '财报分析',
    desc: '财报分析、数据可视化等财务功能',
    icon: FundOutlined,
    path: '/finance',
    color: '#e67e22',
    bg: '#fdf6e3',
  },
  {
    title: '语法学习',
    desc: '系统学习英语语法知识，提升语法能力',
    icon: BulbOutlined,
    path: '/grammar',
    color: '#3498db',
    bg: '#eaf6fd',
  },
]
</script>

<template>
  <div class="home-modules">
    <a-typography-title :level="2" style="margin-bottom: 32px"
      >欢迎使用学习工具网站</a-typography-title
    >
    <a-row class="modules-list" :gutter="32" justify="center">
      <a-col v-for="mod in modules" :key="mod.path" :xs="22" :sm="10" :md="6" :lg="5" :xl="4">
        <a-card
          class="module-card"
          hoverable
          @click="router.push(mod.path)"
          :body-style="{
            padding: '14px 8px 12px 8px',
            display: 'flex',
            flexDirection: 'column',
            alignItems: 'center',
          }"
        >
          <div class="module-icon" :style="{ color: mod.color, background: mod.bg }">
            <component :is="mod.icon" />
          </div>
          <div class="module-title">{{ mod.title }}</div>
          <div class="module-desc">{{ mod.desc }}</div>
        </a-card>
      </a-col>
    </a-row>
  </div>
</template>

<style scoped>
.home-modules {
  max-width: 900px;
  margin: 0 auto;
  padding: 48px 0 0 0;
  text-align: center;
}
.modules-list {
  margin: 0 auto;
}
.module-card {
  border-radius: 16px;
  box-shadow: 0 2px 12px rgba(52, 152, 219, 0.08);
  min-width: 100px;
  max-width: 120px;
  cursor: pointer;
  transition:
    box-shadow 0.2s,
    transform 0.2s;
  margin-bottom: 24px;
}
.module-card:hover {
  box-shadow: 0 4px 24px rgba(52, 152, 219, 0.18);
  transform: translateY(-4px) scale(1.03);
}
.module-icon {
  font-size: 1.5rem;
  width: 36px;
  height: 36px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 10px;
}
.module-title {
  font-size: 1rem;
  font-weight: 600;
  margin-bottom: 6px;
}
.module-desc {
  font-size: 0.82rem;
  color: #888;
}
@media (max-width: 600px) {
  .modules-list {
    flex-direction: column;
    gap: 18px;
    align-items: center;
  }
  .module-card {
    min-width: 0;
    width: 90vw;
    max-width: 98vw;
    padding: 10px 0 8px 0;
  }
}
</style>
