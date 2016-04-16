package smartcity;

import com.mongodb.*;
import smartcity.Database;

import javax.xml.crypto.Data;

/**
 * Created by minchu on 15/04/16.
 */
public class ClickStack {
    public String parameter;
    public String parameterValue;
    public String parameterPresentable;
    public String parameterValuePresentable;

    public ClickStack(String p, String pV, String pP, String queryKey) {
        this.parameter = p;
        this.parameterValue = pV;
        this.parameterPresentable = pP;

        Database database = new Database();

        BasicDBObject parameterValuePresentableObject = new BasicDBObject();
        boolean isNumeric = pV.matches("[0-9]+");
        if(isNumeric) {
            parameterValuePresentableObject.put(queryKey, Integer.parseInt(pV));
        }
        else if (!isNumeric){
            parameterValuePresentableObject.put(queryKey,pV);
        }
        DBCursor cursor = database.allworks.find(parameterValuePresentableObject);

        while (cursor.hasNext()) {
            DBObject object = cursor.next();
            this.parameterValuePresentable = object.get(pP).toString();
            break;
        }
    }
}
