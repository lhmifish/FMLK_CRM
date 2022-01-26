<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="pragma" content="no-cache" />
<meta http-equiv="cache-control" content="no-cache" />
<meta name="viewport" content="width=device-width, minimum-scale=1.0, maximum-scale=2.0"/>
<title>上海飞默利凯科技有限公司</title>
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

<link rel="shortcut icon"
	href="${pageContext.request.contextPath}/assets/images/favicon.png"
	type="image/x-icon">
<link rel="icon"
	href="${pageContext.request.contextPath}/assets/images/favicon.png"
	type="image/x-icon">
	
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/xcConfirm.css?v=1000" />
<style>
.xcConfirm .popBox {
	background-color: #ffffff;
	width: 350px;
	height: 550px;
	border-radius: 5px;
	font-weight: bold;
	color: #535e66;
	top: 160px;
	margin-left: -170px; 
}

.xcConfirm .popBox .txtBox{
       margin: 0px 0px; 
       height: 550px; 
       overflow: hidden;
 }
 
 .xcConfirm .popBox .ttBox{
       margin: 0px 0px; 
       height: 0px; 
       overflow: hidden;
       padding:0px 0px;
       border-bottom: solid 0px #eef0f1;
 }
 
 .xcConfirm .popBox .btnArea{
      border-top: solid 0px #eef0f1;
 }
 
 .xcConfirm .popBox .txtBox p {
    height: 600px;
    margin: 0px;
    }
　　 
</style>
	
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

<body id="mBody">

	<div class="page-wrapper">

		<!-- Main Header Logo&菜单-->
		<header class="main-header header-style-two">
			<!-- Top -->
			<div class="header-upper style-two">
				<div class="auto-container">
					<div class="inner-container">
						<!--Logo-->
						<div class="logo-box" style="width:350px;">
							<img 
									src="${pageContext.request.contextPath}/assets/images/logo_new_2021_09_26.png"
									alt="" style="padding:30px">
						</div>
						<!--Menu-->
						<div class="right-column">
							<!--Nav Box-->
							<div class="nav-outer">

								<!-- Main Menu -->
								<nav class="main-menu navbar-expand-md navbar-light" style="box-shadow: 2px 4px 6px #5EC7CE;background-color:#5EC7CE">
									<div class="collapse navbar-collapse show clearfix"
										id="navbarSupportedContent" >
										<ul class="navigation" style="height:70px">
											<!--Menu Column1-->
											<li><a
												href="${pageContext.request.contextPath}/"
												style="font-size: 20px; color: white">主页</a>
											</li>
											<!--Menu Column2-->
											<li class="dropdown"><a
												href="${pageContext.request.contextPath}/aboutUs"
												style="font-size: 20px">关于我们</a>
												<ul>
													<li><a
														href="${pageContext.request.contextPath}/aboutUs">公司介绍</a></li>
													<li><a
														href="${pageContext.request.contextPath}/partners">合作伙伴</a></li>
												</ul>
											</li>
                                            <!--Menu Column3-->
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
												</ul>
											</li>
											<!--Menu Column4-->
											<li><a
												href="${pageContext.request.contextPath}/contactUs"
												style="font-size: 20px">联系我们</a></li>
											<!--Menu Column5-->
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
			<!--End Top-->
		</header>
		<!-- End Main Header -->

		<!-- Bnner Section 轮播图-->
		<section class="banner-section style-two">
			<div class="swiper-container banner-slider">
				<div class="swiper-wrapper">
					<!-- Banner One -->
					<div class="swiper-slide"
						style="background-image: url(${pageContext.request.contextPath}/assets/images/main-slider/bannerOne.jpg);">
						<div class="content-outer">
							<div class="content-box">
								<div class="inner" >
									<h1 style="font-size:36px;color:black;font-weight: bold; ">用户至上&emsp;品质卓越&emsp;开拓创新</h1>
									<div class="text" style="font-size:20px;color:black;font-weight: bold; ">
										⦾ 解决用户的痛点是我们追求的目标&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;<br><br>⦾ 产品及服务的品质是我们生存的前提&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;<br><br>⦾ 鼓励从内容到形式的创新&emsp;勇于尝试&emsp;接受试错&emsp;&emsp;
									</div>
									<div class="link-box">
										<a href="#" class="theme-btn btn-style-one" ><span>了解更多</span></a>
									</div>
								</div>
							</div>
						</div>
					</div>
					<!-- End Banner One -->
					<!-- Banner Two -->
					<div class="swiper-slide"
						style="background-image: url(${pageContext.request.contextPath}/assets/images/main-slider/bannerTwo.jpg);">
						<div class="content-outer">
							<div class="content-box">
								<div class="inner">
									<h1 style="font-size:36px;color:black;font-weight: bold; ">用户至上&emsp; 品质卓越 &emsp;开拓创新</h1>
									<div class="text" style="font-size:20px;color:black;font-weight: bold; ">
										⦾ 解决用户的痛点是我们追求的目标&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;<br><br>⦾ 产品及服务的品质是我们生存的前提&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;<br><br>⦾ 鼓励从内容到形式的创新&emsp;勇于尝试&emsp;接受试错&emsp;&emsp;
									</div>
									<div class="link-box">
										<a href="#" class="theme-btn btn-style-one" ><span>了解更多</span></a>
									</div>
								</div>
							</div>
						</div>
					</div>
					<!-- End Banner Two -->
				</div>
			</div>
			<div class="banner-slider-nav">
				<!-- Bnner previous -->
				<div class="banner-slider-control banner-slider-button-prev">
					<span><i class="far fa-angle-left"></i></span>
				</div>
				<!-- Bnner next -->
				<div class="banner-slider-control banner-slider-button-next">
					<span><i class="far fa-angle-right"></i></span>
				</div>
			</div>
		</section>
		<!-- End Bnner Section -->

		<!-- Features Section Three -->
		<section class="features-section-three style-two"
			style="padding-top: 20px; padding-bottom: 0px">
			<div class="auto-container">
				<div class="row">
					<div class="col-xl-3 col-md-6 feature-block-three">
						<div class="icon-box">
							<div class="icon">
								<img
									src="${pageContext.request.contextPath}/assets/images/icons/icon-13.png"
									alt="">
							</div>
							<h4>安全 & 可靠</h4>
							<!-- <a href="#" class="read-more-btn"><i
								class="fas fa-long-arrow-right"></i>更多</a> -->
							<div class="overlay" style="background-color:#5EC7CE;height: 100%;">
								<div class="icon">
									<img
										src="${pageContext.request.contextPath}/assets/images/icons/icon-17.png"
										alt="">
								</div>
								<h4>安全 & 可靠</h4>
								<div class="text" style="font-size:14px">
									飞默利凯的业务技术团队拥有<br>多年来的集成经验和各种专业认证<br>为用户提供坚强的保障
								</div>
							</div>
						</div>
					</div>
					<div class="col-xl-3 col-md-6 feature-block-three">
						<div class="icon-box">
							<div class="icon">
								<img
									src="${pageContext.request.contextPath}/assets/images/icons/icon-14.png"
									alt="">
							</div>
							<h4>统筹的管理</h4>
							<div class="overlay" style="background-color:#5EC7CE;height: 100%;">
								<div class="icon">
									<img
										src="${pageContext.request.contextPath}/assets/images/icons/icon-18.png"
										alt="">
								</div>
								<h4>统筹的管理</h4>
								<div class="text" style="font-size:14px">
									飞默利凯公司的技术服务部门可以提供<br>对多厂家设备的维护与管理方案<br>帮助客户实现统一的项目实施与管理
								</div>
							</div>
						</div>
					</div>
					<div class="col-xl-3 col-md-6 feature-block-three">
						<div class="icon-box">
							<div class="icon">
								<img
									src="${pageContext.request.contextPath}/assets/images/icons/icon-15.png"
									alt="">
							</div>
							<h4>专业的服务</h4>
							<div class="overlay" style="background-color:#5EC7CE;height: 100%;">
								<div class="icon">
									<img
										src="${pageContext.request.contextPath}/assets/images/icons/icon-19.png"
										alt="">
								</div>
								<h4>专业的服务</h4>
								<div class="text" style="font-size:14px">
									飞默利凯的技术团队<br>为用户提供优质的专业服务<br>免费支持热线每周7 x 24小时<br>解答各种网络技术问题
								</div>
							</div>
						</div>
					</div> 
					<div class="col-xl-3 col-md-6 feature-block-three">
						<div class="icon-box">
							<div class="icon">
								<img
									src="${pageContext.request.contextPath}/assets/images/icons/icon-16.png"
									alt="">
							</div>
							<h4>高品质售后</h4>
							<div class="overlay" style="background-color:#5EC7CE;height:100%;">
								<div class="icon">
									<img 
										src="${pageContext.request.contextPath}/assets/images/icons/icon-20.png"
										alt="">
								</div>
								<h4>高品质售后</h4>
								<div class="text" style="font-size:14px;">
									飞默利凯公司已建立完美的售后<br>支持实验室和用户服务中心<br>通过网络在线和电话等各种方式<br>的联络让用户无忧
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</section>

		<!-- Features Section Two -->
		<section class="features-section-two style-two">
			<div class="auto-container">

				<div class="single-block">
					<div class="row">
						<div class="col-lg-6 image-column">
							<div class="image">
								<img
									src="${pageContext.request.contextPath}/assets/images/resource/image-15.jpg"
									alt="">
							</div>
						</div>
						<div class="col-lg-6">
							<div class="content">
								<div class="sec-title">
									<h2>
										<strong>产品与解决方案</strong>
									</h2>
									<div class="text">飞默利凯具备丰富的产品资源，公司凭借技术优势为用户提供适用的解决方案和系统建设。为用户设计开发的系统架构，确保用户具有广泛的选择性和扩张性，提供丰富的产品组合，提交给用户高可用性、高可靠性和低成本的先进信息系统。</div>
									<div class="link-btn">
										<a href="${pageContext.request.contextPath}/ourProducts"
											class="theme-btn btn-style-one"><span>了解更多</span></a>
									</div>
								</div>
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
	
	<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/xcConfirm.js?v=2018"></script>
	
	
<script type="text/javascript">
$(document).ready(function() {	
	host = "${pageContext.request.contextPath}";
	getCompanyInfo();
	//getQRCodePage();
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

function getQRCodePage(){
	var div = '<div id="floatImg"><a href="${pageContext.request.contextPath}/aboutApp"><img src="${pageContext.request.contextPath}/image/app20210929.jpg"  style="width: 350px;height: 550px;" alt=""></a></div>';
		window.wxc.xcConfirm(div, {
			title : "",
			btn : "",
			icon : "",
		}, {
			onClose : function() {

			}
		});	
}
</script>
</body>
</html>