@isTest
public class EventAttendeeTriggerTest {
	@isTest
    static void testEmail(){
        Attendee__c att = new Attendee__c();
        att.name = 'Kohli';
        att.Phone__c = '12345';
        insert att;
       
        Event__c evt = new Event__c();
        evt.Name__c = 'ipl';
        evt.Start_Date_Time__c = Datetime.now();
        evt.Live__c = TRUE;
        evt.Max_Seats__c = 10;
        insert evt;
        
                Event_Attendee__c evat = new Event_Attendee__c();
        evat.Event__c = evt.id;
        evat.Attendee__c = att.Id;
        insert evat;
    }
}