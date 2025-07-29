<template>
  <div class="word-dictation">
    <!-- 顶部操作区，三分布局 -->
    <a-row class="top-bar" align="middle" justify="space-between" :gutter="0">
      <a-col class="top-bar-left">
        <a-button
          type="text"
          shape="circle"
          @click="router.push('/')"
          title="返回主菜单"
          :icon="h(ArrowLeftOutlined)"
        />
      </a-col>
      <a-col class="top-bar-right">
        <a-select
          v-model:value="selectedSection"
          class="section-select"
          style="min-width: 120px; margin-right: 12px"
          :bordered="false"
          size="middle"
        >
          <a-select-option value="">全部章节</a-select-option>
          <a-select-option v-for="section in sections" :key="section" :value="section">{{
            section
          }}</a-select-option>
        </a-select>
        <a-dropdown placement="bottomRight">
          <a-button
            type="text"
            shape="circle"
            class="dropdown-btn"
            title="更多设置"
            :icon="h(MoreOutlined)"
          />
          <template #overlay>
            <a-menu>
              <a-menu-item @click="handleDictationMode" :class="{ active: mode === 'dictation' }"
                >模式</a-menu-item
              >
              <a-menu-item @click="handleRecallMode" :class="{ active: mode === 'recall' }"
                >默写</a-menu-item
              >
              <a-menu-item @click="handleImageMode" :class="{ active: mode === 'image' }"
                >图片模式</a-menu-item
              >
              <a-menu-item @click="handleToggleMode">{{
                mode === 'dictation' ? '显示汉语' : '隐藏汉语'
              }}</a-menu-item>
              <a-menu-item @click="goSummary">结束</a-menu-item>
            </a-menu>
          </template>
        </a-dropdown>
      </a-col>
    </a-row>
    <a-result v-if="isFinished" status="success" title="本章节已完成！">
      <template #extra>
        <a-space>
          <a-button type="primary" @click="goHome">返回主页</a-button>
          <a-button @click="restart">重新练习本章节</a-button>
          <a-button @click="exportExcel">导出错题统计</a-button>
        </a-space>
      </template>
    </a-result>
    <div v-else-if="currentWord" class="main-center">
      <div class="word-area">
        <template v-if="mode === 'image' && currentWord.image">
          <img
            :src="currentWord.image"
            alt="图片"
            style="
              max-width: 220px;
              max-height: 180px;
              margin-bottom: 18px;
              border-radius: 8px;
              object-fit: contain;
              box-shadow: 0 2px 8px #eee;
            "
          />
        </template>
        <div class="answer-mask-wrap" style="position: relative">
          <div
            v-if="showMask"
            class="answer-mask"
            style="
              position: absolute;
              left: 0;
              top: 0;
              right: 0;
              bottom: 0;
              background: #fcf8f4;
              z-index: 10;
              display: flex;
              align-items: center;
              justify-content: center;
              font-size: 1.2rem;
              color: #888;
              pointer-events: none;
            "
          ></div>
          <div class="answer-display" ref="answerDisplayRef">
            <span v-html="answerColored"></span>
          </div>
        </div>
        <div class="input-underline-area">
          <a-input
            v-model:value="userInput"
            :maxlength="currentWord?.word?.length || 20"
            @keydown.enter.prevent="checkAnswer"
            @keydown.tab.prevent="playWord"
            class="word-input"
            autocomplete="off"
            spellcheck="false"
            size="large"
            style="
              text-align: center;
              border: none;
              border-bottom: 3px solid #222;
              background: transparent;
              font-size: 2.1rem;
              box-shadow: none;
            "
          />
        </div>
        <div v-if="mode === 'recall' && currentWord" class="word-meaning">
          {{ currentWord.meaning }}
        </div>
        <a-button
          type="text"
          shape="circle"
          class="play-btn mini-btn"
          @click="playWord"
          :icon="h(AudioOutlined)"
        />
      </div>
    </div>
    <a-progress
      :percent="progress"
      :show-info="false"
      :stroke-width="3"
      :style="{ position: 'absolute', left: 0, bottom: 0, width: '100vw', margin: 0 }"
      :stroke-color="{ from: '#3498db', to: '#3498db' }"
    />
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch, nextTick, h } from 'vue'
import { useRouter } from 'vue-router'
import * as XLSX from 'xlsx'
import {
  Row as ARow,
  Col as ACol,
  Button as AButton,
  Select as ASelect,
  SelectOption as ASelectOption,
  Dropdown as ADropdown,
  Menu as AMenu,
  MenuItem as AMenuItem,
  Input as AInput,
  Progress as AProgress,
  Result as AResult,
  Space as ASpace,
} from 'ant-design-vue'
import { ArrowLeftOutlined, MoreOutlined, AudioOutlined } from '@ant-design/icons-vue'
// 删除 import { Dropdown, Menu, Button } from 'ant-design-vue'

// 支持 { word, meaning, section, errorCount, image } 结构
const wordsRaw = ref<
  { word: string; meaning: string; section: string; errorCount: number; image?: string }[]
>([])
const sections = ref<string[]>([])
const selectedSection = ref('')

const words = computed(() => {
  if (!selectedSection.value) return wordsRaw.value
  return wordsRaw.value.filter((w) => w.section === selectedSection.value)
})

const mode = ref<'dictation' | 'recall' | 'image'>('dictation')
const showDropdown = ref(false) // 初始收起

const router = useRouter()

async function loadWordsFromExcel() {
  try {
    const response = await fetch('/words.xlsx')
    const arrayBuffer = await response.arrayBuffer()
    const workbook = XLSX.read(arrayBuffer, { type: 'array' })
    const sheet = workbook.Sheets[workbook.SheetNames[0]]
    const data = XLSX.utils.sheet_to_json(sheet, { header: 1 }) as string[][]
    // 跳过第一行表头，支持五列：英文+中文+章节+错误次数+图片地址
    const dataRows = data.slice(1)
    wordsRaw.value = dataRows
      .map((row) => {
        if (row[0] && row[1]) {
          return {
            word: row[0],
            meaning: row[1],
            section: row[2] || '',
            errorCount: Number(row[3] || 0),
            image: row[4] || '',
          }
        } else if (row[0]) {
          return {
            word: row[0],
            meaning: '',
            section: row[2] || '',
            errorCount: Number(row[3] || 0),
            image: row[4] || '',
          }
        } else {
          return null
        }
      })
      .filter(Boolean) as {
      word: string
      meaning: string
      section: string
      errorCount: number
      image?: string
    }[]
    // 收集所有章节名
    const sectionSet = new Set<string>()
    wordsRaw.value.forEach((w) => {
      if (w.section) sectionSet.add(w.section)
    })
    sections.value = Array.from(sectionSet)
  } catch {
    // 失败时用默认单词
    wordsRaw.value = [{ word: 'apple', meaning: '苹果', section: '', errorCount: 0, image: '' }]
    sections.value = []
  }
}

onMounted(() => {
  loadWordsFromExcel()
})

const currentIndex = ref(0)
const currentWord = computed(() => {
  if (currentIndex.value < words.value.length) {
    return words.value[currentIndex.value]
  }
  return null
})
const userInput = ref('')
const showResult = ref(false)
const isCorrect = ref(false)
const showMask = ref(true)
let answerTimeout: number | null = null

const progress = computed(() => {
  return words.value.length ? ((currentIndex.value + 1) / words.value.length) * 100 : 0
})

function lcs(a: string, b: string) {
  const m = a.length,
    n = b.length
  const dp = Array.from({ length: m + 1 }, () => Array(n + 1).fill(0))
  for (let i = 1; i <= m; i++) {
    for (let j = 1; j <= n; j++) {
      if (a[i - 1].toLowerCase() === b[j - 1].toLowerCase()) {
        dp[i][j] = dp[i - 1][j - 1] + 1
      } else {
        dp[i][j] = Math.max(dp[i - 1][j], dp[i][j - 1])
      }
    }
  }
  // 回溯找LCS
  let i = m,
    j = n,
    lcsStr = ''
  while (i > 0 && j > 0) {
    if (a[i - 1].toLowerCase() === b[j - 1].toLowerCase()) {
      lcsStr = a[i - 1] + lcsStr
      i--
      j--
    } else if (dp[i - 1][j] > dp[i][j - 1]) {
      i--
    } else {
      j--
    }
  }
  return lcsStr
}

function lcsWithMatch(a: string, b: string) {
  const m = a.length,
    n = b.length
  const dp = Array.from({ length: m + 1 }, () => Array(n + 1).fill(0))
  for (let i = 1; i <= m; i++) {
    for (let j = 1; j <= n; j++) {
      if (a[i - 1].toLowerCase() === b[j - 1].toLowerCase()) {
        dp[i][j] = dp[i - 1][j - 1] + 1
      } else {
        dp[i][j] = Math.max(dp[i - 1][j], dp[i][j - 1])
      }
    }
  }
  // 回溯找LCS下标
  let i = m,
    j = n
  const aMatch = Array(m).fill(false)
  while (i > 0 && j > 0) {
    if (a[i - 1].toLowerCase() === b[j - 1].toLowerCase()) {
      aMatch[i - 1] = true
      i--
      j--
    } else if (dp[i - 1][j] > dp[i][j - 1]) {
      i--
    } else {
      j--
    }
  }
  return aMatch
}

const answerColored = computed(() => {
  const user = userInput.value
  const answer = currentWord.value?.word
  if (!answer) {
    return ''
  }
  if (!user) {
    return answer
      .split('')
      .map((ch) => `<span class='default-answer'>${ch}</span>`)
      .join('')
  }
  const aMatch = lcsWithMatch(answer, user)
  return answer
    .split('')
    .map((ch, i) =>
      aMatch[i]
        ? `<span class='correct-char'>${ch}</span>`
        : `<span class='default-answer'>${ch}</span>`,
    )
    .join('')
})

const playWord = () => {
  if ('speechSynthesis' in window && currentWord.value?.word) {
    const utterance = new SpeechSynthesisUtterance(currentWord.value.word)
    utterance.lang = 'en-US'
    speechSynthesis.speak(utterance)
  }
}

// 在<script setup>中补充checkAnswer函数
function checkAnswer() {
  if (!userInput.value || !currentWord.value) return
  const userAnswer = userInput.value.toLowerCase()
  const correctAnswer = currentWord.value.word.toLowerCase()
  isCorrect.value = userAnswer === correctAnswer
  showResult.value = true
  showMask.value = false // 提交后显示答案

  if (isCorrect.value) {
    setTimeout(() => {
      showResult.value = false
      userInput.value = ''
      currentIndex.value++
      showMask.value = true // 下一题时重新遮挡
      const input = document.querySelector('.word-input') as HTMLInputElement
      if (input) {
        input.classList.add('success-animate')
        setTimeout(() => {
          input.classList.remove('success-animate')
        }, 500)
        input.value = ''
      }
    }, 600)
  } else {
    // 答错时，当前单词错误次数+1
    if (currentWord.value) {
      const globalIdx = wordsRaw.value.findIndex(
        (w) =>
          w.word === currentWord.value!.word &&
          w.meaning === currentWord.value!.meaning &&
          w.section === currentWord.value!.section,
      )
      if (globalIdx !== -1) {
        wordsRaw.value[globalIdx].errorCount++
      }
    }
    if (answerTimeout) clearTimeout(answerTimeout)
    answerTimeout = window.setTimeout(() => {
      // showAnswer.value = false // 已移除
    }, 3000)
    setTimeout(() => {
      showResult.value = false
      userInput.value = ''
      // 延长显示答案时间，让用户有更多记忆时间
      setTimeout(() => {
        showMask.value = true // 答错时恢复遮罩层，让用户重新答题
      }, 2000) // 2秒后再恢复遮罩层
      const input = document.querySelector('.word-input') as HTMLInputElement
      if (input) input.focus()
    }, 2000)
  }
}

// 导出错题统计
function exportExcel() {
  const data = [
    ['英文', '中文', '章节', '错误次数'],
    ...wordsRaw.value.map((w) => [w.word, w.meaning, w.section, w.errorCount]),
  ]
  const ws = XLSX.utils.aoa_to_sheet(data)
  const wb = XLSX.utils.book_new()
  XLSX.utils.book_append_sheet(wb, ws, 'Sheet1')
  XLSX.writeFile(wb, 'words_with_errors.xlsx')
}

const answerDisplayRef = ref<HTMLElement | null>(null)

watch(userInput, async (val) => {
  const user = val
  const answer = currentWord.value?.word
  if (!answer) {
    console.log('未输入')
    return
  }
  const lcsStr = lcs(answer, user)
  if (lcsStr.length > 0) {
    console.log(`LCS匹配内容='${lcsStr}'，长度=${lcsStr.length}`)
  } else {
    console.log('未匹配')
  }
  await nextTick()
  if (answerDisplayRef.value) {
    // 先全部重置为黑色
    const spans = answerDisplayRef.value.querySelectorAll('span')
    spans.forEach((span) => {
      span.style.color = '#222'
    })
    // 高亮属于 LCS 的字母（只做简单包含判断，调试用）
    const lcsArr = lcsStr.split('')
    spans.forEach((span) => {
      const idx = lcsArr.indexOf(span.textContent || '')
      if (idx !== -1) {
        span.style.color = '#27ae60'
        lcsArr[idx] = '' // 防止重复高亮同一字母
      }
    })
  }
})

const isFinished = computed(
  () => words.value.length > 0 && currentIndex.value >= words.value.length,
)
function goHome() {
  router.push('/')
}
function restart() {
  currentIndex.value = 0
  userInput.value = ''
  showMask.value = true
}
function goSummary() {
  const list = Array.isArray(words.value) ? words.value : []
  router.push({
    path: '/word-dictation-summary',
    state: {
      section: selectedSection.value,
      total: list.length,
      wrongList: list.filter((w) => w.errorCount > 0),
    },
  })
}
function toggleMode() {
  mode.value = mode.value === 'dictation' ? 'recall' : 'dictation'
}
function handleDictationMode() {
  mode.value = 'dictation'
  showDropdown.value = false
}
function handleRecallMode() {
  mode.value = 'recall'
  showDropdown.value = false
}
function handleImageMode() {
  mode.value = 'image'
  showDropdown.value = false
}
function handleToggleMode() {
  toggleMode()
  showDropdown.value = false
}
watch(selectedSection, () => {
  currentIndex.value = 0
  userInput.value = ''
  showMask.value = true
})
</script>

<style scoped>
/* 保持极简风格，覆盖 antd 菜单、输入等样式 */
.top-bar {
  width: 100vw;
  position: fixed;
  top: 0;
  left: 0;
  z-index: 100;
  background: #fcf8f4;
  padding: 16px 32px 0 32px;
  box-sizing: border-box;
  height: 60px;
}
.top-bar-left,
.top-bar-center,
.top-bar-right {
  display: flex;
  align-items: center;
}
.top-bar-center {
  justify-content: center;
  flex: 2;
}
.top-bar-left {
  justify-content: flex-start;
  flex: 1;
}
.top-bar-right {
  justify-content: flex-end;
  flex: unset;
  gap: 18px;
  min-width: 60px;
}
.word-dictation {
  width: 100vw;
  height: 100vh;
  min-height: 100vh;
  min-width: 0;
  max-width: 100vw;
  max-height: 100vh;
  display: flex;
  flex-direction: column;
  box-sizing: border-box;
  overflow: hidden;
  background: #fcf8f4;
  position: relative;
  padding-top: 72px;
}
.input-underline-area {
  width: 420px;
  max-width: 90vw;
  margin: 0 auto 0 auto;
  display: flex;
  justify-content: center;
}
.word-input {
  width: 100%;
  min-height: 2.6rem;
  background: transparent;
  color: #222;
  outline: none;
  box-shadow: none;
}
.answer-display {
  font-size: 2.4rem;
  font-weight: 500;
  margin-bottom: 12px;
  letter-spacing: 0.04em;
}
.word-area {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 32px;
}
.word-meaning {
  color: #666;
  font-size: 1.1rem;
  margin-top: 10px;
  margin-bottom: 0;
  text-align: center;
}
</style>
