package hmwkblog;

import static com.googlecode.objectify.ObjectifyService.ofy;

import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.http.*;

import java.util.Date;
import java.util.List;

import static com.googlecode.objectify.ObjectifyService.ofy;

import com.googlecode.objectify.Objectify;
import com.googlecode.objectify.ObjectifyService;
import com.googlecode.objectify.Ref;
import com.googlecode.objectify.cmd.Query;

import hmwkblog.Email;
import java.util.Properties;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

@SuppressWarnings("serial")
public class SubscribeCronServlet extends HttpServlet {
	static {
		ObjectifyService.register(Email.class);
	}
	static {
		ObjectifyService.register(BlogPost.class);
	}
	static {
		ObjectifyService.register(EntityDate.class);
	}
	
	private static final Logger _logger = Logger.getLogger(SubscribeCronServlet.class.getName());

	public List<BlogPost> getPosts() {
		DateFormat dateFormat = new SimpleDateFormat("E M d HH:mm:ss z y");
		Date yesterdayDate = new Date(System.currentTimeMillis() - 3600 * 1000 * 24);
		List<BlogPost> posts = ObjectifyService.ofy().load().type(BlogPost.class).filter("date >", yesterdayDate).list();
		
		return posts;
	}

	public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {

		try {
			_logger.info("Cron Job has been executed");

			Properties props = new Properties();
			Session session = Session.getDefaultInstance(props, null);
			List<BlogPost> posts = getPosts();
			
			if (!posts.isEmpty()) {
				StringBuilder msgBody = new StringBuilder();
				for (BlogPost post : posts) {
					msgBody.append("Title: " + post.getTitle() + "\n");
					msgBody.append("User: " + post.getUser() + "\n");
					msgBody.append("Date: " + post.getDate() + "\n");
					msgBody.append("Post: " + post.getContent() + "\n");
					msgBody.append("----------------------------------------------------------------\n");

				}
				List<Email> emails = ofy().load().type(Email.class).list();
				for (Email email : emails) {

					try {
						Message msg = new MimeMessage(session);
						msg.setFrom(new InternetAddress("info@hmwk1blog.com", "Blog Subscription Bot"));
						msg.addRecipient(Message.RecipientType.TO,
								new InternetAddress(email.getEmail(), email.getEmail()));
						msg.setSubject("Here is your daily subscription to Homework 1 Blog");
						msg.setText(msgBody.toString());
						Transport.send(msg);

					} catch (AddressException e) {
						_logger.info(e.toString());
					} catch (MessagingException e) {
						_logger.info(e.toString());
					}
				} 
			}else{
				_logger.info("No messages were sent");
			}
		} catch (Exception ex) {
			_logger.info(ex.toString());
			// Log any exceptions in your Cron Job
		}
	}

	@Override
	public void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		doGet(req, resp);
	}
}