<template>
  <aside :class="['sidebar', { collapsed }]">
    <button class="collapse-btn" @click="collapsed = !collapsed">
      <span v-if="!collapsed">«</span>
      <span v-else>»</span>
    </button>
    <div class="sidebar-header">
      <div class="logo" v-if="!collapsed">🧰</div>
    </div>
    <nav class="sidebar-nav">
      <div class="sidebar-section">
        <div class="section-title" v-if="!collapsed">模块</div>
        <ul>
          <li>
            <router-link to="/" class="nav-link main-link" active-class="active">
              <span class="icon">🔤</span>
              <span v-if="!collapsed">英语</span>
            </router-link>
            <ul v-if="!collapsed" class="sub-menu">
              <li>
                <router-link to="/word-dictation" class="sub-link" active-class="active"
                  >单词听写</router-link
                >
              </li>
            </ul>
          </li>
          <li class="divider" v-if="!collapsed"></li>
          <li>
            <router-link to="/finance" class="nav-link main-link" active-class="active">
              <span class="icon">💹</span>
              <span v-if="!collapsed">财报</span>
            </router-link>
          </li>
        </ul>
      </div>
    </nav>
  </aside>
</template>

<script setup lang="ts">
import { ref } from 'vue'
const collapsed = ref(false)
</script>

<style scoped>
.sidebar {
  width: 220px;
  background: #fff;
  border-right: 1px solid #eee;
  display: flex;
  flex-direction: column;
  align-items: stretch;
  min-height: 100vh;
  box-sizing: border-box;
  transition: width 0.2s;
  position: relative;
}
.sidebar.collapsed {
  width: 60px;
}
.collapse-btn {
  position: absolute;
  top: 12px;
  right: 12px;
  z-index: 2;
  background: #f5f6fa;
  border: 1px solid #e0e0e0;
  color: #888;
  font-size: 1.1rem;
  border-radius: 50%;
  width: 28px;
  height: 28px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  box-shadow: 0 1px 4px rgba(52, 152, 219, 0.04);
  transition:
    background 0.2s,
    color 0.2s;
  padding: 0;
}
.collapse-btn:hover {
  background: #eaf4fd;
  color: #3498db;
  border-color: #3498db;
}
.sidebar-header {
  padding: 48px 0 16px 0;
  display: flex;
  justify-content: center;
  align-items: center;
}
.logo {
  font-size: 2rem;
  font-weight: bold;
  color: #3498db;
  margin-left: 8px;
}
.sidebar-nav {
  flex: 1;
  padding: 0 0 0 0;
}
.sidebar-section {
  margin-bottom: 32px;
}
.section-title {
  font-size: 0.9rem;
  color: #888;
  margin: 0 0 8px 24px;
  letter-spacing: 1px;
  transition: opacity 0.2s;
}
ul {
  list-style: none;
  padding: 0 0 0 8px;
  margin: 0;
}
.nav-link {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 10px 24px;
  color: #222;
  text-decoration: none;
  border-radius: 6px;
  font-size: 1rem;
  transition:
    background 0.2s,
    color 0.2s;
  white-space: nowrap;
}
.main-link {
  font-size: 1.08rem;
  font-weight: 600;
  color: #1a2233;
  letter-spacing: 0.5px;
  background: #f7fafd;
  margin-bottom: 2px;
}
.main-link.active {
  background: #eaf4fd;
  color: #3498db;
}
.sidebar.collapsed .nav-link {
  justify-content: center;
  padding: 10px 0;
}
.icon {
  font-size: 1.2rem;
}
.nav-link:hover {
  background: #f3f6fa;
  color: #3498db;
}
.divider {
  height: 1px;
  background: #f0f0f0;
  margin: 8px 0 8px 0;
  border: none;
}
.sub-menu {
  padding-left: 32px;
  margin: 0 0 4px 0;
  border-left: 2px solid #eaf4fd;
}
.sub-link {
  display: block;
  padding: 7px 0 7px 0;
  color: #888;
  font-size: 0.97rem;
  border-radius: 4px;
  text-decoration: none;
  transition:
    background 0.2s,
    color 0.2s;
  margin-bottom: 2px;
}
.sub-link.active,
.sub-link:hover {
  background: #eaf4fd;
  color: #3498db;
}
</style>
