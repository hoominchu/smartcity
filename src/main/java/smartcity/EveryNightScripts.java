package smartcity;

import com.mongodb.BasicDBObject;
import com.mongodb.DBCursor;
import com.mongodb.DBObject;

/**
 * Created by minchu on 07/06/16.
 */
public class EveryNightScripts {

    public static void updateBillsPaidInDB() {
        DBCursor allWorks = Database.allworks.find();

        while (allWorks.hasNext()) {
            DBObject work = allWorks.next();
            int workID = (int) work.get("Work ID");
            BasicDBObject billQuery = new BasicDBObject("Recid",workID);
            BasicDBObject workQuery = new BasicDBObject("Work ID",workID);

            DBCursor billsPaid = Database.billspaid.find(billQuery);
            int billTotal = 0;

            while (billsPaid.hasNext()) {
                DBObject bill = billsPaid.next();
                int billAmount = (int) bill.get("Paid Amt");
                billTotal = billTotal + billAmount;
            }

            BasicDBObject newDocument = new BasicDBObject();
            newDocument.append("$set", new BasicDBObject().append("Total bill amount paid",billTotal));

            Database.allworks.update(workQuery,newDocument);
        }
    }

    public static void updateDoWorkDetailsExist() {
        DBCursor allWorks = Database.allworks.find();

        while (allWorks.hasNext()) {
            DBObject work = allWorks.next();
            int workID = (int) work.get("Work ID");

            BasicDBObject query = new BasicDBObject("Work ID", workID);

            DBCursor workdetails = Database.workDetails.find(query);

            BasicDBObject newDoc = new BasicDBObject();

            if (workdetails.size() > 0) {
                newDoc.append("$set", new BasicDBObject().append("Do work details exist","TRUE"));
            }
            else {
                newDoc.append("$set", new BasicDBObject().append("Do work details exist","FALSE"));
            }

            Database.allworks.update(query,newDoc);
        }
    }

    public static void writeMinorWorkTypeInDB () {
        DBCursor works = Database.allworks.find();
        while (works.hasNext()) {
            DBObject work = works.next();

            String minorWorkTypeID = work.get("Minor ID").toString();
            int workID = (int) work.get("Work ID");

            BasicDBObject query = new BasicDBObject("Code",Integer.parseInt(minorWorkTypeID));

            DBCursor minorIDs = Database.minorWorkTypes.find(query);
            DBObject minorID = minorIDs.next();
            String minorIDMeaning = minorID.get("Meaning").toString();

            BasicDBObject IDMeaning = new BasicDBObject();
            IDMeaning.append("$set", new BasicDBObject().append("Minor ID Meaning",minorIDMeaning));

            Database.allworks.update(new BasicDBObject("Work ID", workID),IDMeaning);
        }
    }
}
