public class DeleteEventBatch implements Database.Batchable<sObject>{
    
    public Database.QueryLocator start(Database.BatchableContext bc){
        String Query = 'select ID,Name__c from Event__c where Live__c = true AND End_Date_Time__c < LAST_N_MONTHS:2';
        return Database.getQueryLocator(Query);
    }
    public void execute(Database.BatchableContext bc,list<Event__c > evntList){
        if(!evntList.isEmpty()){
         	list<Database.DeleteResult> result = Database.delete(evntList);
            for(Database.DeleteResult dr : result){
                if(!dr.isSuccess()){
                    //error framework
                }
        	}
        }
    }
    
    public void finish(Database.BatchableContext bc){
        	list<String> addressList = new list<String>();
        	list<Messaging.Email> mailList = new list<Messaging.Email>();
        
        	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setSubject('Execution of batch has been processed');
        	addressList.add('abc@abc.com');
        	mail.setToAddresses(addressList);
            mail.setHtmlBody('Records that are more than 2 months old are deleted');
            mailList.add(mail);
        	try{
                Messaging.sendEmail(mailList);
            }catch(System.Exception ex){
                system.debug('Error');
            }
    	}
}