<template>
  <div class="grammar-view">
    <h2>AI语法问答</h2>
    <div class="chat-box">
      <textarea v-model="userInput" placeholder="请输入你的语法问题..." rows="3" />
      <button @click="askGPT" :disabled="loading || !userInput.trim()">提问</button>
    </div>
    <div class="answer-area" v-if="answer">
      <div class="answer-label">ChatGPT答复：</div>
      <div class="answer-content">{{ answer }}</div>
    </div>
    <div v-if="loading" class="loading">AI思考中...</div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
const userInput = ref('')
const answer = ref('')
const loading = ref(false)

async function askGPT() {
  if (!userInput.value.trim()) return
  loading.value = true
  answer.value = ''
  try {
    // 仅本地测试用，生产环境请用后端代理！
    const apiKey = '你的_OPENAI_API_KEY'
    const res = await fetch('https://api.openai.com/v1/chat/completions', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${apiKey}`,
      },
      body: JSON.stringify({
        model: 'gpt-3.5-turbo',
        messages: [
          {
            role: 'system',
            content: '你是一个专业的英语语法老师，请用简明中文解答用户的语法问题。',
          },
          { role: 'user', content: userInput.value },
        ],
      }),
    })
    const data = await res.json()
    answer.value = data.choices?.[0]?.message?.content || 'AI未能给出答复。'
  } catch {
    answer.value = '请求失败，请检查网络或API Key。'
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.grammar-view {
  max-width: 520px;
  margin: 60px auto;
  padding: 32px 18px;
  background: #fff;
  border-radius: 12px;
  box-shadow: 0 2px 12px rgba(52, 152, 219, 0.08);
  min-height: 320px;
}
.chat-box {
  display: flex;
  gap: 10px;
  margin-bottom: 18px;
}
textarea {
  flex: 1;
  font-size: 1rem;
  border-radius: 6px;
  border: 1px solid #e0e0e0;
  padding: 8px;
  resize: vertical;
}
button {
  padding: 8px 18px;
  border-radius: 6px;
  border: 1px solid #3498db;
  background: #3498db;
  color: #fff;
  font-size: 1rem;
  cursor: pointer;
  transition: background 0.2s;
}
button:disabled {
  background: #b3d8f6;
  border-color: #b3d8f6;
  cursor: not-allowed;
}
.answer-area {
  margin-top: 18px;
  background: #f5faff;
  border-radius: 8px;
  padding: 14px 12px;
}
.answer-label {
  color: #3498db;
  font-size: 0.98rem;
  margin-bottom: 6px;
}
.answer-content {
  color: #222;
  font-size: 1.08rem;
  white-space: pre-line;
}
.loading {
  margin-top: 18px;
  color: #888;
  font-size: 1rem;
}
</style>
