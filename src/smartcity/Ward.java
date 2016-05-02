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

    public static Ward[] allwards = new Ward[110];

    /**
     * Constructor method for class Ward
     */
    public Ward(DBObject object) {
        super();
        try {
            //if ((int) object.get("ID")<66){
              //  this.corporator = object.get("Corporator Name English").toString();
            //}
            this.wardNumber = (int) object.get("ID");

            //this.population = (int) object.get("Population_2011");
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
        allWardNumbersString = allWardNumbersString.substring(0,allWardNumbersString.length()-1);
        return allWardNumbersString;
    }

    /**
     * Returns the string of all the ward numbers. This is for the chart.
     */  //Edit
    public static String getAllWardsAmountSpent() {

        String allWardCompletedWorks = "";
        for (int i = 0; i < allwards.length; i++) {
            allWardCompletedWorks = allWardCompletedWorks + allwards[i].amountSpent + ",";
        }
        return allWardCompletedWorks;
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


/*
        //Counts all the works (in progress, completed and total) and ward-wise expenditure and stores them in the object.
        Work[] allworks = Work.createWorkObjects(new BasicDBObject());

        System.out.println(allworks.length);

        for (int j = 0; j < allwards.length; j++) {
            for (int k = 0; k < allworks.length; k++) {


                if (allworks[k].wardNumber == allwards[j].wardNumber) {

                  //Counts the number of in progress and completed works for every ward.
                  if (allworks[k].equals("Completed")) {
                      allwards[j].completedWorks++;
                  } else if (allworks[k].statusfirstLetterCapital.equals("Inprogress")) {
                      allwards[j].inprogressWorks++;
                  }

                    //Updates the amount spent in every ward.
                    allwards[j].amountSpent = allwards[j].amountSpent + allworks[k].amountSanctioned;
                }

            }

        }

*/
    }
}
