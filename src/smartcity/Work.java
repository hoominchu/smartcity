package smartcity;

import com.mongodb.DBCursor;
import com.mongodb.DBObject;

import java.text.DecimalFormat;

/**
 * Created by minchu on 16/04/16.
 */
public class Work {

    String workObjectID;
    int wardNumber;
    String workDescriptionEnglish;
    String workDescriptionKannada;
    String workDescriptionFinal;
    String workOrderDate;
    String workCompletionDate;
    String workType;
    String contractor;
    String amountSanctionedString;
    String amountSanctioned;
    String statusFirstLetterSmall;
    String statusfirstLetterCapital;
    String workID;
    String workTypeID;
    String contractorID;
    String sourceOfIncomeID;
    String sourceOfIncome;
    String statusColor;

    //Constructor method for class work
    public Work(DBObject workObject) {

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
        this.amountSanctioned = IndianCurrencyFormat.format(Double.parseDouble(amountSanctionedString));

        this.statusFirstLetterSmall = workObject.get("Status").toString();
        this.statusfirstLetterCapital = functionsGeneral.capitalizeFirstLetter(this.statusFirstLetterSmall);

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
    }

    public static void createAllWorkObjects() {

        DBCursor cursor = Database.allworks.find();

        while (cursor.hasNext()) {
            DBObject workObject = cursor.next();
        }
    }
}
