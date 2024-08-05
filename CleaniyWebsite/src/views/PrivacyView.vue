<script setup lang="ts">
import NavBar from '@/components/NavBar.vue'
import Footer from '@/components/Footer.vue'
</script>

<template>
  <div class="container">
    <NavBar />
    <main class="main-content">
      <header class="header">
        <h1>Privacy Policy</h1>
      </header>
      <section class="privacy-policy">
        <div class="content">
          <div>
            <p>Last updated: 4 August 2024</p>
            <p>Welcome to Cleaniy!</p>
            <p>This Privacy Policy explains our practices regarding the collection, use, and disclosure of your information through our service.</p>
          </div>
        </div>
        <div>
          <h2>1. Information We Collect</h2>
          <p>We do not collect any personal data. Our service solely aims to help you clean or move your items efficiently without requiring any of your personal information.</p>

          <h2>2. How We Use Your Information</h2>
          <p>As we do not collect any personal data, there is no usage of such information. We focus on providing you with the functionality to manage your items effectively.</p>

          <h2>3. Information Sharing and Disclosure</h2>
          <p>We do not share or disclose any personal data because we do not collect any. Your privacy is of utmost importance to us.</p>

          <h2>4. Security</h2>
          <p>We implement strict security measures to ensure the safety of our service. Since no personal data is collected, there is no risk of data breaches or misuse.</p>

          <h2>5. Changes to This Privacy Policy</h2>
          <p>We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page. You are advised to review this Privacy Policy periodically for any changes.</p>

          <h2>6. Contact Us</h2>
          <p>If you have any questions about this Privacy Policy, please contact us:</p>
          <ul>
            <li>By email: lucuhelpdesk@gmail.com</li>
          </ul>
        </div>
      
      </section>
    </main>
    <Footer />
  </div>
</template>

<style scoped>
.container {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
}

.main-content {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 20px;
}

.header {
  padding-top: 20px;
  text-align: center;
  margin-bottom: 20px;
}

.privacy-policy {
  max-width: 800px;
  width: 100%;
  padding: 20px;
  background-color: #f9f9f9;
  border-radius: 8px;
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
}

.content {
  font-size: 16px;
  line-height: 1.6;
  word-break: break-word; /* Add this to handle long words properly */
}

h1 {
  font-size: 32px;
  margin-bottom: 20px;
}

h2 {
  font-size: 24px;
  margin-top: 20px;
}

ul {
  list-style-type: none;
  padding: 0;
}

ul li {
  margin: 5px 0;
}
</style>
