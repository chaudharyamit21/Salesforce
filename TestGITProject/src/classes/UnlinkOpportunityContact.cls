@RestResource(urlMapping='/api/UnlinkOpportunityContact')
global with sharing class UnlinkOpportunityContact{

    @HttpPost
    global static Boolean doPost(String ContactId,String OpportunityId){

        List<OpportunityContactRole> lstOCR = [SELECT id 
                                               FROM OpportunityContactRole 
                                               WHERE ContactId =:ContactId 
                                               AND OpportunityId =:OpportunityId];
        if(lstOCR.size() > 0 ){
            Delete  lstOCR;
        }
        else{
            throw new UnlinkOpportunityContactException('Record Not Fount');
        }
            
        return true;     
    }
 
     public class UnlinkOpportunityContactException extends Exception {}

}