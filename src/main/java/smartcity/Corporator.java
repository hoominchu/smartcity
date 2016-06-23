package smartcity;

import com.mongodb.BasicDBObject;
import com.mongodb.DBCursor;
import com.mongodb.DBObject;

/**
 * This class isn't being used right now. This has been created keeping in mind the scalability of the project.
 * Created by minchu on 21/04/16.
 */
public class Corporator {

    public int ID;
    public String name;
    public String sex;
    public String party;
    public String termsServed; 		//AND/OR some other historical fact about the corporator.
    public String linkToPersonalWebpage;	//Or myneta.gov profile.
    public String address;
    public String emailID;
    public String phoneNumber;

    public static String[] getCorporatorDetails (int wardNum) {
        String[] corporatorDetails = new String[6];

        DBCursor cursor = Database.corporators.find(new BasicDBObject("Ward_num",wardNum));

        while (cursor.hasNext()) {
            DBObject corporator = cursor.next();
            corporatorDetails[0] = corporator.get("Name").toString();
            corporatorDetails[1] = corporator.get("Name kannada").toString();
            corporatorDetails[2] = corporator.get("Contact number").toString();
            corporatorDetails[3] = corporator.get("Party").toString();
            corporatorDetails[4] = corporator.get("Party Kannada").toString();
            corporatorDetails[5] = corporator.get("Image URL").toString();
            break;
        }

        return corporatorDetails;
    }

}