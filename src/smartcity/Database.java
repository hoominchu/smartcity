package smartcity;

import com.mongodb.*;

/**
 * Created by minchu on 15/04/16.
 */
public class Database {

    public static MongoClient mongoClient = new MongoClient(new ServerAddress("localhost", 27017));
    public static Mongo mongo = new Mongo();
    public static DB db = mongo.getDB("smartcitydb");

    public static DBCollection allworks = db.getCollection("allworks");
    public static DBCollection corporatorsCollection = db.getCollection("corporatorsC");
    public static DBCollection workDetailsCollection = db.getCollection("workdetails");
}
