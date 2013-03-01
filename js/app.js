function curry$(e,t){var n,r=function(i){return e.length>1?function(){var s=i?i.concat():[];return n=t?n||this:this,s.push.apply(s,arguments)<e.length&&arguments.length?r.call(n,s):e.apply(n,s)}:e};return r()}var angular_app;angular_app=angular.module("TimedPassword",[]),angular_app.run(["$rootScope",function(e){}]),angular_app.config(["$routeProvider",function(e){return e.when("/",{templateUrl:"/partials/main.html",controller:"MainController"}).otherwise({redirectTo:"/"})}]);var MainController;MainController=["$scope",function(e){return e.keydowns=[],e.keyups=[],e.times=[],e.pauses=[],e.timeData={},e.lastTimeData={},e.keyword="",e.history=[],e.calculateTimes=function(){var t,n,r,i,s,o,u;if(e.keydowns.length===e.keyups.length){for(t=i=0,o=e.keydowns.length-1;0<=o?i<=o:i>=o;t=0<=o?++i:--i)r=e.keyups[t]-e.keydowns[t],e.times[t]=r;if(e.keydowns.length>1)for(t=s=0,u=e.keydowns.length-2;0<=u?s<=u:s>=u;t=0<=u?++s:--s)n=e.keydowns[t+1]-e.keyups[t],e.pauses[t]=n;return e.$apply()}},e.formatTimes=function(e){var t;if(e.length>0)return function(){var n,r,s;s=[];for(n=0,r=e.length;n<r;n++)t=e[n],s.push(t+"ms");return s}().join(" ")},e.disableLogging=function(){var t;return t=!1,e.disableInput(),$("#main").unbind("keydown"),$("#main").unbind("keyup")},e.draw=function(){var t,n,r,i,s,o,u,a,f,l,c,h,p;if(!e.keyword)return;e.calculateTimes();if(e.previousKeyword===e.keyword){o=e.wordCount;if(o<10){e.wordCount+=1,e.history.push({times:e.times,pauses:e.pauses}),s=e.history.map(function(e,t){return e.times});for(n=u=0,c=s[0].length-1;0<=c?u<=c:u>=c;n=0<=c?++u:--u)i=function(){var e,r,i;i=[];for(e=0,r=s.length;e<r;e++)t=s[e],i.push(t[n]);return i}().reduce(function(e,t){return e+t}),e.timeData.times[n]=i/s.length;r=[],h=e.history;for(a=0,l=h.length;a<l;a++)n=h[a],n.pauses&&r.push(n.pauses);for(n=f=0,p=r[0].length-1;0<=p?f<=p:f>=p;n=0<=p?++f:--f)i=function(){var e,i,s;s=[];for(e=0,i=r.length;e<i;e++)t=r[e],s.push(t[n]);return s}().reduce(function(e,t){return e+t}),e.timeData.pauses[n]=i/r.length}else e.persisted=!0;e.wordCount>=10&&(e.persisted=!0),e.lastTimeData.times=e.times,e.lastTimeData.pauses=e.pauses,e.lastTimeData.keys=e.keyword.split("")}else e.wordCount=1,e.previousKeyword=e.keyword,e.lastTimeData.times=e.times,e.lastTimeData.pauses=e.pauses,e.lastTimeData.keys=e.keyword.split(""),e.timeData.times=e.times,e.timeData.pauses=e.pauses,e.timeData.keys=e.keyword.split(""),e.history=[{times:e.timeData.times,keys:e.timeData.pauses}];return e.$apply(),$("#main").attr("maxlength",0)},e.enableInput=function(){return $("#main").removeAttr("maxlength")},e.disableInput=function(){return $("#main").attr("maxlength",0)},e.enableLogging=function(){var t;return t=!0,$("#main").on("keydown",function(n){if(!t)return!1;if(n.keyCode===18)return;if(n.keyCode===13){e.draw(),e.disableLogging(),e.reset();return}if(n.keyCode===8){e.disableLogging(),e.resetInput();return}return e.keydowns.push((new Date).getTime()),e.$apply()}),$("#main").on("keyup",function(n){if(!t)return!1;if(n.keyCode===18)return;return e.keyups.push((new Date).getTime()),e.$apply()}),$("#main").removeAttr("maxlength")},e.resetInput=function(){return e.disableLogging(),e.keydowns=[],e.keyups=[],e.times=[],e.pauses=[],e.keyword="",e.$apply(),setTimeout(function(){return e.enableLogging()},500)},e.reset=function(){return $("#main").attr("maxlength",0),e.keydowns=[],e.keyups=[],e.times=[],e.pauses=[],e.keyword="",e.$apply(),setTimeout(function(){return e.enableLogging(),$("#main").removeAttr("maxlength")},1e3)},$(document).ready(function(){return e.enableLogging(),$("#main").focus()})}],angular_app.directive("pkVisualize",function(){return{restrict:"E",replace:!1,scope:{times:"=timeData",enableInput:"&inputToggle"},link:function(e,t,n,r){var i,s,o,u,a,f,l,c,h,p,d,v,m,g,y,b,w,E,S,x,T,N,C,k,L,A;return i=500,s=200,o=30,u={},a={},f={},l={},c=[],h=[],p=[],d={},v={},m=0,g=0,y=g/2,b=[],w=0,E={},S=1,x=function(t){return S===c.length?(e.enableInput(),S=1):S+=1},e.$watch("times",function(t,n){var r,u,a,f,l;if(t===n)return;h=[],p=[],c=e.times.keys,h=e.times.times,p=e.times.pauses;if(c.length===0||p.length===0)return;r=[];for(u=0,a=h.length;u<a;++u)f=u,l=h[u],f%2===0&&r.push({time:l,idx:f});d=r,r=[];for(u=0,a=h.length;u<a;++u)f=u,l=h[u],f%2!==0&&r.push({time:l,idx:f});return v=r,m=0,g=h.concat(p).reduce(curry$(function(e,t){return e+t})),y=g/2,b=d3.scale.linear().range([0,i-2*o]).domain([m,g]),w=Math.ceil(Math.max.apply(Math,h)/10)*10,E=d3.scale.linear().range([s-2*o,0]).domain([2*w,0]),S=1,C()},!0),T=function(e){var t,n;return e===0?0:(t=h.slice(0,e),n=p.slice(0,e),t.concat(n).reduce(curry$(function(e,t){return e+t})))},N=function(){u=d3.select(t[0]).append("svg").attr("width",i).attr("height",s),f=u.append("g").attr("class","elements_bottom"),l=u.append("g").attr("class","axis"),a=u.append("g").attr("class","elements_up"),u.append("defs").append("marker").attr("id","BlockArrow").attr("refX",1).attr("refY",15).attr("viewBox","0 0 30 30").attr("orient","auto").attr("markerWidth",3).attr("markerHeight",3).attr("markerUnits","strokeWidth").append("path").attr("d","M 0 20 L 10 20 L 10 30 L 30 15 L 10 0 L 10 10 L 0 10 z")},C=function(){k(),L(),A()},k=function(){return l.selectAll("line").data([g]).enter().append("line").attr("class","arrow").attr("x1",o-20).attr("x2",o-20).attr("y1",E(w)+o).attr("y2",E(w)+o).attr("transform","skewX(30), translate(-50,0)").transition().duration(y*.8).attr("x2",i-o+10),l.selectAll("text").data([g]).transition().duration(1500).tween("text",function(){var e;return e=d3.interpolate(this.textContent,g+" ms"),function(t){return this.textContent=Math.round(parseInt(e(t)))+" ms"}}).attr("y",function(){return c.length%2?E(w)+o+20:E(w)-o+50}),l.selectAll("text").data([g]).enter().append("text").text(function(){return"0 ms"}).attr("class","arrow").attr("x",o).attr("y",function(){return c.length%2?E(w)+o+20:E(w)-o+50}).transition().duration(y*.8).attr("x",i-o+20).tween("text",function(){var e;return e=d3.interpolate(this.textContent,g+" ms"),function(t){return this.textContent=Math.round(parseInt(e(t)))+" ms"}})},L=function(){return a.selectAll("rect").data(d).transition().duration(1500).attr("x",function(e){return o+b(T(e.idx))}).attr("width",function(e){return b(h[e.idx])}).attr("y",function(e){return o+E(w)-E(h[e.idx])}).attr("height",function(e){return E(h[e.idx])}).each("end",x),a.selectAll("rect").data(d).enter().append("rect").attr("rx",2).attr("ry",2).attr("x",function(e){return o+b(T(e.idx))}).attr("width",function(e){return b(h[e.idx])}).attr("y",o+E(w)).attr("height",0).transition().duration(function(e){return 2*h[e.idx]}).delay(function(e){return y+2*T(e.idx)}).attr("y",function(e){return o+E(w)-E(h[e.idx])}).attr("height",function(e){return E(h[e.idx])}).each("end",x),a.selectAll("rect").data(d).exit().attr("opacity",1).transition().attr("opacity",0).remove(),f.selectAll("rect").data(v).transition().duration(1500).attr("x",function(e){return o+b(T(e.idx))}).attr("width",function(e){return b(h[e.idx])}).attr("y",function(e){return o+E(w)}).attr("height",function(e){return E(h[e.idx])}).each("end",x),f.selectAll("rect").data(v).enter().append("rect").attr("rx",2).attr("ry",2).attr("x",function(e){return o+b(T(e.idx))}).attr("width",function(e){return b(h[e.idx])}).attr("y",o+E(w)).attr("height",0).transition().duration(function(e){return 2*h[e.idx]}).delay(function(e){return y+2*T(e.idx)}).attr("y",function(e){return o+E(w)}).attr("height",function(e){return E(h[e.idx])}).each("end",x),f.selectAll("rect").data(v).exit().attr("opacity",1).transition().attr("opacity",0).remove()},A=function(){a.selectAll("text").data(h).transition().duration(1500).text(function(e,t){return c[t].toUpperCase()+":"+e+" ms"}).attr("x",function(e,t){return o+b(T(t))+.5*b(h[t])}).attr("y",function(e,t){return t%2!==0?o+E(w)+E(h[t]+20):o+E(w)-E(h[t]+20)}).tween("text",function(e,t,n){var r,i,s,o;return r=c[t].toUpperCase(),i=parseInt(this.textContent.split(":")[1]),s=h[t],o=d3.interpolateRound(i,s),function(e){return this.textContent=r+":"+o(e)+" ms"}}),a.selectAll("text").data(h).enter().append("text").text(function(e,t){return c[t].toUpperCase()+":"+e+" ms"}).attr("opacity",0).attr("class",function(e,t){return t%2!==0?"text_bar_even text_bar":"text_bar_odd text_bar"}).attr("x",function(e,t){return o+b(T(t))+.5*b(h[t])}).attr("y",function(e,t){return t%2!==0?o+E(w)+E(h[t]+20):o+E(w)-E(h[t]+20)}).transition().duration(800).delay(function(e,t){return[y,2*T(t,2*h[t])].reduce(curry$(function(e,t){return e+t}))}).attr("opacity",1),a.selectAll("text").data(h).exit().attr("opacity",1).transition().attr("opacity",0).remove()},N()}}})