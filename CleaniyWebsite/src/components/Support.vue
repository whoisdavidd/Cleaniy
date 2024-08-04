<script setup lang="ts">
import NavBar from './NavBar.vue'
</script>


<template>
  <NavBar/>
  <main class="content">
    <h1>Support</h1>
    <p>If you need help, just email us at <a href="mailto:lucuhelpdesk@gmail.com">lucuhelpdesk@gmail.com</a></p>
  </main>

</template>
<style scoped>
.content {
  padding-top: 80px; /* Adjust based on the height of the header */
  padding: 20px;
  flex: 1;
}

h1 {
  margin-bottom: 20px;
}

p {
  margin-bottom: 10px;
}

a {
  color: #007bff;
  text-decoration: none;
}

a:hover {
  text-decoration: underline;
}
</style>