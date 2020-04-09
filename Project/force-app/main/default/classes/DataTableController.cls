public with sharing class DataTableController {
    @AuraEnabled(cacheable = true)
    public static List<Quote_Product__c> getProducts(String quoteId){
        return [SELECT Id, Price__c, Name, Quantity__c, Quote__c, Product__r.Price__c FROM Quote_Product__c WHERE Quote__c=:quoteId LIMIT 100];
    }

    @AuraEnabled(cacheable = true)
    public static Quote__c getQuote(String quoteId){
        return [SELECT Id, Name, Lead__c, Total_Quote_Price__c, Lead__r.Email FROM Quote__c WHERE Id=:quoteId];
    }
}