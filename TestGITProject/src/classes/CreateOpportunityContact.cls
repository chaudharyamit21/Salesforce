@RestResource(urlMapping='/api/CreateOpportunityContact')
global with sharing class CreateOpportunityContact
{
    @HttpPost
    global static ResponseBase doPost(String ContactId,String OpportunityId){
        OpportunityContactRole OppCont = new OpportunityContactRole();
        OppCont.ContactId = ContactId;
        OppCont.OpportunityId = OpportunityId;
        OppCont.Role = 'Business User' ;
        insert OppCont;
         
        ResponseBase custResp = new ResponseBase();
        custResp.id = OppCont.id;
        custResp.starus = true;
        return custResp;     
    }
        
    global class ResponseBase {             
        public String id;        
        public Boolean starus;
        public String error;        
    }
}