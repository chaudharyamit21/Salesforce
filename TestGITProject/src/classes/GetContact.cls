@RestResource(urlMapping='/api/GetContact')
global with sharing class GetContact
{
    @HttpPost
    global static List<ContactsResponse> doGet(String AccountId) 
    {
        List<ContactsResponse> listContactResp = new List<ContactsResponse>();
        
        List<Contact> lstContact = [SELECT FirstName,LastName,id,AccountID,
                                    (SELECT id,body FROM Notes) ,
                                    (SELECT id,ActivityDate FROM Tasks),
                                    (SELECT id,URL__c,Name,CreatedDate FROM Documents__r) 
                                    FROM Contact 
                                    WHERE accountid=:Accountid ];
        
        if(lstContact.size() > 0 ){
        }
        else
        {
            throw new GetOpportunityException('Contacts not found');
        }
                        
        return listContactResp;     

    }
        
    global class ContactsResponse {
        public List<Contacts> contacts;
    }

    public class Contacts {
        public String id;
        public String name;
        public String opportunityId;
        public String accountId;
        public List<Notes> notes;
        public List<Documents> documents;
        public List<Meetings> meetings;
    }

    public class Meetings {
        public String id;
        public String meetingDate;
    }

    public class Documents {
        public String id;
        public String url;
        public String title;
        public String documenDate;
    }

    public class Notes {
        public String id;
        public String text;
    }

    public class GetOpportunityException extends Exception {}
}