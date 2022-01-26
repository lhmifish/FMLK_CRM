<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="pragma" content="no-cache" />
<meta http-equiv="cache-control" content="no-cache" />
<title>联系我们</title>
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
												style="font-size: 20px">产品与方案</a>
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
												style="font-size: 20px;color:white">联系我们</a></li>
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
    
    <!-- Page Title -->
    <section class="page-title" style="background-image: url(${pageContext.request.contextPath}/assets/images/background/bg-7.jpg);">
        <div class="auto-container">
            <div class="content-box">
                            
            </div>
        </div>
    </section>
    <!-- Page Title -->

    <!-- Contact Section -->
    <section class="contact-section">
        <div class="auto-container">
            <div class="row">
                <div class="col-lg-3" style="flex: 0 0 30%;max-width:30%">
                    <div class="contact-info-area mb-30">
                        <div class="sec-title mb-30">
                            <h2><strong>联系我们</strong></h2>
                        </div>
                        <ul class="contact-info">
                            <li>
                                <div class="icon"><span class="flaticon-gps"></span></div>
                                <div class="text" style="margin-top:10px" id="address1"></div>
                            </li>
                            <li>
                                <div class="icon"><span class="flaticon-phone"></span></div>
                                <div class="text" style="margin-top:10px" id="tel1"></div>
                            </li>
                             <li>
                                <div class="icon"><span class="flaticon-comment"></span></div>
                                <div class="text" style="margin-top:10px" id="mail1"></div>
                            </li>
                        </ul>
                    </div>
                </div>
                <div class="col-lg-9" style="flex: 0 0 70%;max-width:70%">
                    <div class="contact-form-area mb-30">
                        <div class="sec-title mb-30">
                            <h2><strong>留言反馈</strong></h2>
                        </div>
                        <form action="assets/inc/sendmail.php" class="contact-form" id="contact-form" method="post">
                            <div class="row">
                                <div class="form-group col-lg-6">
                                    <input name="form_name" placeholder="姓名" type="text" class="form-control">
                                </div>
                                <div class="form-group col-lg-6">
                                    <input name="form_email" placeholder="邮箱" type="email" class="form-control">
                                </div>
                                <div class="form-group col-lg-12">
                                    <input name="form_phone" placeholder="电话" type="text" class="form-control">
                                </div>
                                <div class="form-group col-lg-12">
                                    <select class="selectpicker form-control" name="form_subject">
                                        <option value="*">项目 /服务需求</option>
                                        <option value=".category-1">软件开发</option>
                                        <option value=".category-2">网络维保</option>
                                        <option value=".category-3">网络安全</option>
                                        <option value=".category-4">机房配套</option>
                                        <option value=".category-4">其他</option>
                                    </select>
                                </div>
                                <div class="form-group col-lg-12">
                                    <textarea name="form_message" placeholder="留言信息" class="form-control"></textarea>
                                </div>
                                <div class="form-group col-lg-12">
                                    <input id="form_botcheck" name="form_botcheck" class="form-control" type="hidden" value="">
                                    <button class="theme-btn btn-style-one w-100" type="submit" id="myBtn" onclick="sendMessage()"><span>发送留言</span></button>
                                </div>
                            </div>                                
                        </form>
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
<script src="${pageContext.request.contextPath}/assets/js/validate.js"></script>

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
			document.getElementById('address1').innerHTML = data[0].address;
			document.getElementById('tel1').innerHTML = data[0].companyId;
			document.getElementById('mail1').innerHTML = data[0].companyName;
		},
		error : function(XMLHttpRequest, textStatus, errorThrown) {
		}
	});
}

function sendMessage(){
	/* setTimeout(function () {
		alert("发送成功");
		 }, 3000);
	$("#myBtn").dequeue();  */
	$("#myBtn").delay(3000).queue(function () {
		alert("发送成功");
        
		});
	
}

</script>

</body>
</html>













