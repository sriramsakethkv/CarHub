public class EventAttendeeTriggerHelper {
    public static void EmailSender(list<Event_Attendee__c> EventAttendeeList){
        set<ID> AttendeeIds = new set<ID>();
        set<ID> EventIds = new set<ID>();
        
        for(Event_Attendee__c ea : EventAttendeeList){
            AttendeeIds.add(ea.Attendee__c );
            EventIds.add(ea.Event__c );
        }
         Map<ID,Attendee__c> attendeeMap = new Map<ID,Attendee__c>([select ID,name,Email__c  from Attendee__c where ID IN: AttendeeIds]);
         Map<ID,Event__c> eventMap = new Map<ID,Event__c>([select ID,Name__c,Start_Date_Time__c,Location__c,
                                                           Location__r.Name,Location__r.State__c,Location__r.City__c,
                                                           Location__r.Country__c,Location__r.Street__c,Location__r.Postal_Code__c,Organiser__r.name from Event__c
                                                           where ID IN : EventIds]);
        
        list<Messaging.SingleEmailMessage> emailList = new list<Messaging.SingleEmailMessage>();
        for(Event_Attendee__c eat : EventAttendeeList){
            Attendee__c att = attendeeMap.get(eat.Attendee__c);
            Event__c evnt = eventMap.get(eat.Event__c);
            
            //Email template here
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setSubject('Pass for the' + evnt.Name__c);
            list<string> toAddress = new list<string>();
            toAddress.add(att.Email__c);
            mail.setToAddresses(toAddress);
            
            string emailBody = 'Dear' + att.Name + ' ,</br>'+ 
								'Thank you for registering for' + evnt.Name__c + 'which will be Organized on' + evnt.Start_Date_Time__c + ' & will be held in' +evnt.Location__r.name +'.We are excited to have you, see you in the event.</br>'
								+'Find the Google Map Location for the Event Here<br/>.'+
                				'https://www.google.com/maps/place/' + '<br/>>br/>' +

								'Thanks,<br/>'+ evnt.Organiser__r.name;
								
            
            mail.setHtmlBody(emailBody);
            emailList.add(mail);
        }
        
        try{
            List<Messaging.SendEmailResult> results = Messaging.sendEmail(emailList, false);
        }catch(System.Exception ex){
            system.debug('Error');
        }
    }
}