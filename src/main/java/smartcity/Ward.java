package smartcity;

import com.mongodb.BasicDBObject;
import com.mongodb.DBCursor;
import com.mongodb.DBObject;

import java.util.ArrayList;

/**
 * Created by minchu on 21/04/16.
 */
public class Ward {

    public int wardNumber;
    public String corporator;
    public int population;

    public int capitalWorks;

    public int maintenanceWorks;

    public int emergencyWorks;

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
     * Creates static array of all the ward objects from wardmaster collection in the database.
     */
    public static void createAllWardObjects(ArrayList<Work> works) {

        //Sets up all the ward objects from the database.
        DBCursor cursor = Database.wardmaster.find();
        DBObject sortBy = new BasicDBObject();
        sortBy.put("ID", 1);
        cursor.sort(sortBy);
        int i = 0;
        try {
            while (cursor.hasNext()) {
                DBObject wardDBObject = cursor.next();
                allwards[i] = new Ward(wardDBObject);
                i++;
            }
        }
        catch (Exception e){
            e.printStackTrace();
            System.err.println(e.getMessage());
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
                for (int k = 0; k < works.size(); k++) {

                    Work tempWork = works.get(k);

                    if (tempWork.wardNumber == allwards[j].wardNumber) {

                        //Counts capital works
                        if (tempWork.workType.equals("Capital")){
                            allwards[j].capitalWorks++;

                        }

                        //Counts maintenance works
                        else if (tempWork.workType.equals("Maintenance")){
                            allwards[j].maintenanceWorks++;

                        }

                        //Counts emergency works
                        else if (tempWork.workType.equals("Emergency")){
                            allwards[j].emergencyWorks++;

                        }


                        //Counts the number of in progress and completed works for every ward.
                        if (tempWork.statusfirstLetterCapital.equals("Completed")) {
                            allwards[j].completedWorks++;
                        } else if (tempWork.statusfirstLetterCapital.equals("Inprogress")) {
                            allwards[j].inprogressWorks++;
                        }
                        allwards[j].totalWorks++;
                        //Updates the amount spent in every ward.
                        allwards[j].amountSpent = allwards[j].amountSpent + tempWork.amountSanctioned;
                    }

                }

            }
        }
        catch (Exception e){
            e.printStackTrace();
            System.out.println(e.getMessage());
        }

    }

    public static String[] getWardDetails(){
        String[] wardDetails = new String[7];

        String allWardNumbersString = "";
        String allWardsAmountSpent = "";
        String allWardsTotalWorks = "";
        String allWardsCapitalWorks = "";
        String allWatdsMaintenanceWorks = "";
        String allWardsEmergencyWorks = "";
        String allWardsCompletedWorks = "";
        String allWardsInprogressWorks = "";
        String allWardsPopulation = "";
        String allWardsPerCapitaExpenditure = "";

        for (int i = 0; i < 67; i++) {
            allWardNumbersString = allWardNumbersString + allwards[i].wardNumber + ",";
            allWardsAmountSpent = allWardsAmountSpent + allwards[i].amountSpent + ",";
            allWardsTotalWorks = allWardsTotalWorks + allwards[i].totalWorks + ",";
            allWardsCompletedWorks = allWardsCompletedWorks + allwards[i].completedWorks + ",";
            allWardsInprogressWorks = allWardsInprogressWorks + allwards[i].inprogressWorks + ",";
            allWardsPopulation = allWardsPopulation + allwards[i].population + ",";
            allWardsCapitalWorks = allWardsCapitalWorks + allwards[i].capitalWorks + ",";
            allWatdsMaintenanceWorks = allWatdsMaintenanceWorks + allwards[i].maintenanceWorks + ",";
            allWardsEmergencyWorks = allWardsEmergencyWorks + allwards[i].emergencyWorks + ",";

            if (allwards[i].population > 0) {
                allWardsPerCapitaExpenditure = allWardsPerCapitaExpenditure + (allwards[i].amountSpent / allwards[i].population) + ",";
            }

            else {
                allWardsPerCapitaExpenditure = allWardsPerCapitaExpenditure + "0,";
            }

        }

        wardDetails[0] = allWardNumbersString;
        wardDetails[1] = allWardsAmountSpent;
        wardDetails[2] = allWardsTotalWorks;
        wardDetails[3] = allWardsCompletedWorks;
        wardDetails[4] = allWardsInprogressWorks;
        wardDetails[5] = allWardsPopulation;
        wardDetails[6] = allWardsPerCapitaExpenditure;

        for (int i = 0; i < 7; i++) {
            wardDetails[i] = wardDetails[i].substring(0,wardDetails[i].length()-1);
        }

        return wardDetails;
    }

}
