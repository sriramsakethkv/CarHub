import { LightningElement ,wire} from 'lwc';
import {NavigationMixin} from 'lightning/navigation'
//Car Schema
import CAR_OBJECT from '@salesforce/schema/car__c'
import NAME_FIELD from '@salesforce/schema/Car__c.Name'
import PICTURE_URL_FIELD from '@salesforce/schema/Car__c.Picture_URL__c'
import CATEGORY_FIELD from '@salesforce/schema/Car__c.Category__c'
import MAKE_FIELD from '@salesforce/schema/Car__c.Make__c'
import MSRP_FIELD from '@salesforce/schema/Car__c.MSRP__c'
import FUEL_FIELD from '@salesforce/schema/Car__c.Fuel_Type__c'
import SEATS_FIELD from '@salesforce/schema/Car__c.Number_of_seats__c'
import CONTROL_FIELD from '@salesforce/schema/Car__c.Control__c'
import { getFieldValue } from 'lightning/uiRecordApi';

//Lightning Message Service related imports
import CAR_SELECTED from '@salesforce/messageChannel/CarSelected__c'
import { subscribe,MessageContext } from 'lightning/messageService'

export default class CarCard extends NavigationMixin(LightningElement) {
    carName
    pictureUrl
    selectedCarSubscription
    placeholderMessage = 'Select a car to display complete details'
    categoryField = CATEGORY_FIELD
    makeField = MAKE_FIELD
    msrpFiled = MSRP_FIELD
    fuelField = FUEL_FIELD
    seatsField = SEATS_FIELD
    controlField = CONTROL_FIELD

    //Id of car record to be displayed
    recordId = ''

    getOtherData(event){
        const {records} = event.detail
        const recordData = records[this.recordId]
        this.carName = getFieldValue(recordData,NAME_FIELD)
        this.pictureUrl = getFieldValue(recordData,PICTURE_URL_FIELD)
    }

    //LMS Related code

    @wire(MessageContext)
    messageContext
    //Subscribe to selected car event
    connectedCallback(){
        this.selectedCarSubscription = subscribe(this.messageContext,CAR_SELECTED,(message)=>{this.handleSelectedCar(message)})
    }

    handleSelectedCar(message){
        this.recordId = message.selection
        console.log(message.selection)
    }

    //Navigate to record page
    handleNavigateToRecord(){
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes:{
                recordId:this.recordId,
                objectApiName:CAR_OBJECT.objectApiName,
                actionName:'view'
            }
        })
    }

}