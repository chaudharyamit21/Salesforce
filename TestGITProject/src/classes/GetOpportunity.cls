@RestResource(urlMapping='/api/GetOpportunity')
global with sharing class GetOpportunity
{
    @HttpPost
    global static List<OpportunityResponse> doGet(String AccountId) 
    {
        List<OpportunityResponse> listOppResponse = new List<OpportunityResponse>();
        RestRequest req = RestContext.request;
        RestResponse standardResp = RestContext.response;

        
        List<Opportunity> lstOpp = [Select id,Name,stageName,Account.name,closeDate  from Opportunity where accountid=:AccountId ];
        
        if(lstOpp.size() > 0 ){
             for(Opportunity opp : lstOpp)
             {
                OpportunityResponse customeResponse = new OpportunityResponse();
                customeResponse.id= opp.id;
                customeResponse.name= opp.name;
                customeResponse.closeDate= String.valueOf(opp.closeDate);
                customeResponse.status = opp.stageName;
                listOppResponse.add(customeResponse);
             }
        }
        else
        {
            throw new GetOpportunityException('Opportunity not found');
        }
                        
        return    listOppResponse;     

    }
        
    global class OpportunityResponse {
        public String Id;
        public String name;
        public String closeDate;
        public String status;
    }


    public class GetOpportunityException extends Exception {}
}