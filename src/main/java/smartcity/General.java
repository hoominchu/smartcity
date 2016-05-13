package smartcity;

import java.util.Iterator;
import java.util.Set;

/**
 * Created by minchu on 15/04/16.
 */
public class General {

    public static String capitalizeFirstLetter(String input) {
        String output = input.substring(0, 1).toUpperCase() + input.substring(1);
        return output;
    }

    /**
     * Decides which language description should be displayed based on the language chosen by the user.
     * @param languageParameter
     * @param workDescriptionEnglish
     * @param workDescriptionKannada
     * @return
     */
    public static String setWorkDescriptionFinal(String languageParameter, String workDescriptionEnglish, String workDescriptionKannada){

        String workDescriptionFinal = null;

        if (languageParameter == null || languageParameter.equals("english")) {
            if (workDescriptionEnglish.length() > 2) {
                workDescriptionFinal = workDescriptionEnglish;
            } else {
                workDescriptionFinal = workDescriptionKannada;
            }
        } else if (languageParameter.equals("kannada")) {
            workDescriptionFinal = workDescriptionKannada;
        }

        return workDescriptionFinal;
    }

    /** Generates the basic dynamic link given the URL request and FILTERS set. */
    public static String genLink (){

        String baseLink = "";

        Iterator filtersIter = Filter.FILTERS.iterator();
        String dynamicLink = baseLink;

        while (filtersIter.hasNext()) {
            Filter call = (Filter) filtersIter.next();

            dynamicLink = dynamicLink + call.parameter + "=" + call.parameterValue + "&";
        }

        dynamicLink = dynamicLink.replaceAll("&&","&");
        dynamicLink = dynamicLink.replace("?&","?");
        return dynamicLink;
    }
}
