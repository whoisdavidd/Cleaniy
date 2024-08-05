<script setup lang="ts">
import NavBar from './NavBar.vue'
</script>

<template>
     
     <NavBar/>
      <div class="content">
        <div class="box1" >
          <img src="@/assets/logo.png" alt="Logo" class="logo" /> 
          <h1>Cleaniy</h1>
        </div > 
        <div class="box3">
          <h3>
            Welcome to Cleaniy!
            Created by David Kumar
          </h3>
        </div>       
      </div>
      <div class="box2" >
        <h1>
          About Cleaniy
        </h1>
        <div>
          A simple app that I created because I notice that people do not clear their screenshots and make their desktop very messy. This app will help you to clean your desktop by moving your screenshots to a folder or to the bin.
          The idea of this app is to help you to clean your desktop and make it look neat and tidy. 
        </div>
      </div> 
      
</template>
  
<style>
.logo{
  height: auto;
  float: left;

}
.box1{
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 20px;
  
}
.box2{
  display: inline;
  align-items: stretch;
  padding: 20px;
}
.box3{
  display: flex;
  justify-content: right;
  align-items: center;
  padding: 20px;
}
  .content {
  display: flex;
  padding-top: 60px; /* Adjust based on the height of the header */
  padding: 20px;
}
</style>

  

  