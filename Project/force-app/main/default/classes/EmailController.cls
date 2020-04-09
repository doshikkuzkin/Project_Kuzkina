public with sharing class EmailController {
    @AuraEnabled
    public static void sendEmail(String quoteId){
        Quote__c quote = DataTableController.getQuote(quoteId);
        List<Quote_Product__c> products = DataTableController.getProducts(quoteId);
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setToAddresses(new String [] {quote.Lead__r.Email});
        message.setSubject('Details for '+quote.Name+' quote');
        String body = '<font face="Arial"><h2>Quote details:<br></h2>';
        body+='<h3>Quote Name<h3>';
        body+='<h4>'+ quote.Name +'<h4>';
        body+='<h3>Total Quote Price<h3>';
        body+='<h4>$'+ quote.Total_Quote_Price__c +'<h4></font>';
        body+='<h3>Products<h3>';
        body+='<table  cellpadding="7" border="1">';
        body+='<tr><th>Name</th><th>Price for Unit</th><th>Quantity</th><th>Total Price</th></tr>';
        for (Quote_Product__c product : products){
            body+='<tr><td>'+product.Name+'</td><td>'+product.Product__r.Price__c+'</td><td>'+product.Quantity__c+'</td><td>'+product.Price__c+'</td></tr>';
        }
        body+='</table>';
        message.setHtmlBody(body);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { message });
    }
}