@RestResource(urlMapping='/api/GetAllAccount')
global with sharing class GetAllAccount
{
    @HttpGet
    global static List<AccountResponse> doGet()
    {
        List<AccountResponse> listAccResponse = new List<AccountResponse>();
        RestRequest req = RestContext.request;
        
        List<Account> lstAcc = [SELECT id,Name FROM Account WHERE ownerid=:userInfo.getUserId() ];
        
        if(lstAcc.size() > 0 ){
             for(Account acc : lstAcc)
             {
                AccountResponse customeResponse = new AccountResponse();
                customeResponse.id= acc.id;
                customeResponse.name= acc.name;
                listAccResponse.add(customeResponse);
             }
        }
        else
        {
            throw new GetAllAccountException('Account not found');
        }
        return listAccResponse;     
    }
        
    global class AccountResponse{
        public String Id;
        public String name;
    }


    public class GetAllAccountException extends Exception {}
}