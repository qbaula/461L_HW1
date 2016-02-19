package hmwkblog;

import java.io.IOException;
import java.util.logging.Logger;

import javax.servlet.http.*;

import static com.googlecode.objectify.ObjectifyService.ofy;
import com.googlecode.objectify.ObjectifyService;

import hmwkblog.BlogPost;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

@SuppressWarnings("serial")
public class hmwkblogServlet extends HttpServlet {
	static {
		ObjectifyService.register(BlogPost.class);
	}
	
	private static final Logger _logger = Logger.getLogger(hmwkblogServlet.class.getName());
	@Override
    public void doPost(HttpServletRequest req, HttpServletResponse resp)
    throws IOException {
        UserService userService = UserServiceFactory.getUserService();
        User user = userService.getCurrentUser();
        String title = req.getParameter("title");
        String content = req.getParameter("content");
        BlogPost post = new BlogPost(user, title, content);
        ofy().save().entity(post).now();
        
        _logger.info("Successfully added blog post");
        resp.sendRedirect("/hmwkblog.jsp");
    }
	
}
