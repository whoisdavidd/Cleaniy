import { createRouter, createWebHistory } from 'vue-router'
import HomePage from '../views/HomePage.vue'
import Support from '../views/SupportView.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/privacy-policy',
      name: 'Privacy',
      // route level code-splitting
      // this generates a separate chunk (About.[hash].js) for this route
      // which is lazy-loaded when the route is visited.
      component: () => import('../views/PrivacyView.vue')
    },
    {
      path: '/support',
      name: 'Support',
      component: Support
    },
    {
      path: '/',
      name: 'home',
      component: HomePage
    }
  ]
})

export default router
