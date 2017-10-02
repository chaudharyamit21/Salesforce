@RestResource(urlMapping='/api/UpdateOpportunity')
global with sharing class UpdateOpportunity
{
    @HttpPost
    global static void doPost( ) 
    {
        //ResponseBase customeResponse = new ResponseBase();
        RestRequest req = RestContext.request;

        RestResponse standardResp = RestContext.response;

        OpportunityWrapper reqBodyObj;

        try {
            String requestBody = RestContext.request.requestBody.toString();
            reqBodyObj = (OpportunityWrapper) JSON.deserialize(requestBody, OpportunityWrapper.class);
        } catch (Exception ex) {
            return ;
        }
        //String validationMessage = validateRequest(reqBodyObj);
        System.debug('--------------->'+reqBodyObj);
        
        List<Opportunity> opportunityList;
        if(reqBodyObj.opportunityNumber != null){
            opportunityList = [select name,AccountId,stageName,closeDate from Opportunity where name =:reqBodyObj.opportunityNumber limit 1]; 
        }
        List<Account> accountList;
        if(reqBodyObj.customerName != null){
            accountList = [select id,name from Account where name =:reqBodyObj.customerName limit 1 ]; 
        }
        
        if(opportunityList.size() >0 ){ 
            for(Opportunity opty:opportunityList){
                opty.AccountId = accountList[0].id;             
                opty.stageName=reqBodyObj.status;               
                opty.closeDate = System.today()+30;
            }            
            update opportunityList;
            
            
            if(reqBodyObj.opportunityNotes != null && reqBodyObj.opportunityNotes.size() > 0){
                    List<Note> lstNote = new List<Note>();
                    for(OpportunityNote nt : reqBodyObj.opportunityNotes){
                        if(nt.noteId != null){  
                            Note n = new Note(Id = nt.noteId);                       
                            n.body=nt.noteText;
                            n.title=nt.contentTitle;
                            n.isPrivate=false;  
                            lstNote.add(n);
                        }   
                    }
                    
                    update lstNote;
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
        public List<OpportunityNote> opportunityNotes;
    }

    public class OpportunityNote{
        public String noteId;
        public String noteText;
        public String contentTitle;
    }

    public class CreateOpportunityException extends Exception {}
}