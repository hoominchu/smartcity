package smartcity;

import com.mongodb.*;

/**
 * Created by minchu on 15/04/16.
 */
public class Database {

    public static MongoClient mongoClient = new MongoClient(new ServerAddress("localhost", 27017));
    public static Mongo mongo = new Mongo();
    public static DB db = mongo.getDB("smartcitydb");

    public static DBCollection allworks = db.getCollection("allworksCollection");
    public static DBCollection workdetailsCollection = db.getCollection("workDetailsCollection");
    public static DBCollection corporatorsCollection = db.getCollection("corporatorsCollection");

    /** Returns array of contractors given the number of contractors and field name by which the top contractors should be fetched. */
    public Contractors[] getTopContractors (int howMany, String byField){

    }
}
