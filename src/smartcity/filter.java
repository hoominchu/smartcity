package smartcity;

import com.mongodb.*;

import java.util.LinkedHashSet;
import java.util.Set;
import javax.servlet.http.HttpServletRequest;

/**
 * Created by minchu on 15/04/16.
 */
public class Filter {
    public String parameter;
    public String parameterValue;
    public String parameterPresentable;
    public String parameterValuePresentable;

    public static Set<Filter> FILTERS= new LinkedHashSet<>();

    public Filter(String p, String pV, String pP, String queryKey) {
        this.parameter = p;
        this.parameterValue = pV;
        this.parameterPresentable = pP;

        BasicDBObject parameterValuePresentableObject = new BasicDBObject();
        boolean isNumeric = pV.matches("[0-9]+");
        if(isNumeric) {
            parameterValuePresentableObject.put(queryKey, Integer.parseInt(pV));
        }
        else if (!isNumeric){
            parameterValuePresentableObject.put(queryKey,pV);
        }
        DBCursor cursor = Database.allworks.find(parameterValuePresentableObject);

        while (cursor.hasNext()) {
            DBObject object = cursor.next();
            this.parameterValuePresentable = object.get(pP).toString();
            break;
        }
    }

    public static BasicDBObject generateFiltersHashset(HttpServletRequest request){

        String wardNumberParameter = request.getParameter("wardNumber");
        String statusParameter = request.getParameter("status");
        String workTypeIDParameter = request.getParameter("workTypeID");
        String contractorIDParameter = request.getParameter("contractorID");
        String sourceOfIncomeIDParameter = request.getParameter("sourceOfIncomeID");
        String languageParameter = request.getParameter("language");

        FILTERS.clear();
        BasicDBObject myQuery = new BasicDBObject();

        if (wardNumberParameter != null) {
            myQuery.put("Ward Number", Integer.parseInt(wardNumberParameter));

            Filter click = new Filter("wardNumber", wardNumberParameter, "Ward Number", "Ward Number");
            FILTERS.add(click);
        }

        if (statusParameter != null) {
            myQuery.put("Status", statusParameter);

            Filter click = new Filter("status", statusParameter, "Status", "Status");
            FILTERS.add(click);
        }

        if (workTypeIDParameter != null) {
            myQuery.put("Work Type ID", Integer.parseInt(workTypeIDParameter));

            Filter click = new Filter("workTypeID", workTypeIDParameter, "Work Type", "Work Type ID");
            FILTERS.add(click);
        }

        if (contractorIDParameter != null) {
            myQuery.put("Contractor ID", Integer.parseInt(contractorIDParameter));

            Filter click = new Filter("contractorID", contractorIDParameter, "Contractor", "Contractor ID");
            FILTERS.add(click);
        }

        if (sourceOfIncomeIDParameter != null) {
            myQuery.put("Source of Income ID", Integer.parseInt(sourceOfIncomeIDParameter));

            Filter click = new Filter("sourceOfIncomeID", sourceOfIncomeIDParameter, "Source of Income", "Source of Income ID");
            FILTERS.add(click);
        }



        return myQuery;
    }
}