package smartcity;

import java.io.File;
import java.io.FileReader;
import java.io.Reader;
import java.net.URL;

import jdk.nashorn.internal.parser.JSONParser;
import org.apache.commons.io.FileUtils;
import org.json.JSONArray;
import org.json.JSONObject;
import org.json.JSONTokener;

/**
 * Created by minchu on 16/06/16.
 */
public class GeoJSON {

    public static void readGeoJSON() {



        try {
            //URL url = new URL("http://hack4hd.org/data/HD-ward-boundaries.json");
            //File f = new File("a.json");
            //FileUtils.copyURLToFile(url,f);
            //FileReader fr = new FileReader(f);
            String string = "{\n" +
                    "   \"pageInfo\": {\n" +
                    "         \"pageName\": \"abc\",\n" +
                    "         \"pagePic\": \"http://example.com/content.jpg\"\n" +
                    "    }\n" +
                    "    \"posts\": [\n" +
                    "         {\n" +
                    "              \"post_id\": \"123456789012_123456789012\",\n" +
                    "              \"actor_id\": \"1234567890\",\n" +
                    "              \"picOfPersonWhoPosted\": \"http://example.com/photo.jpg\",\n" +
                    "              \"nameOfPersonWhoPosted\": \"Jane Doe\",\n" +
                    "              \"message\": \"Sounds cool. Can't wait to see it!\",\n" +
                    "              \"likesCount\": \"2\",\n" +
                    "              \"comments\": [],\n" +
                    "              \"timeOfPost\": \"1234567890\"\n" +
                    "         }\n" +
                    "    ]\n" +
                    "}";
            JSONObject a = new JSONObject(string);
            JSONArray json = a.getJSONArray("posts");

            for (int i = 0; i <json.length(); i++) {
                String k = json.getJSONObject(0).get("message").toString();
                System.out.println(k);
            }

        } catch (Exception e) {
            System.out.println("Error in locating JSON file");
            e.printStackTrace();
        }
    }
}
