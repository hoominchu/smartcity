package smartcity;

import com.mongodb.BasicDBObject;
import com.mongodb.DBCursor;
import com.mongodb.DBObject;

import java.text.DecimalFormat;

/**
 * Created by minchu on 16/04/16.
 */
public class Work {

    public String workObjectID;
    public int wardNumber;
    public String workDescriptionEnglish;
    public String workDescriptionKannada;
    public String workDescriptionFinal;
    public String workOrderDate;
    public String workCompletionDate;
    public String workType;
    public String contractor;
    public String amountSanctionedString;
    public int amountSanctioned;
    public String statusFirstLetterSmall;
    public String statusfirstLetterCapital;
    public String workID;
    public String workTypeID;
    public String contractorID;
    public String sourceOfIncomeID;
    public String sourceOfIncome;
    public String statusColor;
    public boolean doWorkDetailsExist;

    public static Work[] allWorks = createWorkObjects(new BasicDBObject());

    //Constructor method for class work
    public Work(DBObject workObject) {

        try {
        DecimalFormat IndianCurrencyFormat = new DecimalFormat("##,##,##,###.0");

        this.workObjectID = workObject.get("_id").toString();

        this.wardNumber = (int) workObject.get("Ward Number");
        this.workDescriptionEnglish = workObject.get("Work Description English").toString();
        this.workDescriptionKannada = workObject.get("Work Description Kannada").toString();

        this.workDescriptionFinal = null;

        this.workOrderDate = workObject.get("Work Order Date").toString();
        this.workCompletionDate = workObject.get("Work Completion Date").toString();
        this.workType = workObject.get("Work Type").toString();
        this.sourceOfIncome = workObject.get("Source of Income").toString();
        this.contractor = workObject.get("Contractor").toString();
        this.amountSanctionedString = workObject.get("Amount Sanctioned").toString();
        //Converting string to integer with commas
            Double temp = Double.parseDouble(amountSanctionedString);
            this.amountSanctioned = temp.intValue();
            // IndianCurrencyFormat.format(Double.parseDouble(amountSanctionedString));

        this.statusFirstLetterSmall = workObject.get("Status").toString();
        this.statusfirstLetterCapital = General.capitalizeFirstLetter(this.statusFirstLetterSmall);

        //Values for backend
        this.workID = workObject.get("Work ID").toString();
        this.workTypeID = workObject.get("Work Type ID").toString();
        this.contractorID = workObject.get("Contractor ID").toString();
        this.sourceOfIncomeID = workObject.get("Source of Income ID").toString();

        if (this.statusfirstLetterCapital.equals("Completed")) {
            this.statusColor = "43ac6a";
        } else if (this.statusfirstLetterCapital.equals("Inprogress")) {
            this.statusColor = "f04124";
        }

            if (this.workType.equals("Capital") || this.workType.equals("Maintenance") || this.workType.equals("Under 22.75%")){
                this.doWorkDetailsExist = true;
            }
            else {
                this.doWorkDetailsExist = false;
            }
        }
     catch (Exception e) {
         e.printStackTrace();
        System.err.println(e.getClass().getName() + " : " + e.getMessage());
         System.err.println("here");
    }
    }

    public static Work[] createWorkObjects(BasicDBObject query) {

        DBCursor cursor = Database.allworks.find();

        if (query != null) {
            cursor = Database.allworks.find(query);
        }
        int numberOfWorks = cursor.count();

        Work[] works = new Work[numberOfWorks];
        int i = 0;

        while (cursor.hasNext()) {
            DBObject workDBObject = cursor.next();

            works[i] = new Work(workDBObject);
            i++;

        }

        return works;
    }
}
