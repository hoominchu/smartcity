package smartcity;

import com.mongodb.BasicDBObject;
import com.mongodb.DBCursor;
import com.mongodb.DBObject;

import java.text.DecimalFormat;
import java.util.*;

/**
 * Created by minchu on 16/04/16.
 */
public class Work implements Comparable<Work> {

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
    public String year;
    public boolean doWorkDetailsExist;
    public boolean doBillDetailsExist;

    public static ArrayList<Work> allWorks = createWorkObjects(new BasicDBObject());

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

            this.year = workObject.get("Year").toString();

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

            if (this.workType.equals("Capital") || this.workType.equals("Maintenance") || this.workType.equals("Under 22.75%")) {
                this.doWorkDetailsExist = true;
            } else {
                this.doWorkDetailsExist = false;
            }

        } catch (Exception e) {
            e.printStackTrace();
            System.err.println(e.getClass().getName() + " : " + e.getMessage());
            System.err.println("here");
        }
    }

    @Override
    public boolean equals(Object obj) {

        if (obj == null) {
            return false;
        }

        Work w = (Work) obj;

        return (w.workID.equals(this.workID));
    }

    @Override
    public int hashCode() {
        return this.workID.hashCode();
    }


    /**
     * Creates all the work objects based on the database query given as argument. Returns an arraylist of Works
     *
     * @param query
     * @return
     */
    public static ArrayList<Work> createWorkObjects(BasicDBObject query) {

        DBCursor cursor = Database.allworks.find();

        if (query != null) {
            cursor = Database.allworks.find(query);
        }

        ArrayList<Work> works = new ArrayList<>();
        //int i = 0;

        while (cursor.hasNext()) {
            DBObject workDBObject = cursor.next();

            Work newWork = new Work(workDBObject);

            works.add(newWork);

            //works[i] = new Work(workDBObject);
            //i++;

        }

        try {
            //ArrayList<Work> worksList = new ArrayList<Work>(Arrays.asList(works));
            Collections.sort(works, compareWorks);
            //Arrays.sort(works, compareWorks);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return works;
    }

    public static Comparator<Work> compareWorks = new Comparator<Work>() {
        @Override
        public int compare(Work w1, Work w2) {

            float compareQuantity1 = w1.amountSanctioned / 1000;
            float compareQuantity2 = w2.amountSanctioned / 1000;

            if (w1.statusfirstLetterCapital.equals("Inprogress")) {
                compareQuantity1 = compareQuantity1 * 1000;
            }

            if (w2.statusfirstLetterCapital.equals("Inprogress")) {
                compareQuantity2 = compareQuantity2 * 1000;
            }

            int val = 0;
            if (compareQuantity1 < compareQuantity2) {
                val = 1;
            } else if (compareQuantity1 > compareQuantity2) {
                val = -1;
            } else {
                val = 0;
            }

            return val;
        }
    };

    public int compareTo(Work compareWork) {

        int compareQuantity = Integer.parseInt(((Work) compareWork).workTypeID);

        //ascending order
        return Integer.parseInt(this.workTypeID) - compareQuantity;

        //descending order
        //return compareQuantity - this.quantity;

    }

    public boolean checkIfBillDetailsExist (int workID) {
        BasicDBObject query = new BasicDBObject("Recid",workID);
        int numOfBills = Database.billspaid.find(query).count();

        return (numOfBills>0);

    }
}
