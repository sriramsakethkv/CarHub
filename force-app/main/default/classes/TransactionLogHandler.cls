public class TransactionLogHandler {
    public static void doHandleException(System.Exception ex, string processName){
        Error_Log__c transactionLog = new Error_Log__c (
        	Log_Details__c = ex.getStackTraceString() + 'Message' + ex.getMessage()+ 'Cause of exception is ' 
            + ex.getCause() + 'Exception type ' + ex.getTypeName() + 'Exception occured in line '+ ex.getLineNumber(),
            
            Log_Date_Time__c = System.now(),
            Process_name__c  = processName
        );
        
        insert transactionLog;
    }
    
    public static void doHandleExceptionError(String ex, string processName){
        Error_Log__c transactionLog = new Error_Log__c (
        	Log_Details__c = ex,
            
            Log_Date_Time__c = System.now(),
            Process_name__c  = processName
        );
        
        insert transactionLog;
    }
}