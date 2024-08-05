<template>
     <header class="header">
        <router-link to="/home"><img src="@/assets/logo.png" alt="Logo" class="logo" /></router-link>
        <nav class="navbar">
          <ul class="nav-list">
            <li class="nav-item">
              <router-link to="/privacy-policy">Privacy Policy</router-link>
            </li>
            <li class="nav-item">
              <router-link to="/support">Support</router-link>
            </li>
          </ul>
        </nav>
      </header>
</template>

<style scoped>
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  font-family: Arial, sans-serif;
}


.header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 10px 20px;
  background-color: #f8f9fa;
  border-bottom: 1px solid #dee2e6;
  position: fixed;
  width: 100%;
  top: 0;
  left: 0;
  z-index: 1000;
}

.logo {
  height: 40px;
}

.navbar {
  display: flex;
}

.nav-list {
  display: flex;
  list-style-type: none;
}

.nav-item {
  margin-left: 20px;
}

.nav-item a {
  text-decoration: none;
  color: #343a40;
  font-weight: 500;
}

.nav-item a:hover {
  color: #007bff;
}



</style>