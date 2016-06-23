package smartcity;

import com.mongodb.BasicDBObject;
import com.mongodb.DBCursor;
import com.mongodb.DBObject;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by minchu on 17/06/16.
 */
public class MinorWorkType {
    int totalWorks, completedWorks, inprogressWorks;
    int code;
    String meaning;

    public MinorWorkType (int code, String meaning) {
        this.code = code;
        this.meaning = meaning;
    }

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
        return allMinorWorkTypes;

    }

}
