package smartcity;

import java.util.*;

/**
 * Created by minchu on 21/04/16.
 */
public class Contractor {

    public String ID;
    public String name;
    public int inprogressWorks;
    public int completedWorks;
    public int totalWorks;
    //public String[] typesOfWorksDone;
    public String linkToPersonalWebpage;
    public String address;
    public String emailID;
    public String phoneNumber;
    public int totalContractAmount;

    public static List<Contractor> contractors;

    public Contractor (String newID, String newName){
        this.ID = newID;
        this.name = newName;
    }

    public Contractor (){

    }

    @Override
    public boolean equals(Object obj) {

        if (obj == null) {
            return false;
        }

        Contractor c = (Contractor) obj;

        return (c.ID.equals(this.ID));
    }

    @Override
    public int hashCode(){
        return ID.hashCode();
    }


    public static void createContractors() {

        Set<Contractor> contractorsSet = new HashSet<Contractor>();

        for (int i = 0; i < Work.allWorks.length; i++){
            Contractor c = new Contractor(Work.allWorks[i].contractorID, Work.allWorks[i].contractor);
            contractorsSet.add(c);
        }

        contractors = new ArrayList(contractorsSet);

        for (int i = 0; i < Work.allWorks.length; i++) {

            for (Contractor c : contractors) {
                if (Work.allWorks[i].contractorID.equals(c.ID)) {

                    //Adding amount to the contractor.
                    c.totalContractAmount = c.totalContractAmount + Work.allWorks[i].amountSanctioned;

                    //Adding to thr number of works of the contractor.
                    c.totalWorks++;

                    //Checking the status of the work and adding it to the relevant field.
                    if (Work.allWorks[i].statusfirstLetterCapital.equals("Completed")) {
                        c.completedWorks++;
                    } else if (Work.allWorks[i].statusfirstLetterCapital.equals("Inprogress")) {
                        c.inprogressWorks++;
                    }
                }
            }
        }

        Collections.sort(contractors, compareContractorByAmount);
    }

    public static String getTop50ContractorsNames(){

        String top50ContractorNames = "";

        for (int i = 0; i < 50; i++){
            top50ContractorNames = top50ContractorNames + "'" + contractors.get(i).name + "'" + ",";
        }

        return top50ContractorNames;
    }

    public static String getTop50ContractorsAmount(){

        String top50ContractorAmount = "";

        for (int i = 0; i < 50; i++){
            top50ContractorAmount = top50ContractorAmount + contractors.get(i).totalContractAmount + ",";
        }

        return top50ContractorAmount;
    }

    public static Comparator<Contractor> compareContractorByAmount = new Comparator<Contractor>() {
        @Override
        public int compare(Contractor o1, Contractor o2) {

            int val = 0;
            if (o1.totalContractAmount < o2.totalContractAmount){
                val = 1;
            }

            else if(o1.totalContractAmount > o2.totalContractAmount){
                val = -1;
            }

            else {
                val = 0;
            }

            return val;
        }
    };
}