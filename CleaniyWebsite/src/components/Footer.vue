<template>
    <footer class="site-footer">
      <div class="container">
        <div class="row">
          <div class="col-md-6 mb-4">
            <h6>Motto</h6>
            <p class="text-justify">
              Too lazy to drag and drop to the bin? Too lazy to drag it into the document? Don't worry Cleaniy is here to help you clean or move!
            </p>
          </div>
  
          <div class="col-md-3 mb-4">
            <h6>Categories</h6>
            <ul class="footer-links">
              <li><a href="#">C</a></li>
              <li><a href="#">UI Design</a></li>
              <li><a href="#">PHP</a></li>
              <li><a href="#">Java</a></li>
              <li><a href="#">Android</a></li>
              <li><a href="#">Templates</a></li>
            </ul>
          </div>
  
          <div class="col-md-3 mb-4">
            <h6>Quick Links</h6>
            <ul class="footer-links">
              <li><a href="#">About Us</a></li>
              <li><a href="#">Contact Us</a></li>
              <li><a href="#">Contribute</a></li>
              <li><a href="#">Privacy Policy</a></li>
              <li><a href="#">Sitemap</a></li>
            </ul>
          </div>
        </div>
        <hr>
      </div>
      <div class="container">
        <div class="row">
          <div class="col-md-8 col-sm-6">
            <p class="copyright-text">
              Copyright &copy; 2017 All Rights Reserved by
              <a href="#">Scanfcode</a>.
            </p>
          </div>
  
          <div class="col-md-4 col-sm-6">
            <ul class="social-icons">
              <li><a class="facebook" href="#"><i class="fa fa-facebook"></i></a></li>
              <li><a class="twitter" href="#"><i class="fa fa-twitter"></i></a></li>
              <li><a class="dribbble" href="#"><i class="fa fa-dribbble"></i></a></li>
              <li><a class="linkedin" href="#"><i class="fa fa-linkedin"></i></a></li>
            </ul>
          </div>
        </div>
      </div>
    </footer>
  </template>
  

  
  <style>
  .site-footer {
    width: 100%;
    margin: 0;
    position: relative;
    left: 0;
    background-color: #26272b;
    padding: 45px 0 20px;
    font-size: 15px;
    line-height: 24px;
    color: #737373;
  }
  .site-footer hr {
    border-top-color: #bbb;
    opacity: 0.5;
  }
  .site-footer h6 {
    color: #fff;
    font-size: 16px;
    text-transform: uppercase;
    margin-top: 5px;
    letter-spacing: 2px;
  }
  .site-footer a {
    color: #737373;
  }
  .site-footer a:hover {
    color: #3366cc;
    text-decoration: none;
  }
  .footer-links {
    padding-left: 0;
    list-style: none;
  }
  .footer-links li {
    display: block;
  }
  .footer-links a {
    color: #737373;
  }
  .footer-links a:hover {
    color: #3366cc;
    text-decoration: none;
  }
  .site-footer .social-icons {
    text-align: right;
  }
  .site-footer .social-icons a {
    width: 40px;
    height: 40px;
    line-height: 40px;
    margin-left: 6px;
    margin-right: 0;
    border-radius: 100%;
    background-color: #33353d;
  }
  @media (max-width: 991px) {
    .site-footer [class^='col-'] {
      margin-bottom: 30px;
    }
  }
  @media (max-width: 767px) {
    .site-footer {
      padding-bottom: 0;
    }
    .site-footer .copyright-text,
    .site-footer .social-icons {
      text-align: center;
    }
  }
  .social-icons {
    padding-left: 0;
    margin-bottom: 0;
    list-style: none;
  }
  .social-icons li {
    display: inline-block;
    margin-bottom: 4px;
  }
  .social-icons li.title {
    margin-right: 15px;
    text-transform: uppercase;
    color: #96a2b2;
    font-weight: 700;
    font-size: 13px;
  }
  .social-icons a {
    background-color: #eceeef;
    color: #818a91;
    font-size: 16px;
    display: inline-block;
    line-height: 44px;
    width: 44px;
    height: 44px;
    text-align: center;
    margin-right: 8px;
    border-radius: 100%;
    transition: all 0.2s linear;
  }
  .social-icons a:hover {
    color: #fff;
    background-color: #29aafe;
  }
  </style>
  