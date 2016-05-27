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

    public int capitalWorks;
    public int capitalInprogressWorks;
    public int capitalCompletedWorks;
    public int capitalAmountSpent;

    public int maintenanceWorks;
    public int maintenanceInprogressWorks;
    public int maintenanceCompletedWorks;
    public int maintenanceAmountSpent;

    public int emergencyWorks;
    public int emergencyInprogressWorks;
    public int emergencyCompletedWorks;
    public int emergencyAmountSpent;

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
    public static void createAllWardObjects() {

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
                for (int k = 0; k < Work.allWorks.size(); k++) {

                    Work tempWork = Work.allWorks.get(k);

                    if (tempWork.wardNumber == allwards[j].wardNumber) {

                        //Counts capital works
                        if (tempWork.workType.equals("Capital")){
                            allwards[j].capitalWorks++;
                            allwards[j].capitalAmountSpent = allwards[j].capitalAmountSpent + tempWork.amountSanctioned;

                            if (tempWork.statusfirstLetterCapital.equals("Inprogress")){
                                allwards[j].capitalInprogressWorks++;
                            }

                            else {
                                allwards[j].capitalCompletedWorks++;
                            }
                        }

                        //Counts maintenance works
                        else if (tempWork.workType.equals("Maintenance")){
                            allwards[j].maintenanceWorks++;
                            allwards[j].maintenanceAmountSpent = allwards[j].maintenanceAmountSpent + tempWork.amountSanctioned;

                            if (tempWork.statusfirstLetterCapital.equals("Inprogress")){
                                allwards[j].maintenanceInprogressWorks++;
                            }

                            else {
                                allwards[j].maintenanceCompletedWorks++;
                            }
                        }

                        //Counts emergency works
                        else if (tempWork.workType.equals("Emergency")){
                            allwards[j].emergencyWorks++;
                            allwards[j].emergencyAmountSpent = allwards[j].emergencyAmountSpent + tempWork.amountSanctioned;

                            if (tempWork.statusfirstLetterCapital.equals("Inprogress")){
                                allwards[j].emergencyInprogressWorks++;
                            }

                            else {
                                allwards[j].emergencyCompletedWorks++;
                            }
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

        for (int i = 0; i < allwards.length; i++) {
            allWardNumbersString = allWardNumbersString + allwards[i].wardNumber + ",";
            allWardsAmountSpent = allWardsAmountSpent + allwards[i].amountSpent + ",";
            allWardsTotalWorks = allWardsTotalWorks + allwards[i].totalWorks + ",";
            allWardsCompletedWorks = allWardsCompletedWorks + allwards[i].completedWorks + ",";
            allWardsInprogressWorks = allWardsInprogressWorks + allwards[i].inprogressWorks + ",";
            allWardsPopulation = allWardsPopulation + allwards[i].population + ",";
            allWardsCapitalWorks = allWardsCapitalWorks + allwards[i].capitalWorks + ",";
            allWatdsMaintenanceWorks = allWatdsMaintenanceWorks + allwards[i].maintenanceWorks + ",";
            allWardsEmergencyWorks = allWardsEmergencyWorks + allwards[i].emergencyWorks + ",";

            if (allwards[i].population >0) {
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

        return wardDetails;
    }

    public static String[] getCapitalWorksDetails(){
        String[] capitalDetails = new String[5];

        String allWardNumbersString = "";
        String capitalAmountSpent = "";
        String capitalWorks = "";
        String capitalCompletedWorks = "";
        String capitalInprogressWorks = "";

        for (int i = 0; i < allwards.length; i++) {

            allWardNumbersString = allWardNumbersString + allwards[i].wardNumber + ",";
            capitalAmountSpent = capitalAmountSpent + allwards[i].capitalAmountSpent + ",";
            capitalWorks = capitalWorks + allwards[i].capitalWorks + ",";
            capitalCompletedWorks = capitalCompletedWorks + allwards[i].capitalCompletedWorks + ",";
            capitalInprogressWorks = capitalInprogressWorks + allwards[i].capitalInprogressWorks + ",";

        }

        capitalDetails[0] = allWardNumbersString;
        capitalDetails[1] = capitalAmountSpent;
        capitalDetails[2] = capitalWorks;
        capitalDetails[3] = capitalCompletedWorks;
        capitalDetails[4] = capitalInprogressWorks;

        return capitalDetails;
    }

    public static String[] getMaintenanceDetails(){
        String[] maintenanceDetails = new String[5];

        String allWardNumbersString = "";
        String maintenanceAmountSpent = "";
        String maintenanceWorks = "";
        String maintenanceCompletedWorks = "";
        String maintenanceInprogressWorks = "";

        for (int i = 0; i < allwards.length; i++) {

            allWardNumbersString = allWardNumbersString + allwards[i].wardNumber + ",";
            maintenanceAmountSpent = maintenanceAmountSpent + allwards[i].maintenanceAmountSpent + ",";
            maintenanceWorks = maintenanceWorks + allwards[i].maintenanceWorks + ",";
            maintenanceCompletedWorks = maintenanceCompletedWorks + allwards[i].maintenanceCompletedWorks + ",";
            maintenanceInprogressWorks = maintenanceInprogressWorks + allwards[i].maintenanceInprogressWorks + ",";

        }

        maintenanceDetails[0] = allWardNumbersString;
        maintenanceDetails[1] = maintenanceAmountSpent;
        maintenanceDetails[2] = maintenanceWorks;
        maintenanceDetails[3] = maintenanceCompletedWorks;
        maintenanceDetails[4] = maintenanceInprogressWorks;

        return maintenanceDetails;
    }

    public static String[] getEmergencyDetails(){
        String[] emergencyDetails = new String[5];

        String allWardNumbersString = "";
        String emergencyAmountSpent = "";
        String emergencyWorks = "";
        String emergencyCompletedWorks = "";
        String emergencyInprogressWorks = "";

        for (int i = 0; i < allwards.length; i++) {

            allWardNumbersString = allWardNumbersString + allwards[i].wardNumber + ",";
            emergencyAmountSpent = emergencyAmountSpent + allwards[i].emergencyAmountSpent + ",";
            emergencyWorks = emergencyWorks + allwards[i].emergencyWorks + ",";
            emergencyCompletedWorks = emergencyCompletedWorks + allwards[i].emergencyCompletedWorks + ",";
            emergencyInprogressWorks = emergencyInprogressWorks + allwards[i].emergencyInprogressWorks + ",";

        }

        emergencyDetails[0] = allWardNumbersString;
        emergencyDetails[1] = emergencyAmountSpent;
        emergencyDetails[2] = emergencyWorks;
        emergencyDetails[3] = emergencyCompletedWorks;
        emergencyDetails[4] = emergencyInprogressWorks;

        return emergencyDetails;
    }

    /**
     * Returns the string of all the ward numbers.
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
     * Returns the string of amount spent in all wards.
     */  //Edit
    public static String getAllWardsAmountSpent() {

        String allWardsAmountSpent = "";
        for (int i = 0; i < allwards.length; i++) {
            allWardsAmountSpent = allWardsAmountSpent + allwards[i].amountSpent + ",";
        }
        return allWardsAmountSpent;
    }

    /**
     * Returns the string of total works in all wards.
     */  //Edit
    public static String getAllWardsTotalWorks() {

        String allWardsTotalWorks = "";
        for (int i = 0; i < allwards.length; i++) {
            allWardsTotalWorks = allWardsTotalWorks + allwards[i].totalWorks + ",";
        }
        return allWardsTotalWorks;
    }

    /**
     * Returns the string of completed works in all wards.
     */  //Edit
    public static String getAllWardsCompletedWorks() {

        String allWardsCompletedWorks = "";
        for (int i = 0; i < allwards.length; i++) {
            allWardsCompletedWorks = allWardsCompletedWorks + allwards[i].completedWorks + ",";
        }
        return allWardsCompletedWorks;
    }

    /**
     * Returns the string of all inprogress works.
     */  //Edit
    public static String getAllWardsInprogressWorks() {

        String allWardsInprogressWorks = "";
        for (int i = 0; i < allwards.length; i++) {
            allWardsInprogressWorks = allWardsInprogressWorks + allwards[i].inprogressWorks + ",";
        }
        return allWardsInprogressWorks;
    }

}
