<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="pragma" content="no-cache" />
<meta http-equiv="cache-control" content="no-cache" />
<title>人才招聘</title>
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
	getJobList();
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

function getJobList(){
	$
	.ajax({
		url : host + "/jobPositionList",
		type : 'GET',
		data : {},
		cache : false,
		async : false,
		success : function(returndata) {
			var data = eval("(" + returndata + ")").jobPositionList;
			var jobPositionArr = new Array();
			var newJobArr = new Array();
            if(data.length>0){
	              for(var i in data){
	            	jobPositionArr.push(data[i].id+"#"+data[i].jobTitle+"#"+data[i].techDemand+"#"+data[i].level+"#"+data[i].salary+"#"+data[i].educationDemand+"#"+data[i].otherDemand);
	              }
	              if(jobPositionArr.length>0){
	            	  newJobArr = checkAndResetJobPosition(jobPositionArr); 
	              }
            }
            if(newJobArr.length>0){
            	$("#jobRow").empty();
            	for(var i in newJobArr){
            		appendJob(newJobArr[i]);
            	}
            }
		},
		error : function(XMLHttpRequest, textStatus, errorThrown) {
		}
	});
}

	function checkAndResetJobPosition(mArr){
		var tempArr = new Array();
		for(var i in mArr){
			var exist = false;
			var existNo;
			if(tempArr.length>0){
				for(var j in tempArr){
					if(mArr[i].split("#")[1] == tempArr[j].split("#")[1]){
						existNo = j;
						exist = true;
					}
				}
			}
            if(!exist){
            	tempArr.push(mArr[i]);
            }else{
            	tempArr.splice(existNo,1,tempArr[existNo]+"@"+mArr[i]);
            }
            
		}
		return tempArr;
}
	
	function appendJob(tJob){
		var str = '<div class="col-lg-4 col-md-6 news-block-two" style="flex:48%;max-width:48%;">';
		str +='<div class="inner-box"><div class="content-box"> <div class="top-content">';
		
		if(tJob.split("@").length>1){
			str +='<a><h4>'+tJob.split("@")[0].split("#")[1]+'</h4></a>';
			str +='<ul class="post-meta">';
			var arr = tJob.split("@");
			for(var i in arr){
				var t = parseInt(i)+1;
				str += '<ul class="post-meta"><li style="color:black">'+t+'）技能要求：'+arr[i].split("#")[2]+'</li></ul>';
				str += '<ul class="post-meta"><li style="color:black;margin-left:25px">学历要求：'+arr[i].split("#")[5]+'</li></ul>';
				str += '<ul class="post-meta"><li style="color:black;margin-left:25px">其他要求：'+arr[i].split("#")[6]+'</li></ul>';
				str += '<ul class="post-meta"><li style="color:black;margin-left:60px">级别：'+arr[i].split("#")[3]+'</li></ul>';
				str += '<ul class="post-meta"><li style="color:black;margin-left:60px">薪资：'+arr[i].split("#")[4]+' 起</li></ul>';
				if(t==arr.length){
				str += '<br>';}
			}
			
		}else{
			str +='<a><h4>'+tJob.split("#")[1]+'</h4></a>';
			str +='<ul class="post-meta"><li style="color:black">技能要求：'+tJob.split("#")[2]+'</li></ul>';
			str +='<ul class="post-meta"><li style="color:black">学历要求：'+tJob.split("#")[5]+'</li></ul>';
			str +='<ul class="post-meta"><li style="color:black">其他要求：'+tJob.split("#")[6]+'</li></ul>';
			str +='<ul class="post-meta"><li style="color:black;margin-left:35px">级别：'+tJob.split("#")[3]+'</li></ul>';
			str +='<ul class="post-meta"><li style="color:black;margin-left:35px">薪资：'+tJob.split("#")[4]+' 起</li></ul>';
			str += '<br>';
		}
		str +='</div></div></div></div>';
		
		$("#jobRow").append(str);
	}



</script>

</head>




<body>
<div class="page-wrapper">
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
												style="font-size: 20px">联系我们</a></li>
											<li><a
												href="${pageContext.request.contextPath}/jobPosition"
												style="font-size: 20px;color:white">人才招聘</a></li>
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
    

    <!-- Latest News -->
    <section class="latest-news-section">
        <div class="auto-container">
            <div class="row" id="jobRow">
                
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




</body>
</html>