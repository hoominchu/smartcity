package smartcity;

import com.mongodb.BasicDBObject;
import com.mongodb.DBCursor;
import com.mongodb.DBObject;

/**
 * Created by minchu on 21/04/16.
 */
public class Ward {

    public int wardNumber;
    public String corporator;
    public int population;
    public int totalWorks;
    public int inprogressWorks;
    public int completedWorks;
    public int amountSpent;
    public String kml;

    public static Ward[] allwards = new Ward[(int) Database.wardmaster.count()];
    public static int physicalWards = 67;

    /**
     * Constructor method for class Ward
     */
    public Ward(DBObject object) {
        try {
            this.wardNumber = (int) object.get("ID");

        } catch (Exception e) {
            System.err.println(e.getClass().getName() + " : " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * Returns the string of all the ward numbers. This is for the chart.
     */
    public static String getAllWardNumbersString() {

        String allWardNumbersString = "";
        for (int i = 0; i < allwards.length; i++) {
            allWardNumbersString = allWardNumbersString + allwards[i].wardNumber + ",";
        }
        allWardNumbersString = allWardNumbersString.substring(0, allWardNumbersString.length() - 1);
        return allWardNumbersString;
    }

    /**
     * Returns the string of all the ward numbers. This is for the chart.
     */  //Edit
    public static String getAllWardsAmountSpent() {

        String allWardsAmountSpent = "";
        for (int i = 0; i < allwards.length; i++) {
            allWardsAmountSpent = allWardsAmountSpent + allwards[i].amountSpent + ",";
        }
        return allWardsAmountSpent;
    }

    /**
     * Returns the string of all the ward numbers. This is for the chart.
     */  //Edit
    public static String getAllWardsTotalWorks() {

        String allWardsTotalWorks = "";
        for (int i = 0; i < allwards.length; i++) {
            allWardsTotalWorks = allWardsTotalWorks + allwards[i].totalWorks + ",";
        }
        return allWardsTotalWorks;
    }

    /**
     * Returns the string of all the ward numbers. This is for the chart.
     */  //Edit
    public static String getAllWardsCompletedWorks() {

        String allWardsCompletedWorks = "";
        for (int i = 0; i < allwards.length; i++) {
            allWardsCompletedWorks = allWardsCompletedWorks + allwards[i].completedWorks + ",";
        }
        return allWardsCompletedWorks;
    }

    /**
     * Returns the string of all the ward numbers. This is for the chart.
     */  //Edit
    public static String getAllWardsInprogressWorks() {

        String allWardsInprogressWorks = "";
        for (int i = 0; i < allwards.length; i++) {
            allWardsInprogressWorks = allWardsInprogressWorks + allwards[i].inprogressWorks + ",";
        }
        return allWardsInprogressWorks;
    }


    /**
     * Creates static array of all the ward objects from wardmaster collection in the database.
     */
    public static void createAllWardObjects() {

        //Sets up all the ward objects from the database.
        DBCursor cursor = Database.wardmaster.find();
        DBObject sortBy = new BasicDBObject();
        sortBy.put("ID", 1);
        cursor.sort(sortBy);
        int i = 0;
        while (cursor.hasNext()) {
            DBObject wardDBObject = cursor.next();
            allwards[i] = new Ward(wardDBObject);
            i++;
        }
        cursor.close();


        //Setting up fields for physical wards as there are some extra wards used for departments for which parameters like population, corporator are irrelevant.

        cursor = Database.wardmaster.find();
        cursor.sort(sortBy);
        i = 0;

        while (cursor.hasNext()) {
            if (i < physicalWards) {
                try {
                    DBObject wardDBObject = cursor.next();
                    allwards[i].corporator = wardDBObject.get("Corporator Name English").toString();
                    allwards[i].population = (int) wardDBObject.get("Population_2011");
                    i++;
                } catch (Exception e) {
                    e.printStackTrace();
                    System.err.println(e.getMessage());
                }
            } else {
                break;
            }

        }

        //Calculating the number of works, amount spent in every ward and storing it in the objects.


        //Counts all the works (in progress, completed and total) and ward-wise expenditure and stores them in the object.
        //Work[] allworks = Work.createWorkObjects(new BasicDBObject());

        //System.out.println(Work.allWorks.length);
        //System.out.println(allwards.length);

        try {
            for (int j = 0; j < allwards.length; j++) {
                for (int k = 0; k < Work.allWorks.length; k++) {

                    if (Work.allWorks[k].wardNumber == allwards[j].wardNumber) {

                        //Counts the number of in progress and completed works for every ward.
                        if (Work.allWorks[k].statusfirstLetterCapital.equals("Completed")) {
                            allwards[j].completedWorks++;
                        } else if (Work.allWorks[k].statusfirstLetterCapital.equals("Inprogress")) {
                            allwards[j].inprogressWorks++;
                        }
                        allwards[j].totalWorks++;
                        //Updates the amount spent in every ward.
                        allwards[j].amountSpent = allwards[j].amountSpent + Work.allWorks[k].amountSanctioned;
                    }

                }

            }
        }
        catch (Exception e){
            e.printStackTrace();
            System.out.println(e.getMessage());
        }

    }
}
