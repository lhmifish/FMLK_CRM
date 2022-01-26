<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="pragma" content="no-cache" />
<meta http-equiv="cache-control" content="no-cache" />
<title>大医疗</title>
<!-- Stylesheets -->
<link href="${pageContext.request.contextPath}/assets/css/bootstrap.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
<!-- Responsive File -->
<link href="${pageContext.request.contextPath}/assets/css/responsive.css" rel="stylesheet">
<!-- Color File -->
<link href="${pageContext.request.contextPath}/assets/css/color.css" rel="stylesheet">

<link rel="shortcut icon" href="assets/images/favicon.png" type="image/x-icon">
<link rel="icon" href="assets/images/favicon.png" type="image/x-icon">

<!-- Responsive -->
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0">
<!--[if lt IE 9]><script src="https://cdnjs.cloudflare.com/ajax/libs/html5shiv/3.7.3/html5shiv.js"></script><![endif]-->
<!--[if lt IE 9]><script src="js/respond.js"></script><![endif]-->
</head>

<body>

<div class="page-wrapper">
    <!-- Preloader -->
    <div class="loader-wrap">
        <div class="preloader"><div class="preloader-close">Preloader Close</div></div>
        <div class="layer layer-one"><span class="overlay"></span></div>
        <div class="layer layer-two"><span class="overlay"></span></div>        
        <div class="layer layer-three"><span class="overlay"></span></div>        
    </div>

    <!-- Main Header -->
    <!-- Main Header -->
    <header class="main-header header-style-two">

        <!-- Header Top -->
        <div class="header-top" style="background-color:#5EC7CE">
            <div class="auto-container">
                <div class="inner-container">
                    <div class="left-column">
                        <div class="text" style="font-size:25px">上海飞默利凯科技有限公司</div>
                    </div>
                    <div class="right-column">
                        <div class="contact-info">
                            <li><a href="#"><i class="fas fa-phone"></i>电话: 021-31335666</a></li>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Header Upper -->
        <div class="header-upper style-two">
            <div class="auto-container">
                <div class="inner-container">
                    <!--Logo-->
                    <div class="logo-box">
                        <div class="logo"><a href="#"><img src="${pageContext.request.contextPath}/assets/images/logo_2.png" alt="" style="height:120px"></a></div>
                    </div>
                    <div class="right-column">
                        <!--Nav Box-->
                        <div class="nav-outer">
                            
                            <!-- Main Menu -->
                            <nav class="main-menu navbar-expand-md navbar-light">
                                <div class="collapse navbar-collapse show clearfix" id="navbarSupportedContent">
                                    <ul class="navigation">
                                        <li><a href="${pageContext.request.contextPath}/fmlk" style="font-size:20px">主页</a></li>
                                        <li class="dropdown"><a href="${pageContext.request.contextPath}/fmlk/aboutUs" style="font-size:20px">关于我们</a>
                                        <ul>
                                                <li><a href="${pageContext.request.contextPath}/fmlk/aboutUs">公司介绍</a></li>
                                                <%-- <li><a href="${pageContext.request.contextPath}/page/aboutUs">发展历程</a></li> --%>
                                                <!-- <li><a href="service-2.html">企业资质</a></li> -->
                                                <li><a href="${pageContext.request.contextPath}/fmlk/partners">合作伙伴</a></li>
                                                
                                       </ul>
                                       </li>
                                        
                                        
                                        <li class="dropdown"><a href="${pageContext.request.contextPath}/fmlk/ourProducts" style="font-size:20px;color:#5EC7CE">产品与方案</a>
                                            <ul>
                                                <li><a href="${pageContext.request.contextPath}/fmlk/ourProducts">产品简介</a></li>
                                               <!--  <li><a href="service-2.html">产品介绍</a></li> -->
                                                <li><a href="${pageContext.request.contextPath}/fmlk/medicalSolution">大医疗</a></li>
                                            </ul>
                                        </li>
                                        <!-- <li class="dropdown"><a href="#" style="font-size:20px">至臻服务</a>
                                            <ul>
                                                <li><a href="team.html">规划咨询服务</a></li>
                                                <li><a href="portfolio.html">项目实施服务</a></li>
                                                <li><a href="team.html">维护支持服务</a></li>
                                                <li><a href="portfolio.html">外包驻场服务</a></li>
                                                <li><a href="team.html">机房搬迁服务</a></li>
                                            </ul>
                                        </li> -->
                                       <!--  <li class="dropdown"><a href="#" style="font-size:20px">动态</a>
                                            <ul>
                                                <li><a href="blog.html">Blog Grid</a></li>
                                                <li><a href="blog-2.html">Blog Classic</a></li>
                                                <li><a href="blog-details.html">Blog Details</a></li>
                                            </ul>
                                        </li> -->
                                        <li><a href="${pageContext.request.contextPath}/fmlk/contactUs" style="font-size:20px">联系我们</a></li>
                                    </ul>
                                </div>
                            </nav>
                        </div>
                    </div>                        
                </div>
            </div>
        </div>
        <!--End Header Upper-->

        <!-- Sticky Header  -->
        <div class="sticky-header main-menu">
            <div class="auto-container">
                <div class="inner-container">
                    <div class="nav-outer">
                        <!-- Main Menu -->
                        <nav class="main-menu">
                            <!--Keep This Empty / Menu will come through Javascript-->
                        </nav><!-- Main Menu End-->
                        <!-- Main Menu End-->
                        <button type="button" class="theme-btn search-toggler"><span class="far fa-search"></span></button>
                    </div>
                </div>
            </div>
        </div><!-- End Sticky Menu -->

        <!-- Mobile Menu  -->
        <div class="mobile-menu">
            <div class="menu-backdrop"></div>
            <div class="close-btn"><span class="icon flaticon-remove"></span></div>
            
            <nav class="menu-box">
                <div class="nav-logo"><a href="index.html"><img src="${pageContext.request.contextPath}/assets/images/logo-two.png" alt="" title=""></a></div>
                <div class="menu-outer"><!--Here Menu Will Come Automatically Via Javascript / Same Menu as in Header--></div>
				<!--Social Links-->
				<div class="social-links">
					<ul class="clearfix">
						<li><a href="#"><span class="fab fa-twitter"></span></a></li>
						<li><a href="#"><span class="fab fa-facebook-square"></span></a></li>
						<li><a href="#"><span class="fab fa-pinterest-p"></span></a></li>
						<li><a href="#"><span class="fab fa-instagram"></span></a></li>
						<li><a href="#"><span class="fab fa-youtube"></span></a></li>
					</ul>
                </div>
            </nav>
        </div><!-- End Mobile Menu -->

        <div class="nav-overlay">
            <div class="cursor"></div>
            <div class="cursor-follower"></div>
        </div>
    </header>
    <!-- End Main Header -->
    
    <!--Search Popup-->
    <div id="search-popup" class="search-popup">
        <div class="close-search theme-btn"><span class="flaticon-remove"></span></div>
        <div class="popup-inner">
            <div class="overlay-layer"></div>
            <div class="search-form">
                <form method="post" action="index.html">
                    <div class="form-group">
                        <fieldset>
                            <input type="search" class="form-control" name="search-input" value="" placeholder="Search Here" required >
                            <input type="submit" value="Search Now!" class="theme-btn">
                        </fieldset>
                    </div>
                </form>
                <br>
                <h3>Recent Search Keywords</h3>
                <ul class="recent-searches">
                    <li><a href="#">Finance</a></li>
                    <li><a href="#">Idea</a></li>
                    <li><a href="#">Service</a></li>
                    <li><a href="#">Growth</a></li>
                    <li><a href="#">Plan</a></li>
                </ul>
            </div>
            
        </div>
    </div>

    <!-- Page Title -->
    <section class="page-title" style="background-image: url(${pageContext.request.contextPath}/assets/images/background/bg-9.jpg);">
        <div class="auto-container">
            <div class="content-box">
                            
            </div>
        </div>
    </section>
    <!-- Page Title -->

    <!-- Service Details -->
    <section class="services-details">
        <div class="auto-container">
            <div class="row">
                <div class="col-lg-8 content-side order-lg-2">
                    <div class="image mb-40"><img src="${pageContext.request.contextPath}/assets/images/resource/image-22.png" alt=""></div>
                    <h2>大医疗</h2>
                    <div class="text">
                        <p><strong>大医疗概述</strong></p>
                        <p>随着ICT技术的创新，信息化已经成为了推动医疗卫生行业实现战略转变的重要力量。当信息化浸入医疗行业的各个环节，医疗服务不可避免地受到冲击，业务形态在冲击中实现转型升级。亚太蓝星“大医疗”旨在构建一个医疗资源联接聚集、健康数据融合互动的信息环境，促进医疗卫生的服务向着以人为本的方向发展。</p>
                    </div>
                    <!-- <div class="row mb-20">
                        <div class="col-md-7">
                            <div class="content mb-30">
                                <div class="icon-box">
                                    <div class="icon"><span class="fas fa-check"></span></div>
                                    <div>
                                        <h4>All Roof-Top Solutions</h4>
                                        <div class="text">Incididunt ut labore et dolore magna aliqua ut enim <br> veniam quis nostrud exercitation ullamco.</div>
                                    </div>
                                </div>
                                <div class="icon-box">
                                    <div class="icon"><span class="fas fa-check"></span></div>
                                    <div>
                                        <h4>Foremost Roofing Contractors</h4>
                                        <div class="text">Incididunt ut labore et dolore magna aliqua ut enim <br> veniam quis nostrud exercitation ullamco.</div>
                                    </div>
                                </div>
                                <div class="icon-box">
                                    <div class="icon"><span class="fas fa-check"></span></div>
                                    <div>
                                        <h4>Fair Installation Pricing</h4>
                                        <div class="text">Incididunt ut labore et dolore magna aliqua ut enim <br> veniam quis nostrud exercitation ullamco.</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-5">
                            <div class="image mb-30"><img src="assets/images/resource/image-23.jpg" alt=""></div>
                        </div>
                    </div> -->
                    <div class="testimonial">
                        <!-- <h3>解决方案</h3>
                        <div class="row">
                            <div class="theme_carousel owl-theme owl-carousel" data-options='{"loop": true, "margin": 0, "autoheight":true, "lazyload":true, "nav": true, "dots": true, "autoplay": true, "autoplayTimeout": 6000, "smartSpeed": 300, "responsive":{ "0" :{ "items": "1" }, "600" :{ "items" : "2" }, "768" :{ "items" : "2" } , "992":{ "items" : "2" }, "1200":{ "items" : "2" }}}'>
                                <div class="testimonial-block">
                                    <div class="inner-box">
                                        <div class="author-box">
                                            <div class="author-thumb"><img src="assets/images/resource/author-1.jpg" alt=""></div>
                                            <div class="content">
                                                <h4>移动医疗解决方案</h4>
                                                <div class="designation">Building Owner</div>
                                                
                                            </div>
                                        </div>
                                        <div class="text">“Integer lobortis sem consequat cons <br> nulla sed viverra ut lorem dap benda <br> imperdiets aliquam era volutpat dolor <br> pariatur excepteur sint.”</div>
                                    </div>
                                </div>
                                <div class="testimonial-block">
                                    <div class="inner-box">
                                        <div class="author-box">
                                            <div class="author-thumb"><img src="assets/images/resource/author-2.jpg" alt=""></div>
                                            <div class="content">
                                                <h4>智慧医院网络基础架构解决</h4>
                                                <div class="designation">Building Owner</div>
                                            </div>
                                        </div>
                                        <div class="text">“Integer lobortis sem consequat cons <br> nulla sed viverra ut lorem dap benda <br> imperdiets aliquam era volutpat dolor <br> pariatur excepteur sint.”</div>
                                    </div>
                                </div>
                                <div class="testimonial-block">
                                    <div class="inner-box">
                                        <div class="author-box">
                                            <div class="author-thumb"><img src="assets/images/resource/author-3.jpg" alt=""></div>
                                            <div class="content">
                                                <h4>智慧医院远程医疗解决方案</h4>
                                                <div class="designation">Building Owner</div>
                                            </div>
                                        </div>
                                        <div class="text">“Integer lobortis sem consequat cons <br> nulla sed viverra ut lorem dap benda <br> imperdiets aliquam era volutpat dolor <br> pariatur excepteur sint.”</div>
                                    </div>
                                </div>
                                
                                
                            </div>
                            
                            
                            
                        </div>            -->                 
                    </div>
                        
                </div>
                <aside class="col-lg-4 sidebar">
                    <div class="service-sidebar">
                        <div class="widget widget_categories_two">
                            <div class="widget-content">
                                <ul>
                                    <li><a href="${pageContext.request.contextPath}/fmlk/solutionOne">移动医疗解决方案</a></li>
                                     <li><a href="${pageContext.request.contextPath}/fmlk/solutionTwo">智慧医院网络基础架构解决</a></li>
                                    <li><a href="${pageContext.request.contextPath}/fmlk/solutionThree">智慧医院远程医疗解决方案</a></li>
                                </ul>
                            </div>
                        </div>                        
                       
                        
                    </div>
                </aside>
            </div>
        </div>
    </section>

    <!-- CTA Section Two -->
    <section class="cta-section-two">
        <div class="auto-container">
            <div class="wrapper-box">
                <h3>需要专业化的服务或产品维护 <br> 或是有任何其他问题? 我们准备好了来帮助你!</h3>
                <div class="link-btn"><a href="#" class="theme-btn btn-style-one style-three"><span>了解更多</span></a></div>
                <div class="icon"><img src="${pageContext.request.contextPath}/assets/images/icons/icon-12.png" alt=""></div>
            </div>
        </div>
    </section>

    <!-- Main Footer -->
    <footer class="main-footer">
        <div class="auto-container">
            <!--Widgets Section-->
            <div class="widgets-section">
                <div class="row clearfix">
                    
                    <!--Column-->
                    <div class="column col-lg-3 col-md-6">
                        <div class="widget about-widget">
                            <div class="logo"><a href="index.html"><img src="${pageContext.request.contextPath}/assets/images/logo_two_2.png" alt=""></a></div>
                        </div>
                    </div>
                    
                    <!--Column-->
                    <div class="column col-lg-3 col-md-6">
                        <div class="widget links-widget">
                            <h3 class="widget-title">我们的服务</h3>
                            <div class="widget-content">
                                <ul>
                                    <li><a href="#">规划咨询服务</a></li>
                                    <li><a href="#">项目实施服务</a></li>
                                    <li><a href="#">维护支持服务</a></li>
                                    <li><a href="#">外包驻场服务</a></li>
                                    <li><a href="#">机房搬迁服务</a></li>
                                    <li><a href="#">软件开发服务</a></li>
                                </ul>                                        
                            </div>
                        </div>
                    </div>

                    <!--Column-->
                    <div class="column col-lg-3 col-md-6">
                        <div class="widget links-widget">
                            <h3 class="widget-title">快捷链接</h3>
                            <div class="widget-content">
                                <ul>
                                    <li><a href="${pageContext.request.contextPath}/fmlk/aboutUs">关于我们</a></li>
                                    <li><a href="${pageContext.request.contextPath}/fmlk/ourProducts">我们的产品</a></li>
                                </ul>                                        
                            </div>
                        </div>
                    </div>
                    
                    <!--Column-->
                    <div class="column col-lg-3 col-md-6">
                        <div class="widget contact-widget">
                            <h3 class="widget-title">联系我们</h3>
                            <div class="widget-content">
                                <ul class="contact-info">
                                   <li>
                                        <div class="icon"><span class="flaticon-gps"></span></div>
                                        <div class="text" style="margin-top:10px">上海市虹口区车站北路727号</div>
                                    </li>
                                    <li>
                                        <div class="icon"><span class="flaticon-phone"></span></div>
                                        <div class="text" style="margin-top:10px">021-62360628</div>
                                    </li>
                                    <li>
                                        <div class="icon"><span class="flaticon-comment"></span></div>
                                        <div class="text" style="margin-top:10px">sunke@family-care.cn</div>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    
                </div>
            </div>
        </div>
        <!-- Footer Bottom -->
        <div class="footer-bottom">
            <div class="auto-container">
                <div class="copyright">
                    <div class="text">沪ICP备2021014732号</div>
                    <div class="text">Copyright 2020-2021上海飞默利凯科技有限公司版权所有 </div>
                </div>
            </div>
        </div>
    </footer>
	
</div>
<!--End pagewrapper-->

<!--Scroll to top-->
<div class="scroll-to-top scroll-to-target" data-target="html"><span class="flaticon-right-arrow"></span></div>

<script src="${pageContext.request.contextPath}/assets/js/jquery.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/popper.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/bootstrap-select.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/jquery.fancybox.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/isotope.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/owl.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/appear.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/wow.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/lazyload.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/scrollbar.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/TweenMax.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/swiper.min.js"></script>

<script src="${pageContext.request.contextPath}/assets/js/script.js"></script>


</body>
</html>