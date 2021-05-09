public class LocationVerifierTriggerHelper {
	@future(callout=true)
    public static void verifyAddress(string recordId){
        
        Location__c loc = [select Id,Name,Street__c ,City__c ,State__c ,Postal_Code__c ,Country__c
                           from Location__c
                           where ID = :recordId];
		//Building end point
			String baseurl = 'https://us-street.api.smartystreets.com/street-address?auth-id=df555c01-b4e2-33eb-a26e-4f00ba4e5128&auth-token=esHTtuHqTyoDTXTEZGSZ';
        	baseurl += '&street='+EncodingUtil.urlEncode(loc.Street__c, 'UTF-8')
                		+'&city='+EncodingUtil.urlEncode(loc.City__c, 'UTF-8')
                		+'&state='+EncodingUtil.urlEncode(loc.State__c, 'UTF-8')
                		+'&zipcode='+EncodingUtil.urlEncode(loc.Postal_Code__c, 'UTF-8')
                		+'&match=invalid';
        
		//API call
		Http http = new Http();
		HttpRequest request = new HttpRequest();
		request.setMethod('GET');
        request.setHeader('Content-Type', 'application/json');
		request.setEndpoint(baseurl);  
        HttpResponse response = new HttpResponse();
        
        //making callout
            try{
                response = http.send(request);
                system.debug('status code'+response.getStatusCode());
                if(response.getStatusCode() == 200){
                    string responseBody = response.getBody();
                    if(!String.isBlank(responseBody)){
                        loc.verified__c = true;
                    }else{
                        loc.verified__c = false;
                    }
                }else{
                    TransactionLogHandler.doHandleExceptionError(response.getBody(), 'LocationVerifierTriggerHelper');
                }
            
            }catch(System.CalloutException ex){
                TransactionLogHandler.doHandleException(ex, 'LocationVerifierTriggerHelper');
            }
        update loc;
    }
}