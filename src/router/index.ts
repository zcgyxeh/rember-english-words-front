import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '../views/HomeView.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      component: HomeView,
    },
    {
      path: '/finance',
      name: 'finance',
      component: () => import('../views/FinanceView.vue'),
    },
    {
      path: '/word-dictation',
      name: 'word-dictation',
      component: () => import('../views/WordDictationView.vue'),
    },
    {
      path: '/word-dictation-summary',
      name: 'word-dictation-summary',
      component: () => import('../views/WordDictationSummary.vue'),
    },
    {
      path: '/grammar',
      name: 'grammar',
      component: () => import('../views/GrammarView.vue'),
    },
  ],
})

export default router
