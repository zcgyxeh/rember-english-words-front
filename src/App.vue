<script setup lang="ts"></script>

<template>
  <router-view />
</template>

<style>
html,
body,
#app {
  width: 100vw;
  height: 100vh;
  min-width: 0;
  min-height: 0;
  max-width: 100vw;
  max-height: 100vh;
  margin: 0;
  padding: 0;
  overflow: hidden !important;
  box-sizing: border-box;
}

#app {
  width: 100vw;
  height: 100vh;
  min-width: 0;
  min-height: 0;
  max-width: 100vw;
  max-height: 100vh;
  overflow: hidden !important;
  box-sizing: border-box;
  display: flex;
  flex-direction: column;
}

body {
  margin: 0;
  padding: 0;
  width: 100vw;
  height: 100vh;
  overflow: hidden !important;
}
</style>
