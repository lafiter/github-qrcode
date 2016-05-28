<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>裁剪Demo</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<link rel="stylesheet" type="text/css"
			href="<%=request.getContextPath()%>/css/jquery.Jcrop.css">
		<script src="<%=request.getContextPath()%>/js/jquery.min.js"></script>
		<script src="<%=request.getContextPath()%>/js/jquery.Jcrop.min.js"></script>
		<style>
			
			.jcrop-holder #preview_box {
			  display: block;
			  position: absolute;
			  z-index: 2000;
			  top: 10px;
			  right: -280px;
			  padding: 6px;
			  border: 1px rgba(0,0,0,.4) solid;
			  background-color: white;
			  -webkit-border-radius: 6px;
			  -moz-border-radius: 6px;
			  border-radius: 6px;
			  -webkit-box-shadow: 1px 1px 5px 2px rgba(0, 0, 0, 0.2);
			  -moz-box-shadow: 1px 1px 5px 2px rgba(0, 0, 0, 0.2);
			  box-shadow: 1px 1px 5px 2px rgba(0, 0, 0, 0.2);
			}
		
			#preview_box .preview-container {
			  width: 200px;
			  height: 200px;
			  overflow: hidden;
			}
			
		</style>
		<script>
			var jcrop_api,boundx,boundy;
			$(function(){
				$("#iframe-hidden").bind("load",function(){
					var imgpath = $("#iframe-hidden").contents().find("pre").text();
					$("#srcImg").attr("src","."+imgpath);
					$("#previewImg").attr("src","."+imgpath);
					cutImage();
				});
			});
			//裁剪图像
			function cutImage(){
				$("#srcImg").Jcrop( {
					aspectRatio : 1,
					onChange : showCoords,
					onSelect : showCoords,
					minSize :[200,200]
				},function(){
			      // Use the API to get the real image size
			      var bounds = this.getBounds();
			      boundx = bounds[0];
			      boundy = bounds[1];
			      // Store the API in the jcrop_api variable
			      jcrop_api = this;
			      // Move the preview into the jcrop container for css positioning
			      //$preview.appendTo(jcrop_api.ui.holder);
			    });
				//简单的事件处理程序，响应自onChange,onSelect事件，按照上面的Jcrop调用
				function showCoords(obj) {
					$("#x").val(obj.x);
					$("#y").val(obj.y);
					$("#w").val(obj.w);
					$("#h").val(obj.h);
					
					if (parseInt(obj.w) > 0) {
						//计算预览区域图片缩放的比例，通过计算显示区域的宽度(与高度)与剪裁的宽度(与高度)之比得到
						var rx = $("#preview_box .preview-container").width() / obj.w;
						var ry = $("#preview_box .preview-container").height() / obj.h;
						//通过比例值控制图片的样式与显示
						$("#previewImg").css( {
							width : Math.round(rx * boundx) + "px", //预览图片宽度为计算比例值与原图片宽度的乘积
							height : Math.round(ry * boundy) + "px", //预览图片高度为计算比例值与原图片高度的乘积
							marginLeft : "-" + Math.round(rx * obj.x) + "px",
							marginTop : "-" + Math.round(ry * obj.y) + "px"
						});
					}
				}
			}
			function changeFile(){
				var file = $("#fName").val();
				$("#fileName").val(file);
			}
		</script>
	</head>
	<body>
		<form method="post" action="clipUpload" enctype="multipart/form-data"
			target="iframe-hidden">
			<input type="text" name="name" />
			<input type="file" name="file" id="fName" onchange="changeFile(this)"/>
			<input type="submit" />
		</form>
		<iframe id="iframe-hidden" name="iframe-hidden" style="display:none;"></iframe>
		<div id="cutImage">
			<div class="bigImg" style="float: left;">
				<img id="srcImg" src="" width="400px" height="270px" />
			</div>
			<div id="preview_box">
			    <div class="preview-container">
			      <img id="previewImg" src="" class="jcrop-preview" alt="Preview" />
			    </div>
			</div>
			<div>
				<form action="crop_form" method="post" id="crop_form">
					<input type="hidden" id="bigImage" name="bigImage" />
					<input type="hidden" id="x" name="x" />
					<input type="hidden" id="y" name="y" />
					<input type="hidden" id="w" name="w" />
					<input type="hidden" id="h" name="h" />
					<input type="hidden" id="fileName" name="fileName" />
					<p>
						<input type="submit" value="确认" id="crop_submit" />
					</p>
				</form>
			</div>
		</div>
	</body>
</html>
