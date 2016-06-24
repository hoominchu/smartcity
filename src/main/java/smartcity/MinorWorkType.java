package smartcity;

import com.mongodb.BasicDBObject;
import com.mongodb.DBCursor;
import com.mongodb.DBObject;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

/**
 * Created by minchu on 17/06/16.
 */
public class MinorWorkType {
    int totalWorks, completedWorks, inprogressWorks;
    int code;
    int amountSpent;
    String meaning;

    public MinorWorkType (int code, String meaning) {
        this.code = code;
        this.meaning = meaning;
    }

    public static Comparator<MinorWorkType> compareMinorWorkType = new Comparator<MinorWorkType>() {
        @Override
        public int compare(MinorWorkType w1, MinorWorkType w2) {
            int val = 0;
            if (w1.code>w2.code) {
                val = 1;
            }
            else {
                val = -1;
            }
            return val;
        }
    };

    public static ArrayList<MinorWorkType> createMinorWorkTypes () {
        ArrayList<MinorWorkType> allMinorWorkTypes = new ArrayList<>();
        DBCursor cursor = Database.minorWorkTypes.find();

        while (cursor.hasNext()) {
            DBObject minorWorkType = cursor.next();
            int code = (int) minorWorkType.get("Code");
            String meaning = minorWorkType.get("Meaning").toString();
            MinorWorkType temp = new MinorWorkType(code,meaning);
            allMinorWorkTypes.add(temp);
        }

        for (int i = 0; i < Work.allWorks.size(); i++) {
            for (int j = 0; j < allMinorWorkTypes.size(); j++) {
                Work tempwork = Work.allWorks.get(i);
                MinorWorkType tempMinorWorkType = allMinorWorkTypes.get(j);
                if (Integer.parseInt(tempwork.minorWorkTypeID) == tempMinorWorkType.code) {

                    tempMinorWorkType.totalWorks++;
                    tempMinorWorkType.amountSpent = tempMinorWorkType.amountSpent + tempwork.amountSanctioned;

                    if (tempwork.statusfirstLetterCapital.equals("Completed")) {
                        tempMinorWorkType.completedWorks++;
                    }
                    else if (tempwork.statusfirstLetterCapital.equals("Inprogress")) {
                        tempMinorWorkType.inprogressWorks++;
                    }
                }

                tempMinorWorkType.amountSpent = Math.abs(tempMinorWorkType.amountSpent);
            }
        }
        allMinorWorkTypes.sort(compareMinorWorkType);
        return allMinorWorkTypes;
    }

    public static String[] getMinorWorkTypeDetails (ArrayList<MinorWorkType> minorWorkTypes) {
        String[] minorWorkDetails = new String[5];
        for (int i = 0; i < 5; i++) {
            minorWorkDetails[i] = "";
        }

        for (int i = 0; i < minorWorkTypes.size(); i++) {

            MinorWorkType minorWorkType = minorWorkTypes.get(i);

            //List of meanings for X-axis
            minorWorkDetails[0] = minorWorkDetails[0] + "'" + minorWorkType.meaning +"'"+ ",";

            minorWorkDetails[1] = minorWorkDetails[1] + minorWorkType.completedWorks + ",";
            minorWorkDetails[2] = minorWorkDetails[2] + minorWorkType.inprogressWorks + ",";
            minorWorkDetails[3] = minorWorkDetails[3] + minorWorkType.totalWorks + ",";
            minorWorkDetails[4] = minorWorkDetails[4] + minorWorkType.amountSpent + ",";
        }

        return minorWorkDetails;
    }
}
