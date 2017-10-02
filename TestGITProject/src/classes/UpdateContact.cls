@RestResource(urlMapping='/api/UpdateContact')
global with sharing class UpdateContact
{
    @HttpPost
    global static void doPost( ) 
    {
        ContactResponse contResp = new ContactResponse();
        RestRequest req = RestContext.request;

        //RestResponse standardResp = RestContext.response;

        ContactWrapper reqBodyObj;

        try {
            String requestBody = RestContext.request.requestBody.toString();
            reqBodyObj = (ContactWrapper) JSON.deserialize(requestBody, ContactWrapper.class);
        } catch (Exception ex) {
            return ;
        }        
        System.debug('--------------->'+reqBodyObj);
        
        List<Contact> lstContact;
        if(reqBodyObj.contactId != null){
            lstContact = [select Salutation,FirstName,LastName from Contact where Id =:reqBodyObj.contactId limit 1]; 
        }
        if(lstContact.size() >0 ){            
            try{
                
               if(reqBodyObj.contactNotes != null && reqBodyObj.contactNotes.size() > 0){
                    List<Note> lstNote = new List<Note>();
                    for(contactNote nt : reqBodyObj.contactNotes){
                        if(nt.noteId != null){  
                            Note n = new Note(Id =nt.noteId); 
                            n.parentId= reqBodyObj.contactId;   
                            n.body=nt.noteText;
                            n.title=nt.contentTitle;
                            n.isPrivate=false;  
                            lstNote.add(n);
                        }   
                    }
                    
                    update lstNote;
                }
                if(reqBodyObj.documents != null && reqBodyObj.documents.size() > 0){
                    List<Document__c> lstDoc = new List<Document__c>();
                    for(Document doc : reqBodyObj.Documents){
                        if(doc.documentId != null){
                            Document__c dc = new Document__c(Id = doc.documentId );                     
                            dc.URL__c = doc.URL;
                            dc.name = doc.tital;    
                            dc.Contact__c = reqBodyObj.contactId;                       
                            lstDoc.add(dc);
                        }   
                    }
                    
                    update lstDoc;
                }
                
                if(reqBodyObj.meetings != null && reqBodyObj.meetings.size() > 0){
                    List<Task> lstMeeting = new List<Task>();
                    for(Meeting me : reqBodyObj.Meetings){
                        if(me.meetingId != null){
                            Task m = new Task(Id = me.meetingId );                      
                            //m.Owner = userInfo.getUserId();
                            m.Status = 'Not Started';
                            m.Subject = 'Meeting';
                            m.WhoId = reqBodyObj.contactId;
                            m.Priority = 'Normal';                      
                            lstMeeting.add(m);
                        }   
                    }                
                    update lstMeeting;
                }
                contResp.contactId = reqBodyObj.contactId;
                contResp.status = 'Success';
                
            }catch(exception ex){
                contResp.contactId = reqBodyObj.contactId;
                contResp.status = 'failure';
                contResp.error = String.valueOf(ex);
            }
        }
        else
        {
            throw new CreateContactException('Contact not Found');

        }
                        
                
    }
    
    private static String validateRequest(ContactWrapper reqBodyObj) {
        // Do validation here 
        return '';
    }
    
    
    public class ContactWrapper {
        public String contactId;   
        public List<ContactNote> contactNotes;
        public List<Document> documents;
        public List<Meeting> meetings;  
    }
    
    public class ContactNote{
        public String noteId;
        public String noteText;
        public String contentTitle;
    }
    
    public class Document {
        public String documentId;
        public String URL;
        public String tital;
        public DateTime documetDateTime;
    }
    
    public class Meeting {
        public String meetingId;
        public DateTime meetingDateTime;
    }
    
    public class ContactResponse {                
        public String contactId;        
        public String status;
        public String error;        
    }


    public class CreateContactException extends Exception {}
}