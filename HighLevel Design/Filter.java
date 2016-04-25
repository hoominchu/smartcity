package smartcity;

/**
 * Created by minchu on 15/04/16.
 */
public class Filter {
    public String parameter;        //For querying in the backend
    public String parameterValue;       //For querying in the backend
    public String parameterPresentable;     //For displaying puproses. This is fetched from the workObject using the parameters meant for backend querying.
    public String parameterValuePresentable;    //For displaying puproses. This is fetched from the workObject using the parameters meant for backend querying.

    //Constructor method
    public filter(String p, String pV, String pP, String queryKey) {

    }    
}