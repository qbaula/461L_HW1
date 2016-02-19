
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Collections" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="com.googlecode.objectify.*" %>
<%@ page import="hmwkblog.BlogPost" %>
<%@ page import="hmwkblog.SubscribeServlet" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
  <head>
  		<title>Homework 1 Blog</title>
        <!--[if IE]><meta http-equiv='X-UA-Compatible' content='IE=edge,chrome=1'><![endif]-->
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0" />
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css"/>
        <link href="//maxcdn.bootstrapcdn.com/font-awesome/4.2.0/css/font-awesome.min.css" rel="stylesheet"/>
        <link href='http://fonts.googleapis.com/css?family=Open+Sans:300italic,400italic,600italic,700italic,400,700,600,300' rel='stylesheet' type='text/css'/>
	    <link href='http://fonts.googleapis.com/css?family=Raleway:400,100,200,300,500,600,800,700,900' rel='stylesheet' type='text/css'/>
        <link href='http://fonts.googleapis.com/css?family=Tangerine:400,700' rel='stylesheet' type='text/css'>
        
        <link href="stylesheets/style.css" rel="stylesheet" type="text/css" />
  </head>
  
  <body>
<% 
	UserService userService = UserServiceFactory.getUserService();
	User user = userService.getCurrentUser();
	if (user != null) {
	      pageContext.setAttribute("user", user);
	}
%>
  <div id="top" class="container">
        <div class="row" style="margin-top:15px">
            <div class="col-md-10 pull-right" style="text-align:right">
       		<% if(user == null){ %>
                <a class="signin-link" href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign In</a>
            <% } else { %>
            	<span class="signin-link">
            		Welcome, ${fn:escapeXml(user.nickname)}. 
            		<a class="signin-link" href="<%= userService.createLogoutURL(request.getRequestURI()) %>">Sign Out</a>&nbsp;&nbsp;
            		<% if(SubscribeServlet.isSubscribed()){ %><a class="" href="/subscribe?subscribe=true">Subscribe</a><% }else{ %>
            		<a class="" href="/subscribe?subscribe=false">Unsubscribe</a><% } %>
            	</span>
            <% } %>
            </div>
        </div>
          <div class="row">
            <div class="col-md-12 logo">
                <div class="content-logo"><img src="images/ut.png" alt="" /></div>
            </div>
            <div class="col-md-12">
               <div><h1 style="text-align:center">Most Amazing Blog</h1></div>
            </div>
           
                      
<%
   
    if (user != null) {
%>
<%-- 	<p>Hello, ${fn:escapeXml(user.nickname)}! (You can --%>
<%-- 	<a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sign out</a>.)</p> --%>
	 	<div class="col-md-10 col-md-offset-1">
        	<div class="box-startup" style="height:300px">
            	<h2>Submit a New Post</h2>
                 <form action="/hmwkblog" method="post">
	                 <div class="row">
	                   <div class="col-md-12">
							<input name="title" placeholder="Post Title:" style="width:100%;margin:10px 0" required>
					        <textarea name="content" style="height:100px;width:100%;border-color:#d0d0d0" required></textarea>
	                   </div>
	                 </div>
	                 <div class="row" style="margin-top:10px">
	                     <div class="col-md-2 pull-right">
	                         <input type="submit" value="Submit" class="btn btn-primary pull-right">
	                     </div>
	                 </div>
                 </form>
             </div>
         </div>
<%
    } 
%>

          </div>
    </div>
	    <section id="section3" class="cd-section">
        <div class="container" style="width:80%">
            <div class="row">
                <div class="col-md-12">
                    <div class="box-content">
                        <h1 style="margin-bottom:25px">Recent Posts</h1>
                        <div style="text-align:center;font-size:16px">
                        	Show: 
                        	<form name="show-input" action="hmwkblog.jsp" method="get">
                        	<%
                        	String res;
                       		res = request.getParameter("showcount");
                       		String recentChecked = "";
                       		String allChecked = "";
                       		if (res == null || res.equals("recent")) {
                       			recentChecked = "checked";
                       		}else{ 
                       			allChecked = "checked";
                       		}
                        	%>
                        		<input type="radio" name="showcount" value="recent" <%= recentChecked %>> Recents
								<input type="radio" name="showcount" value="all"  <%= allChecked %>> All 
								<input type="submit" value="Apply" class="btn btn-primary btn-xs">
							</form>
                        </div>

<%
	ObjectifyService.register(BlogPost.class);
	List<BlogPost> posts = ObjectifyService.ofy().load().type(BlogPost.class).list();   
	Collections.sort(posts); 
	
	if (posts.isEmpty()) {
%>
   		<p style="">No blog posts.</p>
<%
    } else {
    	/* String res;
   		res = request.getParameter("showcount"); */
   		if (res == null) {
   			res = "recent";
   		}
    	int size = res.equals("all") ? posts.size() : 3;
    	for(int ind = 0; ind < size && ind < posts.size(); ind ++){
    	   BlogPost post = posts.get(ind);	
    	
       		
           pageContext.setAttribute("post_user", post.getUser());
           pageContext.setAttribute("post_title", post.getTitle());
           pageContext.setAttribute("post_content", post.getContent());
           pageContext.setAttribute("post_date", post.getDate());
%>
			           <div class="col-md-12">
			               <div class="box-startup" >
			                   <h2> ${fn:escapeXml(post_title)} - ${fn:escapeXml(post_user.nickname)}<span class="pull-right"><i style="color:#666">${fn:escapeXml(post_date)}</i></span></h2>
			                     <div class="col-md-12">
			                       <p>
			                       ${fn:escapeXml(post_content)}
			                       </p>
			                     </div>
			                </div>
			           </div>
			           
		
<%
        }
    }
%>
					</div>
	               </div>
                </div>
            </div>
    </section>
  </body>
</html>