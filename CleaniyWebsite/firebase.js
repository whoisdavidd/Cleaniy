// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { getAnalytics } from "firebase/analytics";
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
  apiKey: "AIzaSyCABX0dmzYeGyLjUzfc6JkHIiAzUTAGeS8",
  authDomain: "cleaniy.firebaseapp.com",
  projectId: "cleaniy",
  storageBucket: "cleaniy.appspot.com",
  messagingSenderId: "882676035475",
  appId: "1:882676035475:web:fa2fea0685ff0ffdb90266",
  measurementId: "G-7SG15V2E8Z"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);