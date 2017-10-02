@RestResource(urlMapping='/api/CreateOpportunity')
global with sharing class CreateOpportunity
{
    @HttpPost
    global static void doPost( ) 
    {
        RestRequest req = RestContext.request;

        RestResponse standardResp = RestContext.response;

        OpportunityWrapper reqBodyObj;

        try {
            String requestBody = RestContext.request.requestBody.toString();
            reqBodyObj = (OpportunityWrapper) JSON.deserialize(requestBody, OpportunityWrapper.class);
        } catch (Exception ex) {
            return ;
        }
        System.debug('--------Test------->'+reqBodyObj);
        
        List<Account> lstAccount;
        if(reqBodyObj.customerName != null){
            lstAccount = [select id,name from Account where name =:reqBodyObj.customerName ]; 
        }
        
        if(lstAccount.size() >0 ){
            Opportunity opp = new Opportunity();
            opp.AccountId = lstAccount[0].id;
            opp.Name =reqBodyObj.opportunityNumber;
            opp.stageName=reqBodyObj.status;
            //opp.closeDate = Date.valueOf(reqBodyObj.meetingDate);
            opp.closeDate = System.today()+7;
                        
            insert opp;
            
            if(reqBodyObj.notes != null && reqBodyObj.notes.size() > 0 ){
                List<Note> lstNote = new List<Note>();
                for(Notes nt : reqBodyObj.notes){
                    Note n = new note();
                    n.parentId= opp.id;
                    n.body=nt.note1;
                    n.title=reqBodyObj.contentTitle;
                    n.isPrivate=false;  
                    lstNote.add(n); 
                }
                
                insert lstNote;
            }
            
        }
        else
        {
            throw new CreateOpportunityException('Account not Found');

        }
                        
                
    }
    
    private static String validateRequest(OpportunityWrapper reqBodyObj) {
        // Do validation here 
        return '';
    }
    
    
    public class OpportunityWrapper {
        public String customerName;
        //public String customerContact;
        //public String customerEmail;
        public String opportunityNumber;
        public String meetingDate;
        public String status;
        public String contentTitle;
        public String contentUrl;
        public List<Notes> notes;
    }

    public class Notes {
        public String note1;
    }

    public class CreateOpportunityException extends Exception {}
}