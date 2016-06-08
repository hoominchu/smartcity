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
}
