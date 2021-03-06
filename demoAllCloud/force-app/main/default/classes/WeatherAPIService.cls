global class WeatherAPIService {
    @AuraEnabled (cacheable = true)
    global static String getCurrentWeatherByCity(String city) {
        String description = '';
        HttpRequest req = new HttpRequest();
        if(!String.isBlank(city)) {
            req.setEndpoint('https://api.openweathermap.org/data/2.5/weather?q=' + city + '&appid=' + ApiKey__mdt.getInstance('WeatherAPI').Key__c);  
        }

        req.setMethod('GET');
        Http http = new Http();
        HTTPResponse res = http.send(req);
        JSONParser parser = JSON.createParser(res.getBody());  

        while (parser.nextToken() != null) {
            if(parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                parser.nextValue();

                if(parser.getCurrentName() == 'description') {
                    description = parser.getText();
                }
            }
        }
        return description;
    }
}