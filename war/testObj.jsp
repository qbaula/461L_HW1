
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Collections" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="com.googlecode.objectify.*" %>
<%@ page import="hmwkblog.BlogPost" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
  <head>
  <!--  <link type="text/css" rel="stylesheet" href="/stylesheets/main.css"/>  -->
  </head>
  
  <body>
<%
    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
    if (user != null) {
      pageContext.setAttribute("user", user);
%>
	<p>Hello, ${fn:escapeXml(user.nickname)}! (You can
	<a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sign out</a>.)</p>
	<form action="/hmwkblog" method="post">
      <div><textarea name="title" rows="1" cols="60"></textarea></div>
      <div><textarea name="content" rows="3" cols="60"></textarea></div>
      <div><input type="submit" value="Submit" /></div>
    </form>
<%
    } else {
%>
	<p>Hello!
	<a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a>
	to submit your own posts.</p>
<%
    }
%>

<%
	ObjectifyService.register(BlogPost.class);
	List<BlogPost> posts = ObjectifyService.ofy().load().type(BlogPost.class).list();   
	Collections.sort(posts); 
	
	if (posts.isEmpty()) {
%>
   		<p>No blog posts.</p>
<%
    } else {
        for (BlogPost post: posts) {
           pageContext.setAttribute("post_user", post.getUser());
           pageContext.setAttribute("post_title", post.getTitle());
           pageContext.setAttribute("post_content", post.getContent());
%>
           <p><b>${fn:escapeXml(post_user.nickname)}</b> wrote:</p>
           <p>Title:${fn:escapeXml(post_title)}</p>
           <blockquote>${fn:escapeXml(post_content)}</blockquote>
<%
        }
    }
%>
	
  </body>
</html>