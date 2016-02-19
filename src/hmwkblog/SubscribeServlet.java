package hmwkblog;

import java.io.IOException;
import java.util.List;

import javax.servlet.http.*;

import static com.googlecode.objectify.ObjectifyService.ofy;
import com.googlecode.objectify.ObjectifyService;
import com.googlecode.objectify.Ref;
import com.googlecode.objectify.cmd.Query;

import hmwkblog.Email;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

public class SubscribeServlet extends HttpServlet {
	static {
		ObjectifyService.register(Email.class);
	}
	
	@Override
    public void doGet(HttpServletRequest req, HttpServletResponse resp)
    throws IOException {
		String toSub = req.getParameter("subscribe");
		
		if(toSub.equals("true")){
		    UserService userService = UserServiceFactory.getUserService();
	        User user = userService.getCurrentUser();
	        Email email = new Email(user);
	        ofy().save().entity(email).now();
		}
		else if(toSub.equals("false")){
			 UserService userService = UserServiceFactory.getUserService();
		     User user = userService.getCurrentUser();
		     //Ref<Email> email = ofy().load().type(Email.class).filter("email", user.getEmail()).first();
		     Email email = ofy().load().type(Email.class).filter("email", user.getEmail()).first().get();
		     ofy().delete().entity(email).now();
		}
        resp.sendRedirect("/hmwkblog.jsp");
    }
	
	public static boolean isSubscribed(){
	     UserService userService = UserServiceFactory.getUserService();
	     User user = userService.getCurrentUser();
	     Email email = new Email(user);
	     List<Email> emails = ObjectifyService.ofy().load().type(Email.class).list();   
	 	 
		 return !emails.contains(email);
	}
}
