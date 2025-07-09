import {LightningElement} from 'lwc';

import LOCALE from '@salesforce/i18n/locale';
import CURRENCY from '@salesforce/i18n/currency';

export default class LocalExample extends LightningElement {
    myLocale = LOCALE;
    myCurrency = CURRENCY;
    localDate;
    localPrice;

    connectedCallback() {
        let date = new Date(2024, 1, 14);
        this.localDate = new Intl.DateTimeFormat(this.myLocale).format(date);
        let price = 11.99;
        let setting = Intl.NumberFormat(this.myLocale, {style: 'currency', currency: this.myCurrency});
        this.localPrice = setting.format(price);
    }
}
