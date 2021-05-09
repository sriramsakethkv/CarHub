public with sharing class carController {

    public class Filters{

        @AuraEnabled
        public String searchKey {get;set;}
        @AuraEnabled
        public Decimal maxPrice {get;set;}
        @AuraEnabled
        public String[] categories {get;set;}
        @AuraEnabled
        public String[] makeTypes {get;set;}

    }
    
    
    @AuraEnabled(Cacheable=true)
    public static list<car__c> getCars(Filters filters){
        String key,whereClause='';
        Decimal maxPrice;
        String[] categories,makeTypes, criteria= new list<String>();
        if(filters!= null){
            maxPrice=filters.maxPrice;
            categories = filters.categories;
            makeTypes = filters.makeTypes;
            if(!String.isEmpty(filters.searchKey)){
                key='%'+filters.searchKey + '%';
                criteria.add(' Name LIKE: key ');
            }

            if(filters.maxPrice>=0){
                criteria.add(' MSRP__c <= :maxPrice ');
            }

            if(filters.categories != null){
                criteria.add(' Category__c IN :categories ');
            }
            if(filters.makeTypes != null){
                criteria.add(' Make__c IN :makeTypes ');
            }
        }
        if(criteria.size()>0){
            whereClause = 'WHERE' + String.join(criteria, 'AND');
        }
        String query = 'select Id,Name,MSRP__c,Category__c,Make__c,Picture_URL__c FROM car__c '+whereClause + ' WITH SECURITY_ENFORCED' + ' ORDER BY Name';
        return Database.query(query);
    }
}