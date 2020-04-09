import { LightningElement, wire, track, api } from 'lwc';
import getProducts from '@salesforce/apex/DataTableController.getProducts';
import sendEmail from '@salesforce/apex/EmailController.sendEmail';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';

const columns = [
    {
        label: 'Name',
        fieldName: 'Name'
    },
    {
        label: 'Quantity',
        fieldName: 'Quantity__c',
        type: 'number'
    },
    {
        label: 'Price',
        fieldName: 'Price__c',
        type: 'currency'
    }
    ];
 
export default class popup extends LightningElement {
    @api recordId;
    @track columns = columns;
    @track record = {};
    @track rowOffset = 0;
    @track data = {};
    @track bShowModal = false;
    @wire (getProducts, {quoteId:'$recordId'}) parameters;
    error;
        
    sendQuoteDetails(){
        sendEmail({quoteId:this.recordId})
            .then(() => {
                const evt = new ShowToastEvent({
                    title: 'Sending email',
                    message: 'Email send successfully! ',
                    variant: 'success',
                    mode: 'dismissable'
                });
                this.dispatchEvent(evt);
                this.closeModal();
            })
            .catch(error => {
                this.error = error;
                const evt = new ShowToastEvent({
                    title: 'Sending email',
                    message: 'Failed to send an email! ',
                    variant: 'error',
                    mode: 'dismissable'
                });
                this.dispatchEvent(evt);
            });
    }

    openModal() {  
        this.bShowModal = true;
        refreshApex(this.parameters);
    }
 
    closeModal() {    
        this.bShowModal = false;
    }


}