package hmwkblog;
import java.util.Date;

import com.google.appengine.api.users.User;
import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;
import com.googlecode.objectify.annotation.Index;


@Entity
class EntityDate {
    public EntityDate() {
        // Objectify needed
    }

    @Id
    private Long id;

    @Index
    public Date date;
}

@Entity
public class Email{
	private @Id Long id;
	private @Index String email;
	
	public Email(User user){
		email = user.getEmail();
	}

	private Email(){}
		
	public String getEmail() {
		return email;
	}
	
	public boolean equals(Object other) {
		Email o = (Email)(other);
		return this.email.equals(o.getEmail());
	}
}
