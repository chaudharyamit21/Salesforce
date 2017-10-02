@RestResource(urlMapping='/api/CreateContact')
global with sharing class CreateContact
{
    @HttpPost
    global static ResponseBase doPost(String FirstName,String LastName ,String AccountId){
        Contact cont = new Contact();
        cont.FirstName = FirstName;
        cont.LastName = LastName ;
        cont.accountid = accountid;
        insert cont;
         
        ResponseBase custResp = new ResponseBase();
        custResp.id = cont.id;
        custResp.starus = true;
        return custResp;     
    }
        
    global class ResponseBase {             
        public String id;        
        public Boolean starus;
        public String error;        
    }
}