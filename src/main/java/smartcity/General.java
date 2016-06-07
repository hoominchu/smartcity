package smartcity;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Iterator;
import java.util.Locale;

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

        workDescriptionFinal = cleanText(workDescriptionFinal);
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

    public static String rupeeFormat(String value){
        value=value.replace(",","");
        char lastDigit=value.charAt(value.length()-1);
        String result = "";
        int len = value.length()-1;
        int nDigits = 0;

        for (int i = len - 1; i >= 0; i--)
        {
            result = value.charAt(i) + result;
            nDigits++;
            if (((nDigits % 2) == 0) && (i > 0))
            {
                result = "," + result;
            }
        }
        return (result+lastDigit);
    }

    public static Calendar createDate (String dateString){

        dateString = dateString.replaceAll("-"," ");
        dateString = dateString.substring(0,7) + "20" + dateString.substring(7);

        Calendar date = Calendar.getInstance();
        SimpleDateFormat dateFormat = new SimpleDateFormat("dd MMM yyyy");

        try {
            date.setTime(dateFormat.parse(dateString));
        }
        catch (ParseException e){
            e.printStackTrace();
        }

        return date;

    }

    public static String cleanText (String text){
        if (text.contains(",,")){
            text = text.replaceAll(",,","");
            text = text.substring(0,text.length()-1);
        }
        return text;
    }
}
