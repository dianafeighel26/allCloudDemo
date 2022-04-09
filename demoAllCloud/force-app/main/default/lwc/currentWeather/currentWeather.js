import { LightningElement, api, wire} from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import getCurrentWeatherByCity from '@salesforce/apex/WeatherAPIService.getCurrentWeatherByCity';
import { updateRecord } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';
import BILLING_ADDRESS_STREET from '@salesforce/schema/Account.BillingStreet';
import BILLING_ADDRESS_CITY from '@salesforce/schema/Account.BillingCity';
import BILLING_ADDRESS_COUNTRY from '@salesforce/schema/Account.BillingCountry';
import BILLING_ADDRESS_POSTALCODE from '@salesforce/schema/Account.BillingPostalCode';
import CURRENT_WEATHER from '@salesforce/schema/Account.AccountCurrentWeather__c';
import ID_FIELD from '@salesforce/schema/Account.Id';


const fields = [BILLING_ADDRESS_STREET, BILLING_ADDRESS_CITY, BILLING_ADDRESS_COUNTRY, BILLING_ADDRESS_POSTALCODE, CURRENT_WEATHER];

export default class CurrentWeather extends LightningElement {
    @api
    recordId;
    account;

    @wire(getRecord, { recordId: '$recordId', fields: fields })
    wireRecord({data, error}){
        if(data){
            this.account = data;
        } else if(error){
            this.error = error;
        }
    }

    renderedCallback() {
        getCurrentWeatherByCity({ city: getFieldValue(this.account, BILLING_ADDRESS_CITY) })
        .then(data => {
            const fields = {};
            fields[ID_FIELD.fieldApiName] = this.account.id;
            fields[CURRENT_WEATHER.fieldApiName] = data;
            const recordInput = { fields };

            updateRecord(recordInput)
                .then(() => refreshApex(this.account))
                .catch(error => console.log(error));
        }).catch(err => console.log(err));
    }

    get billingAddressStreet() {
        return getFieldValue(this.account, BILLING_ADDRESS_STREET);
    }

    get billingAddressCity() {
        return getFieldValue(this.account, BILLING_ADDRESS_CITY);
    }

    get billingAddressCountry() {
        return getFieldValue(this.account, BILLING_ADDRESS_COUNTRY);
    }

    get billingAddressPostalCode() {
        return getFieldValue(this.account, BILLING_ADDRESS_POSTALCODE);
    }

    get currentWeather() {
        return getFieldValue(this.account, CURRENT_WEATHER);
    }
}