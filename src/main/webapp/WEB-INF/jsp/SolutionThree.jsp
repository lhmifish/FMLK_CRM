<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="pragma" content="no-cache" />
<meta http-equiv="cache-control" content="no-cache" />
<title>远程会诊解决方案</title>
<!-- Stylesheets -->
<link href="${pageContext.request.contextPath}/assets/css/bootstrap.css"
	rel="stylesheet">
<link href="${pageContext.request.contextPath}/assets/css/style.css?v=1000"
	rel="stylesheet">
<!-- Responsive File -->
<link
	href="${pageContext.request.contextPath}/assets/css/responsive.css"
	rel="stylesheet">
<!-- Color File -->
<link href="${pageContext.request.contextPath}/assets/css/color.css?v=1000"
	rel="stylesheet">

<link rel="shortcut icon" href="assets/images/favicon.png"
	type="image/x-icon">
<link rel="icon" href="assets/images/favicon.png" type="image/x-icon">

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
			<div class="preloader">
				<div class="preloader-close">Preloader Close</div>
			</div>
			<div class="layer layer-one">
				<span class="overlay"></span>
			</div>
			<div class="layer layer-two">
				<span class="overlay"></span>
			</div>
			<div class="layer layer-three">
				<span class="overlay"></span>
			</div>
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

		</header>
		<!-- End Main Header -->


		<!-- Page Title -->
		<section class="page-title"
			style="background-image: url(${pageContext.request.contextPath}/assets/images/main-slider/bgImg_2.jpg);">
			<div class="auto-container">
				<div class="content-box"></div>
			</div>
		</section>
		<!-- Page Title -->

		<!-- Service Details -->
		<section class="services-details">
			<div class="auto-container">
				<div class="row">
					<div class="col-lg-8 content-side order-lg-2">
						<div class="image mb-40">
							<img
								src="${pageContext.request.contextPath}/assets/images/resource/image-35.png"
								alt="">
						</div>
						<h2>远程会诊解决方案</h2>
						<div class="text">
							<p style="font-size:20px">
								<strong>除了法令法规及现实商业模式对“远程医疗”的限制，</strong>
							</p>
							<p style="font-size:20px">
								<strong>整个远程医疗业务系统在基础建设过程中仍然面临着挑战：</strong>
							</p>
							<p>
								较低的视频编解码性能影响远程诊断效果；
							</p>
							<p>
								医疗影像设备接口类型多，不能与远程会诊设备顺利对接；
							</p>
							<p>
								会诊平台与视讯会诊分离，不能统一调度和管理；
							</p>
							<p>
								受限于物理环境局限，面向家庭、基层医疗机构和户外应急的业务难以开展。
							</p>
						</div>

						<div class="text">
							<p style="font-size:20px"> 
								<strong>飞默利凯从远程医疗视讯平台、专业医疗终端，SDK接口到行业合作伙伴的远程医疗业务平台，提供完整的远程医疗解决方案。</strong>
							</p>
							<p>双路1080P动态图像技术，高清的传输和呈现，打破了传统远程会诊非实时、低清晰度、临场感差的限制。多路医疗数据采集与呈现。医疗数据采集系统采用标准接口,提供多种医疗设备接口，支持与主流的医疗设备对接。系统最高支持19路医疗视频信号接入，并能够同时显示4路信号，辅助专家给出指导意见。</p>
							<p>远程会诊解决方案秉承开放的原则和标准化的设计理念，提供开放的第三方接口，与医疗信息行业主流厂家深度合作，提供完整的医疗平台融合方案。采用最新的H.264编解码技术，大大提高了图像压缩效率，在同等带宽下，可向用户提供更逼真、更清晰、更流畅的画面。</p>

						</div>
						<div class="testimonial">
							
						</div>

					</div>
					<aside class="col-lg-4 sidebar">
						<div class="service-sidebar">
							<div class="widget widget_categories_two">
								<div class="widget-content">
									<ul>
										<li><a
											href="${pageContext.request.contextPath}/solutionOne">基础网络架构方案</a></li>
										<li><a
											href="${pageContext.request.contextPath}/solutionTwo">网络安全方案</a></li>
										<li class="current"><a
											href="${pageContext.request.contextPath}/solutionThree">远程会诊方案</a></li>
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
	<div class="scroll-to-top scroll-to-target" data-target="html">
		<span class="flaticon-right-arrow"></span>
	</div>

	<script src="${pageContext.request.contextPath}/assets/js/jquery.js"></script>
	<script
		src="${pageContext.request.contextPath}/assets/js/popper.min.js"></script>
	<script
		src="${pageContext.request.contextPath}/assets/js/bootstrap.min.js"></script>
	<script
		src="${pageContext.request.contextPath}/assets/js/bootstrap-select.min.js"></script>
	<script
		src="${pageContext.request.contextPath}/assets/js/jquery.fancybox.js"></script>
	<script src="${pageContext.request.contextPath}/assets/js/isotope.js"></script>
	<script src="${pageContext.request.contextPath}/assets/js/owl.js"></script>
	<script src="${pageContext.request.contextPath}/assets/js/appear.js"></script>
	<script src="${pageContext.request.contextPath}/assets/js/wow.js"></script>
	<script src="${pageContext.request.contextPath}/assets/js/lazyload.js"></script>
	<script src="${pageContext.request.contextPath}/assets/js/scrollbar.js"></script>
	<script
		src="${pageContext.request.contextPath}/assets/js/TweenMax.min.js"></script>
	<script
		src="${pageContext.request.contextPath}/assets/js/swiper.min.js"></script>

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