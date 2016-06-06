package smartcity;

import com.mongodb.BasicDBObject;
import com.mongodb.DBCursor;
import com.mongodb.DBObject;

import javax.xml.crypto.Data;
import java.util.ArrayList;

/**
 * Created by minchu on 02/06/16.
 */
public class Bill {
    public int recID;    //This is the same as work ID.
    public String mainCategory;
    public String passedCategory;
    public String contractor;
    public String descriptionEnglish;
    public String billPassDate;
    public String billPassAmount;
    public String paidDate;
    public String paidAmount;

    public Bill (DBObject billObject) {
        try {
            this.recID = (int) billObject.get("Recid");
            this.mainCategory = billObject.get("Main_Category").toString();
            this.passedCategory = billObject.get("Passed_Category").toString();
            this.contractor = billObject.get("Contractor_name").toString();
            this.descriptionEnglish = billObject.get("Description_Eng").toString();
            this.billPassDate = billObject.get("Bill Pass Date").toString();
            this.billPassAmount = billObject.get("Bill Pass Amt").toString();
            this.paidDate = billObject.get("Paid Date").toString();
            this.paidAmount = billObject.get("Paid Amt").toString();

        }

        catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static ArrayList<Bill> createBills (BasicDBObject query) {

        DBCursor cursor = Database.billspaid.find();

        if (query != null) {
            cursor = Database.billspaid.find(query);
        }

        ArrayList<Bill> bills = new ArrayList<>();

        while (cursor.hasNext()) {
            DBObject billDBObject = cursor.next();

            Bill newBill = new Bill(billDBObject);

            bills.add(newBill);

        }

        return bills;
    }

}
