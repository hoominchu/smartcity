package smartcity;

/**
 * Created by minchu on 16/04/16.
 */
public class Work {

    public String workObjectID;
    public Ward wardNumber;
    public String workDescriptionEnglish;
    public String workDescriptionKannada;
    public String workOrderDate;
    public String workCompletionDate;
    public String workType;
    public Contractor contractorName;
    public String amountSanctionedString;
    public String amountSanctioned;
    public String status;
    public String sourceOfIncome;
    public boolean doWorkDetailsExist;  //Will computed based on various conditions depending on the way the municipal corporation functions. 
    public String kml;

    /** Constructor method for class work */
    public Work(DBObject workObject) {

    }

    /** Create work objects from the given DBCollection and query. Returns an array of work objects. */
    public static Work[] createWorkObjects(BasicDBObject query, DBCollection collection) {

        return works;
    }
}
