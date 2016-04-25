package smartcity;

import com.mongodb.DBCursor;
import com.mongodb.DBObject;


/**
 * Created by minchu on 21/04/16.
 */
public class Ward {

    public String wardNumber;
    public String corporator;
    public int population;
    public int amountSpent;
    public String kml;

    public static Ward[] allwards;
    public static String alwards = "";

    /** Constructor method for class Ward */
    public Ward (DBObject object) {
        try {
            this.wardNumber = object.get("ID").toString();
            this.corporator = object.get("Corporator Name English").toString();
            this.population = (int) object.get("Population_2011");
            alwards = alwards + this.wardNumber + ",";
        }
        catch (Exception e) {
            System.err.println(e.getClass().getName() + " : " + e.getMessage());
        }
    }
    /** Returns the string of all the ward numbers. This is for the chart. */
    public static String getAllWardNumbersString(){

        String allWardNumbersString = "";

        try {
            for (int i = 0; i < allwards.length; i++) {
                allWardNumbersString = allWardNumbersString + allwards[i].corporator + ",";
                System.out.println(allwards[i].wardNumber);
            }
        }
        catch (Exception e) {
            System.err.println(e.getClass().getName() + " : " + e.getMessage()+"ihi");
        }

        return allWardNumbersString;
    }

    /** Creates static array of all the ward objects from wardmaster collection in the database. */
    public static void createAllWardObjects(){

            DBCursor cursor = Database.wardmaster.find();

            int i = 0;
            try {
            while (cursor.hasNext()) {
                DBObject wardDBObject = cursor.next();

                allwards[i] = new Ward(wardDBObject);
                i++;
            }
            }
            catch (Exception e) {
                System.err.println(e.getClass().getName() + " : " + e.getMessage()+"ihi");
            }

        }

    }
