public class UpdateAccountWeather implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful{
    Map<String, String> processedCitiesWithDescription = new Map<String, String>();

    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('SELECT Id, AccountCurrentWeather__c, BillingCity FROM Account WHERE BillingCity != null');
    }

    public void execute(Database.BatchableContext BC, List<Account> accounts){
        Map<String, List<Account>> cityWithAccounts = new Map<String, List<Account>>();
        List<Account> accountsToUpdate = new List<Account>();

        for(Account account: accounts) {
            List<Account> accountsByCity = new List<Account>();
            if(cityWithAccounts.containsKey(account.BillingCity)) {
                accountsByCity = cityWithAccounts.get(account.BillingCity);
            }
            accountsByCity.add(account);
            cityWithAccounts.put(account.BillingCity, accountsByCity);
        }

        for(String city: cityWithAccounts.keySet()) {
            if(!processedCitiesWithDescription.containsKey(city)) {
                String description = WeatherAPIService.getCurrentWeatherByCity(city);
                processedCitiesWithDescription.put(city, description);
            }
            for(Account account: cityWithAccounts.get(city)) {
                if(account.AccountCurrentWeather__c != processedCitiesWithDescription.get(city)) {
                    account.AccountCurrentWeather__c = processedCitiesWithDescription.get(city);
                    accountsToUpdate.add(account);
                }
            }
        }

        try{
            update accountsToUpdate;
        } catch(DmlException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
    }

    public void finish(Database.BatchableContext BC){
        System.debug('Job is done.');
    }
}