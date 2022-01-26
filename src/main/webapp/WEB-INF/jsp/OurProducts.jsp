<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="pragma" content="no-cache" />
<meta http-equiv="cache-control" content="no-cache" />
<title>产品展示</title>
<!-- Stylesheets -->
<link href="${pageContext.request.contextPath}/assets/css/bootstrap.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/assets/css/style.css?v=1000" rel="stylesheet">
<!-- Responsive File -->
<link href="${pageContext.request.contextPath}/assets/css/responsive.css" rel="stylesheet">
<!-- Color File -->
<link href="${pageContext.request.contextPath}/assets/css/color.css?v=1000" rel="stylesheet">

<link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/images/favicon.png" type="image/x-icon">
<link rel="icon" href="${pageContext.request.contextPath}/assets/images/favicon.png" type="image/x-icon">

<!-- Responsive -->
<meta http-equiv="X-UA-COMPATIBLE" content="IE=edge,chrome=1" />
<meta name="viewport"
	content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no"/>
<meta name="apple-mobile-web-app-capable" content="yes" />
<meta name="apple-mobile-web-app-status-bar-style" content="black" />
<meta content="telephone=no" name="format-detection" />
<meta content="email=no" name="format-detection" />
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
    <header class="main-header header-style-two">


        <!-- Header Upper -->
			<div class="header-upper style-two">
				<div class="auto-container">
					<div class="inner-container">
						<!--Logo-->
						<div class="logo-box">
							<div class="logo">
								<a href="#"><img
									src="${pageContext.request.contextPath}/assets/images/logo_new_2021_09_26.png"
									alt="" style="height: 120px"></a>
							</div>
						</div>
						<div class="right-column">
							<!--Nav Box-->
							<div class="nav-outer">

								<!-- Main Menu -->
								<nav class="main-menu navbar-expand-md navbar-light" style="box-shadow: 2px 4px 6px #5EC7CE;background-color:#5EC7CE">
									<div class="collapse navbar-collapse show clearfix"
										id="navbarSupportedContent" >
										<ul class="navigation" style="height:70px">
											<li><a
												href="${pageContext.request.contextPath}/"
												style="font-size: 20px">主页</a></li>
											<li class="dropdown"><a
												href="${pageContext.request.contextPath}/aboutUs"
												style="font-size: 20px">关于我们</a>

												<ul>
													<li><a
														href="${pageContext.request.contextPath}/aboutUs">公司介绍</a></li>
													<li><a
														href="${pageContext.request.contextPath}/partners">合作伙伴</a></li>
                                                    
												</ul></li>


											<li class="dropdown"><a
												href="${pageContext.request.contextPath}/ourProducts"
												style="font-size: 20px;color:white">产品与方案</a>
												<ul>
													<li><a
														href="${pageContext.request.contextPath}/ourProducts">产品展示</a></li>
													<li><a
														href="${pageContext.request.contextPath}/solutionOne">解决方案</a></li>
													<li><a
														href="${pageContext.request.contextPath}/aboutApp">共享陪护床</a></li>
												</ul></li>
											<li><a
												href="${pageContext.request.contextPath}/contactUs"
												style="font-size: 20px">联系我们</a></li>
											<li><a
												href="${pageContext.request.contextPath}/jobPosition"
												style="font-size: 20px">人才招聘</a></li>
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

        

        <div class="nav-overlay">
            <div class="cursor"></div>
            <div class="cursor-follower"></div>
        </div>
    </header>
    <!-- End Main Header -->

    <!-- Page Title -->
    <section class="page-title" style="background-image: url(${pageContext.request.contextPath}/assets/images/background/bg-13.jpg);">
        <div class="auto-container">
            <div class="content-box">
                            
            </div>
        </div>
    </section>
    <!-- Page Title -->

    <!-- Team Section -->
    <section class="team-section">
        <div class="auto-container">
            <div class="row">
                <div class="col-lg-4 col-md-6 team-block-one">
                    <div class="inner-box">
                        <div class="image">
                            <img src="${pageContext.request.contextPath}/assets/images/resource/team-2.png" alt="">
                        </div>
                        <div class="content">
                            <h4>共享陪护床</h4>
                            <div class="designation">智造医疗 守护健康  </div>
                        </div>
                    </div>
                </div>
                
                
                <div class="col-lg-4 col-md-6 team-block-one">
                    <div class="inner-box">
                        <div class="image">
                            <img src="${pageContext.request.contextPath}/assets/images/resource/team-7.png" alt="">                        </div>
                        <div class="content">
                            <h4>移动考勤</h4>
                            <div class="designation">移动互联网 行动力提升 突破地理位置</div>
                        </div>
                    </div>
                </div>
                
                 <div class="col-lg-4 col-md-6 team-block-one">
                    <div class="inner-box">
                        <div class="image">
                            <img src="${pageContext.request.contextPath}/assets/images/resource/team-9.jpg" alt="">
                        </div>
                        <div class="content">
                            <h4>报障运维系统</h4>
                            <div class="designation">随时随地 给你设备贴身保障</div>
                        </div>
                    </div>
                </div> 
            </div>
        </div>
    </section>


    <!-- CTA Section Two -->
		<section class="cta-section-two" style="background-image:url(${pageContext.request.contextPath}/assets/images/shape/shape-2.jpg)">
			<div class="auto-container">
				<div class="wrapper-box">
					<h3>
						需要专业化的服务或产品维护 <br> 或是有任何其他问题? 我们准备好了来帮助你!
					</h3>
					<div class="link-btn">
						<a href="#" class="theme-btn btn-style-one style-three"><span>了解更多</span></a>
					</div>
					<div class="icon">
						<img
							src="${pageContext.request.contextPath}/assets/images/icons/icon-12.png"
							alt="">
					</div>
				</div>
			</div>
		</section>

		<!-- Main Footer -->
    <footer class="main-footer" style="background-image:url(${pageContext.request.contextPath}/assets/images/shape/shape-2.jpg)">
        <div class="auto-container">
            <!--Widgets Section-->
            <div class="widgets-section">
                <div class="row clearfix">
                    
                    <!--Column-->
                    <div class="column col-lg-3 col-md-6" style="flex: 0 0 35%; max-width: 30%;">
                        <div class="widget about-widget">
                            <div class="logo"><a href="#"><img src="${pageContext.request.contextPath}/assets/images/logo_new_2021_09_26.png" style="height:120px;width:337px"></a></div>
                        </div>
                    </div>
                    
                    <!--Column-->
                    <div class="column col-lg-3 col-md-6" style="flex: 0 0 20%; max-width: 20%">
                        <div class="widget links-widget" style="margin-left:30px">
                            <h3 class="widget-title" style="color:black;margin-bottom:10px;font-size:24px"><strong>我们的服务</strong></h3>
                            <div class="widget-content">
                                <ul>
                                    <li><a href="#" style="color:black" onmouseover="this.style.color='#F68D4E';" onmouseout="this.style.color='black';">规划咨询服务</a></li>
                                    <li><a href="#" style="color:black" onmouseover="this.style.color='#F68D4E';" onmouseout="this.style.color='black';">项目实施服务</a></li>
                                    <li><a href="#" style="color:black" onmouseover="this.style.color='#F68D4E';" onmouseout="this.style.color='black';">维护支持服务</a></li>
                                    <li><a href="#" style="color:black" onmouseover="this.style.color='#F68D4E';" onmouseout="this.style.color='black';">外包驻场服务</a></li>
                                    <li><a href="#" style="color:black" onmouseover="this.style.color='#F68D4E';" onmouseout="this.style.color='black';">机房搬迁服务</a></li>
                                    <li><a href="#" style="color:black" onmouseover="this.style.color='#F68D4E';" onmouseout="this.style.color='black';">软件开发服务</a></li>
                                </ul>                                        
                            </div>
                        </div>
                    </div>

                    <!--Column-->
                    <div class="column col-lg-3 col-md-6" style="flex: 0 0 20%; max-width: 20%;">
                        <div class="widget links-widget" style="margin-left:30px">
                            <h3 class="widget-title" style="color:black;margin-bottom:10px;font-size:24px"><strong>快捷链接</strong></h3>
                            <div class="widget-content">
                                <ul>
                                    <li><a href="${pageContext.request.contextPath}/aboutUs" style="color:black" onmouseover="this.style.color='#F68D4E';" onmouseout="this.style.color='black';">关于我们</a></li>
                                    <li><a href="${pageContext.request.contextPath}/ourProducts" style="color:black" onmouseover="this.style.color='#F68D4E';" onmouseout="this.style.color='black';">我们的产品</a></li>
                                    <li><a href="${pageContext.request.contextPath}/aboutApp" style="color:black" onmouseover="this.style.color='#F68D4E';" onmouseout="this.style.color='black';">共享陪护床</a></li>
                                </ul>                                        
                            </div>
                        </div>
                    </div>
                    
                    <!--Column-->
                    <div class="column col-lg-3 col-md-6" style="flex: 0 0 30%; max-width: 30%;">
                        <div class="widget contact-widget" style="margin-left:20px">
                            <h3 class="widget-title" style="color:black;margin-bottom:10px;font-size:24px"><strong>联系我们</strong></h3>
                            <div class="widget-content">
                                <ul class="contact-info">
                                    <li>
                                        <div class="icon" style="margin-left:-30px;margin-top:0px;color:#F68D4E;font-size:18px;"><span class="flaticon-gps"></span></div><a href="javascript:;" style="color:black;" id="address" onmouseover="this.style.color='#F68D4E';" onmouseout="this.style.color='black';"></a>
                                    </li>
                                    <li>
                                        <div class="icon" style="margin-left:-30px;margin-top:0px;color:#F68D4E;font-size:18px"><span class="flaticon-phone"></span></div><a href="javascript:;" style="color:black" id="tel" onmouseover="this.style.color='#F68D4E';" onmouseout="this.style.color='black';"></a>
                                    </li>
                                    <li>
                                        <div class="icon" style="margin-left:-30px;margin-top:0px;color:#F68D4E;font-size:18px"><span class="flaticon-comment"></span></div><a href="javascript:;" style="color:black" id="mail" onmouseover="this.style.color='#F68D4E';" onmouseout="this.style.color='black';"></a>
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
                    <div class="text" style="color:black">沪ICP备2021014732号</div>
                    <div class="text" style="color:black">Copyright 2020-2021上海飞默利凯科技有限公司版权所有 </div>
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
<script type="text/javascript">
$(document).ready(function() {	
	host = "${pageContext.request.contextPath}";
	getCompanyInfo();
});

function getCompanyInfo(){
	$.ajax({
		url : host + "/getCompanyInfo",
		type : 'GET',
		cache : false,
		async : false,
		data : {},
		success : function(returndata) {
			var data = eval("(" + returndata + ")").company;
			document.getElementById('address').innerHTML = data[0].address;
			document.getElementById('tel').innerHTML = data[0].companyId;
			document.getElementById('mail').innerHTML = data[0].companyName;
		},
		error : function(XMLHttpRequest, textStatus, errorThrown) {
		}
	});
}
</script>

</body>
</html>
