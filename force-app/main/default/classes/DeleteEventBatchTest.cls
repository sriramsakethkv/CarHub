@isTest
public class DeleteEventBatchTest {
	@testSetup
    public static void setup(){
        Event__c evt = new Event__c();
        evt.Name__c = 'Cult fit';
        evt.Max_Seats__c = 100;
        evt.Live__c = true;
        evt.Start_Date_Time__c = System.now().addMonths(-4);
        evt.End_Date_Time__c = System.now().addDays(3).addMonths(-4);
        insert evt;
    }
    
    @isTest
    static void sendDeleteEventTest(){
        
        Test.startTest();
        	Database.executeBatch(new DeleteEventBatch());
        Test.stopTest();
    }
}