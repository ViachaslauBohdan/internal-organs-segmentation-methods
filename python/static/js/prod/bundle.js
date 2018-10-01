!function(e){var t={};function n(i){if(t[i])return t[i].exports;var o=t[i]={i:i,l:!1,exports:{}};return e[i].call(o.exports,o,o.exports,n),o.l=!0,o.exports}n.m=e,n.c=t,n.d=function(e,t,i){n.o(e,t)||Object.defineProperty(e,t,{enumerable:!0,get:i})},n.r=function(e){"undefined"!=typeof Symbol&&Symbol.toStringTag&&Object.defineProperty(e,Symbol.toStringTag,{value:"Module"}),Object.defineProperty(e,"__esModule",{value:!0})},n.t=function(e,t){if(1&t&&(e=n(e)),8&t)return e;if(4&t&&"object"==typeof e&&e&&e.__esModule)return e;var i=Object.create(null);if(n.r(i),Object.defineProperty(i,"default",{enumerable:!0,value:e}),2&t&&"string"!=typeof e)for(var o in e)n.d(i,o,function(t){return e[t]}.bind(null,o));return i},n.n=function(e){var t=e&&e.__esModule?function(){return e.default}:function(){return e};return n.d(t,"a",t),t},n.o=function(e,t){return Object.prototype.hasOwnProperty.call(e,t)},n.p="",n(n.s=0)}([function(e,t,n){"use strict";n.r(t);var i,o={sendGetRequest:function(e,t){console.log("send get request");const n=this.generateURL(e);return $.ajax({url:n,type:"GET",data:t,contentType:"application/json; charset=utf-8",dataType:"json"})},sendPostRequest:function(e,t){console.log("send post   request");const n=this.generateURL(e);return $.ajax({url:n,type:"POST",data:JSON.stringify({payload:t}),contentType:"application/json; charset=utf-8",dataType:"json"})},generateURL:function(e){return location.protocol+"//"+location.host+e}},s=({init:function(){this.buttons.forEach(e=>{const t=this;$(e.id).click(function(){if(e.cliked)t.deactivateRest(e.id,e.container);else{t.activateButton(e.id,e.container);const n=t.buttons.find(t=>1==t.cliked&&t.id!=e.id);n&&t.deactivateRest(n.id,n.container)}})})},buttons:[{id:"#seed-button",container:"#seed-inputs-wrapper",cliked:!1},{id:"#kmeans-button",container:"#kmeans-inputs-wrapper",cliked:!1},{id:"#fuzzy-button",container:"#fuzzy-inputs-wrapper",cliked:!1}],activateButton:function(e,t){$(e).css({"background-color":"#21a522"}),$(t).css({display:"inherit"}),this.buttons.forEach(t=>{t.id==e&&(t.cliked=!0)})},deactivateRest:function(e,t){$(e).css({"background-color":"#20a5d6"}),$(t).css({display:"none"}),this.buttons.forEach(t=>{t.id==e&&(t.cliked=!1)})}}.init(),{activateClickEventListener:function(){var e=this;$(document).ready(function(){$('input[type="file"]').change(function(t){e.fileName=t.target.files[0].name,$('input[type="file"]')&&$("#buttons-wrapper").css("visibility","visible")})})},fileName:"",getLoadedFileName:function(){return this.fileName}}),c={activateClickEventListeners:function(){var e=this;$(document).ready(function(){$(".carousel-submit-button").click(()=>{e.carouselSubmit()}),$(".carousel-inner").delegate("#canvas1","click",function(t){$(".reconstruction-no-points").remove(),e.reconstructionCoords.push({x:t.offsetX,y:t.offsetY}),$("#reconstruction-points-container").append(`<li>x: ${t.offsetX} y: ${t.offsetY}</li>`)}),$("#processing-button").click(()=>{if("rgb(33, 165, 34)"==$("#kmeans-button").css("background-color")){const e=$("input[type=number][name='kmeans']").val();const t={fileName:s.getLoadedFileName(),clustersNumber:e};c.generateEmptyCarousel(t,e)}}),$(".filters-list li").click(function(){$(this).css({"background-color":"#d09c00"});for(let e=0;e<5;e++)$(this).index()!==e&&"rgb(68, 66, 66)"!==$(`.filters-list li:nth-child(${e+1})`).css("background-color")&&$(`.filters-list li:nth-child(${e+1})`).css({"background-color":"rgb(68, 66, 66)"});switch(e.clickedFilterIndex=$(this).index(),$(this).index()){case 0:e.modifyInput("make hidden"),$(".reconstruction-pts").removeClass("d-none"),$(".reconstruction-pts").addClass("d-flex"),$("#canvas1").css({cursor:"crosshair"});break;case 2:$(".carousel-input").val(null),e.modifyInput("reset",null).modifyInput("make visible").modifyInput("set placeholder","Choose structural element size in px");break;case 3:e.modifyInput("reset",null).modifyInput("make visible").modifyInput("set placeholder","Choose structural element size in px");break;default:e.modifyInput("make hidden")}})})},clickedFilterIndex:null,generateEmptyCarousel:function(e,t){var n=this;o.sendGetRequest("/kmeans/step1",e).done(function(e){n.kmeansClusteredImages=e.arrayOfImgs,e.arrayOfImgs.forEach((e,t)=>{const i=cv.matFromArray(512,512,cv.CV_8U,[].concat.apply([],e));let o,s;0===t?(o=n.activeSlideDOM.replace("#INDEX#",t).replace("#INDEX+1#",t+1),s=n.activeItemIndicator.replace("#INDEX+1#",t+1)):(o=n.notActiveSlideDOM.replace("#INDEX#",t).replace("#INDEX+1#",t+1),s=n.notActiveItemIndicator.replace("#INDEX+1#",t+1)),$(".carousel-inner").append(o),$(".carousel-indicators").append(s),$(".carousel-item").css({width:"100%",height:"600px"}),cv.imshow(`canvas${t}`,i)}),n.activateCarousel(t),$("#dicomImgModal").modal()}).fail(function(e){console.log(e)})},carouselSubmit:function(){var e=this;if("step2"===$(".carousel-input").attr("name")){console.log("KMEANS STEP3"),this.appendColours();let t=e.clickedFilterIndex;o.sendPostRequest("/kmeans/step2",{filterNumber:t+1,imgNumber:e.choosenImageNumber-1,reconstructionCoords:e.reconstructionCoords}).done(function(e){console.log(e)}).fail(function(e){console.log(e)})}else if("step1"===$(".carousel-input").attr("name")){console.log("KMEANS STEP2"),e.modifyInput("make hidden",null),e.choosenImageNumber=$(".carousel-input").val();const t=cv.matFromArray(512,512,cv.CV_8U,[].concat.apply([],e.kmeansClusteredImages[e.choosenImageNumber-1]));let n,i;$(".modal-title").text("Step 2: select further processing filter number"),$(".processing-filters").css({display:"inherit",color:"white"}),$(".carousel-input").attr("name","step2");e=this;n=this.activeSlideDOM.replace("#INDEX#",1).replace("#INDEX+1#",1),i=this.activeItemIndicator.replace("#INDEX+1#",1),console.log(n),$(".carousel-inner").html(n),$(".carousel-indicators").html(i),$(".carousel-item").css({width:"100%",height:"600px"}),cv.imshow("canvas1",t),this.activateCarousel(1),$("#dicomImgModal").modal()}},activateCarousel:function(e){$("#dicom-images-carousel").carousel();for(let t=1;t<=e;t++)$(`.item${t}`).click(function(){$("#dicom-images-carousel").carousel(t-1)});$(".carousel-control-prev").click(function(){$("#dicom-images-carousel").carousel("prev")}),$(".carousel-control-next").click(function(){$("#dicom-images-carousel").carousel("next")})},appendColours:function(){return $(".filters-list").find("li").filter(function(){return"rgb(208, 156, 0)"===$(this).css("background-color")})},modifyInput:function(e,t){switch(e){case"make visible":return $(".carousel-input").css({visibility:"visible"}),this;case"make hidden":return $(".carousel-input").css({visibility:"hidden"}),this;case"set placeholder":return $(".carousel-input").attr("placeholder",t),this;case"reset":return $(".carousel-input").val(null),this}},kmeansClusteredImages:null,reconstructionCoords:[],choosenImageNumber:null,activeSlideDOM:"\n    <div class='carousel-item active'\" + \">\n    <div class=\"slide-name\" style='color:white;font-size:20px'>Cluster number: #INDEX+1#</div> \n    <canvas id='canvas#INDEX#'></canvas>\n    </div>",notActiveSlideDOM:"\n    <div class='carousel-item'\" + \">\n            <div class=\"slide-name\" style='color:white;font-size:20px'>Cluster number: #INDEX+1#</div>\n            <canvas id='canvas#INDEX#'></canvas>\n    </div>",activeItemIndicator:"<li class='item#INDEX+1# active'\" + \"></li>",notActiveItemIndicator:"<li class='item#INDEX+1#'\" + \"></li>"},a=(c.activateClickEventListeners(),[]);$(document).ready(function(){s.activateClickEventListener(),$("#processing-button").click(()=>{if("rgb(33, 165, 34)"==$("#seed-button").css("background-color")){console.log("START SEED PROCESSING");const e=$("input[type=radio][name=seed]:checked").val(),t=s.getLoadedFileName(),n=$("input[type=radio][name='neighbours']:checked").val(),i="/seed"+`?fileName=${t}&ratio=${$("input[type=number][name='seed']").val()}&neighboursNumber=${n}&distance=${e}`;o.sendPostRequest(i,a).done(function(e){$("#spinner").html("<p>processing finished</p>");const t=cv.matFromArray(512,512,cv.CV_8U,[].concat.apply([],e.result));cv.imshow("canvasOutput",t)}).fail(function(e){console.log(e)})}}),$("#processing-button").click(()=>{if("rgb(33, 165, 34)"==$("#fuzzy-button").css("background-color")){const e={fileName:void 0,clustersNumber:$("input[type=number][name='fuzzy']").val()};o.sendGetRequest("/fuzzy",e).done(function(e){$("#spinner").html("<p>processing finished</p>"),console.log(e.result);let t=cv.matFromArray(1,8,cv.CV_8UC1,e.result);console.log(t.data),cv.imshow("canvasOutput",t)}).fail(function(e){console.log(e)})}}),$(".cornerstone-canvas").click(function(e){$("#seed-list-item").length||$("#no-seeds").remove(),a.push({x:e.offsetX,y:e.offsetY}),i=$(`<li id="seed-list-item">X: ${e.offsetX} Y: ${e.offsetY}</li>`),$("#seed-list").append(i)})})}]);