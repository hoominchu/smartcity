package smartcity;

/**
 * Created by minchu on 15/04/16.
 */
public class functionsGeneral {

    public static String capitalizeFirstLetter(String input) {
        String output = input.substring(0, 1).toUpperCase() + input.substring(1);
        return output;
    }
}
