// Js  Set   集合特效包




//社区nav头部JS
// JavaScript Document
$(function(){
		changeNavLeft1Height();
		$(window).resize(function(){
			changeNavLeft1Height();
		})
		var ani = 0;
		$(".nav-btn1").click(function(){
			if(ani==0){
				$(".nav-left1").animate({left:"-=255px"},100);
				ani++;
				return;
				}
				if(ani==1){
					$(".nav-left1").animate({left:"+=255px"},100);
					ani--;
				}
				return;
			});
	});
function changeNavLeft1Height(){
		 var  screenheight,navheight;
		  screenheight = $(window).height();
		  navheight = screenheight - 40;
		 $(".nav-left1").css( "height",navheight);	
		 //获取高度 设置高度
		 }


$(function(){
		changeNavLeft2Height();
		$(window).resize(function(){
			changeNavLeft2Height();
		})


		var ani = 0;
		$(".nav-btn2").click(function(){
			if(ani==0){
				$(".nav-right1").animate({right:"-=255px"},100);
				ani++;
				return;
				}
				if(ani==1){
					$(".nav-right1").animate({right:"+=255px"},100);
					ani--;
				}
				return;
			});
	});
	function changeNavLeft2Height(){
		 var  screenheight,navheight;
		  screenheight = $(window).height();
		  navheight = screenheight - 40;
		 $(".nav-right1").css( "height",navheight);	
		 //获取高度 设置高度
		 }








//社区头部导航折叠JS
$(function(){ 
    $("#sns_nav").smartFloat(); 
}); 






//社区头部导航固定JS
// JavaScript Document
$.fn.smartFloat = function() { 
    var position = function(element) { 
        var top = element.position().top; //当前元素对象element距离浏览器上边缘的距离 
        var pos = element.css("position"); //当前元素距离页面document顶部的距离 
        $(window).scroll(function() { //侦听滚动时 
            var scrolls = $(this).scrollTop(); 
            if (scrolls > top) { //如果滚动到页面超出了当前元素element的相对页面顶部的高度 
                if (window.XMLHttpRequest) { //如果不是ie6 
                    element.css({ //设置css 
                        position: "fixed", //固定定位,即不再跟随滚动 
                        top: 0 //距离页面顶部为0 
                    }).addClass("shadow"); //加上阴影样式.shadow 
                } else { //如果是ie6 
                    element.css({ 
                        top: scrolls  //与页面顶部距离 
                    });     
                } 
            }else { 
                element.css({ //如果当前元素element未滚动到浏览器上边缘，则使用默认样式 
                    position: pos, 
                    top: top 
                }).removeClass("shadow");//移除阴影样式.shadow 
            } 
        }); 
    }; 
    return $(this).each(function() { 
        position($(this));                          
    }); 
}; 









//返回顶部，微信弹出
function b(){
	h = $(window).height();
	t = $(document).scrollTop();
	if(t > h){
		$('#gotop,#code').show();
	}else{
		$('#gotop,#code').hide();
	}
}
$(document).ready(function(e) {
	b();
	$('#gotop').click(function(){
		$(document).scrollTop(0);	
	})
	$('#code').hover(function(){
			$(this).attr('id','code_hover');
			$('#code_img').show(300);
		},function(){
			$(this).attr('id','code');
			$('#code_img').hide();
	})
	
});

$(window).scroll(function(e){
	b();		
})










//说说文章-更多-公开  弹出层
$(document).ready(function(){
						  $(".snshide").click(function(){
						  $(".snsshow").toggle();
						  });
						});

$(document).ready(function(){
						  $(".snshide1").click(function(){
						  $(".snsshow1").toggle();
						  });
						});










//瀑布流ID名字 点击 弹出层
$(document).ready(function(){
						  $(".snshideid").click(function(){
						  $(".snsshowid").toggle();
						  });
						});








//瀑布流评论系统 点击 弹出层
$(document).ready(function(){
		  $(".up1").click(function(){
		  $(".up_mian").toggle();
		  });
		});





















// 右侧折叠导航 焦点图
(function(d,D,v){d.fn.responsiveSlides=function(h){var b=d.extend({auto:!0,speed:1E3,timeout:3E3,pager:!1,nav:!1,random:!1,pause:!1,pauseControls:!1,prevText:"Previous",nextText:"Next",maxwidth:"",controls:"",namespace:"rslides",before:function(){},after:function(){}},h);return this.each(function(){v++;var e=d(this),n,p,i,k,l,m=0,f=e.children(),w=f.size(),q=parseFloat(b.speed),x=parseFloat(b.timeout),r=parseFloat(b.maxwidth),c=b.namespace,g=c+v,y=c+"_nav "+g+"_nav",s=c+"_here",j=g+"_on",z=g+"_s",
o=d("<ul class='"+c+"_tabs "+g+"_tabs' />"),A={"float":"left",position:"relative"},E={"float":"none",position:"absolute"},t=function(a){b.before();f.stop().fadeOut(q,function(){d(this).removeClass(j).css(E)}).eq(a).fadeIn(q,function(){d(this).addClass(j).css(A);b.after();m=a})};b.random&&(f.sort(function(){return Math.round(Math.random())-0.5}),e.empty().append(f));f.each(function(a){this.id=z+a});e.addClass(c+" "+g);h&&h.maxwidth&&e.css("max-width",r);f.hide().eq(0).addClass(j).css(A).show();if(1<
f.size()){if(x<q+100)return;if(b.pager){var u=[];f.each(function(a){a=a+1;u=u+("")});o.append(u);l=o.find("a");h.controls?d(b.controls).append(o):e.after(o);n=function(a){l.closest("li").removeClass(s).eq(a).addClass(s)}}b.auto&&(p=function(){k=setInterval(function(){var a=m+1<w?m+1:0;b.pager&&n(a);t(a)},x)},p());i=function(){if(b.auto){clearInterval(k);p()}};b.pause&&e.hover(function(){clearInterval(k)},function(){i()});b.pager&&(l.bind("click",function(a){a.preventDefault();
b.pauseControls||i();a=l.index(this);if(!(m===a||d("."+j+":animated").length)){n(a);t(a)}}).eq(0).closest("li").addClass(s),b.pauseControls&&l.hover(function(){clearInterval(k)},function(){i()}));if(b.nav){c="<a href='#' class='"+y+" prev'>"+b.prevText+"</a><a href='#' class='"+y+" next'>"+b.nextText+"</a>";h.controls?d(b.controls).append(c):e.after(c);var c=d("."+g+"_nav"),B=d("."+g+"_nav.prev");c.bind("click",function(a){a.preventDefault();if(!d("."+j+":animated").length){var c=f.index(d("."+j)),
a=c-1,c=c+1<w?m+1:0;t(d(this)[0]===B[0]?a:c);b.pager&&n(d(this)[0]===B[0]?a:c);b.pauseControls||i()}});b.pauseControls&&c.hover(function(){clearInterval(k)},function(){i()})}}if("undefined"===typeof document.body.style.maxWidth&&h.maxwidth){var C=function(){e.css("width","100%");e.width()>r&&e.css("width",r)};C();d(D).bind("resize",function(){C()})}})}})(jQuery,this,0);
$(function() {
    $(".f426x240").responsiveSlides({
        auto: true,
        pager: true,
        nav: true,
        speed: 300,
        maxwidth: 178
    });
    $(".f160x160").responsiveSlides({
        auto: true,
        pager: true,
        speed: 300,
        maxwidth: 160
    });
});
















//筛选功能输入框JS样式

 $(document).ready(function(){
   $(".select_box").click(function(event){   
    event.stopPropagation();
    $(this).find(".option").toggle();
    $(this).parent().siblings().find(".option").hide();
   });
   $(document).click(function(event){
    var eo=$(event.target);
    if($(".select_box").is(":visible") && eo.attr("class")!="option" && !eo.parent(".option").length)
    $('.option').hide();           
   });
   /*赋值给文本框*/
   $(".option a").click(function(){
    var value=$(this).text();
    $(this).parent().siblings(".select_txt").text(value);
    $("#select_value").val(value)
    })
  })

















//3d模块轮播小图，成就展示
function ZoomPic ()
{
	this.initialize.apply(this, arguments)	
}
ZoomPic.prototype = 
{
	initialize : function (id)
	{
		var _this = this;
		this.wrap = typeof id === "string" ? document.getElementById(id) : id;
		this.oUl = this.wrap.getElementsByTagName("ul")[0];
		this.aLi = this.wrap.getElementsByTagName("li");
		this.prev = this.wrap.getElementsByTagName("span")[0];
		this.next = this.wrap.getElementsByTagName("span")[1];
		this.timer = 0;
		this.aSort = [];
		this.iCenter = 0;
		this._doPrev = function () {return _this.doPrev.apply(_this)};
		this._doNext = function () {return _this.doNext.apply(_this)};
		this.options = [
			/*{width:476, height:210, top:40, left:0, zIndex:1},
			{width:426, height:250, top:20, left:50, zIndex:2},
			{width:654, height:290, top:0, left:150, zIndex:3},
			{width:426, height:250, top:20, left:480, zIndex:2},
			{width:476, height:210, top:40, left:476, zIndex:1},*/
			{width:70, height:30, top:20, left:60, zIndex:1},
			{width:70, height:80, top:10, left:0, zIndex:2},
			{width:70, height:100, top:0, left:30, zIndex:3},
			{width:70, height:80, top:10, left:60, zIndex:2},
			{width:70, height:30, top:20, left:30, zIndex:1},
		];
		for (var i = 0; i < this.aLi.length; i++) this.aSort[i] = this.aLi[i];
		this.aSort.unshift(this.aSort.pop());
		this.setUp();
		this.addEvent(this.prev, "click", this._doPrev);
		this.addEvent(this.next, "click", this._doNext);
//		this.doImgClick();		
//		this.timer = setInterval(function ()
//		{
//			_this.doNext()	
//		}, 3000);		
//		this.wrap.onmouseover = function ()
//		{
//			clearInterval(_this.timer)	
//		};
//		this.wrap.onmouseout = function ()
//		{
//			_this.timer = setInterval(function ()
//			{
//				_this.doNext()	
//			}, 3000);	
//		}
	},
	doPrev : function ()
	{
		this.aSort.unshift(this.aSort.pop());
		this.setUp()
	},
	doNext : function ()
	{
		this.aSort.push(this.aSort.shift());
		this.setUp()
	},
	doImgClick : function ()
	{
		var _this = this;
		for (var i = 0; i < this.aSort.length; i++)
		{
			this.aSort[i].onclick = function ()
			{
				if (this.index > _this.iCenter)
				{
					for (var i = 0; i < this.index - _this.iCenter; i++) _this.aSort.push(_this.aSort.shift());
					_this.setUp()
				}
				else if(this.index < _this.iCenter)
				{
					for (var i = 0; i < _this.iCenter - this.index; i++) _this.aSort.unshift(_this.aSort.pop());
					_this.setUp()
				}
			}
		}
	},
	setUp : function ()
	{
		var _this = this;
		var i = 0;
		for (i = 0; i < this.aSort.length; i++) this.oUl.appendChild(this.aSort[i]);
		for (i = 0; i < this.aSort.length; i++)
		{
			this.aSort[i].index = i;
			if (i < 5)
			{
				this.css(this.aSort[i], "display", "block");
				this.doMove(this.aSort[i], this.options[i], function ()
				{
					_this.doMove(_this.aSort[_this.iCenter].getElementsByTagName("img")[0], {opacity:100}, function ()
					{
						_this.doMove(_this.aSort[_this.iCenter].getElementsByTagName("img")[0], {opacity:100}, function ()
						{
							_this.aSort[_this.iCenter].onmouseover = function ()
							{
								_this.doMove(this.getElementsByTagName("div")[0], {bottom:0})
							};
							_this.aSort[_this.iCenter].onmouseout = function ()
							{
								_this.doMove(this.getElementsByTagName("div")[0], {bottom:-100})
							}
						})
					})
				});
			}
			else
			{
				this.css(this.aSort[i], "display", "none");
				this.css(this.aSort[i], "width", 0);
				this.css(this.aSort[i], "height", 0);
				this.css(this.aSort[i], "top", 37);
				this.css(this.aSort[i], "left", this.oUl.offsetWidth / 2)
			}
			if (i < this.iCenter || i > this.iCenter)
			{
				this.css(this.aSort[i].getElementsByTagName("img")[0], "opacity", 100)
				this.aSort[i].onmouseover = function ()
				{
					_this.doMove(this.getElementsByTagName("img")[0], {opacity:100})	
				};
				this.aSort[i].onmouseout = function ()
				{
					_this.doMove(this.getElementsByTagName("img")[0], {opacity:100})
				};
				this.aSort[i].onmouseout();
			}
			else
			{
				this.aSort[i].onmouseover = this.aSort[i].onmouseout = null
			}
		}		
	},
	addEvent : function (oElement, sEventType, fnHandler)
	{
		return oElement.addEventListener ? oElement.addEventListener(sEventType, fnHandler, false) : oElement.attachEvent("on" + sEventType, fnHandler)
	},
	css : function (oElement, attr, value)
	{
		if (arguments.length == 2)
		{
			return oElement.currentStyle ? oElement.currentStyle[attr] : getComputedStyle(oElement, null)[attr]
		}
		else if (arguments.length == 3)
		{
			switch (attr)
			{
				case "width":
				case "height":
				case "top":
				case "left":
				case "bottom":
					oElement.style[attr] = value + "px";
					break;
				case "opacity" :
					oElement.style.filter = "alpha(opacity=" + value + ")";
					oElement.style.opacity = value / 100;
					break;
				default :
					oElement.style[attr] = value;
					break
			}	
		}
	},
	doMove : function (oElement, oAttr, fnCallBack)
	{
		var _this = this;
		clearInterval(oElement.timer);
		oElement.timer = setInterval(function ()
		{
			var bStop = true;
			for (var property in oAttr)
			{
				var iCur = parseFloat(_this.css(oElement, property));
				property == "opacity" && (iCur = parseInt(iCur.toFixed(2) * 100));
				var iSpeed = (oAttr[property] - iCur) / 5;
				iSpeed = iSpeed > 0 ? Math.ceil(iSpeed) : Math.floor(iSpeed);
				
				if (iCur != oAttr[property])
				{
					bStop = false;
					_this.css(oElement, property, iCur + iSpeed)
				}
			}
			if (bStop)
			{
				clearInterval(oElement.timer);
				fnCallBack && fnCallBack.apply(_this, arguments)	
			}
		}, 30)
	}
};
window.onload = function ()
{
	new ZoomPic("focus_Box");
};














//社区个人主页，小4图轮播插件JS
$(function(){
    var page = 1;
    var i = 6; //每版放4个图片
    //向后 按钮
    $("span.nexts").click(function(){    //绑定click事件
	     var $parent = $(this).parents("div.v_show");//根据当前点击元素获取到父元素
		 var $v_show = $parent.find("div.v_content_list"); //寻找到“视频内容展示区域”
		 var $v_content = $parent.find("div.v_content"); //寻找到“视频内容展示区域”外围的DIV元素
		 var v_width = $v_content.width() ;
		 var len = $v_show.find("li").length;
		 var page_count = Math.ceil(len / i) ;   //只要不是整数，就往大的方向取最小的整数
		 if( !$v_show.is(":animated") ){    //判断“视频内容展示区域”是否正在处于动画
			  if( page == page_count ){  //已经到最后一个版面了,如果再向后，必须跳转到第一个版面。
				$v_show.animate({ left : '0px'}, "slow"); //通过改变left值，跳转到第一个版面
				page = 1;
				}else{
				$v_show.animate({ left : '-='+v_width }, "slow");  //通过改变left值，达到每次换一个版面
				page++;
			 }
		 }
		 $parent.find("span").eq((page-1)).addClass("current").siblings().removeClass("current");
   });
    //往前 按钮
    $("span.prevs").click(function(){
	     var $parent = $(this).parents("div.v_show");//根据当前点击元素获取到父元素
		 var $v_show = $parent.find("div.v_content_list"); //寻找到“视频内容展示区域”
		 var $v_content = $parent.find("div.v_content"); //寻找到“视频内容展示区域”外围的DIV元素
		 var v_width = $v_content.width();
		 var len = $v_show.find("li").length;
		 var page_count = Math.ceil(len / i) ;   //只要不是整数，就往大的方向取最小的整数
		 if( !$v_show.is(":animated") ){    //判断“视频内容展示区域”是否正在处于动画
		 	 if( page == 1 ){  //已经到第一个版面了,如果再向前，必须跳转到最后一个版面。
				$v_show.animate({ left : '-='+v_width*(page_count-1) }, "slow");
				page = page_count;
			}else{
				$v_show.animate({ left : '+='+v_width }, "slow");
				page--;
			}
		}
		$parent.find("span").eq((page-1)).addClass("current").siblings().removeClass("current");
    });
});



























