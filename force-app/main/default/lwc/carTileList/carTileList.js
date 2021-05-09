import { LightningElement,wire } from 'lwc';
import getCars from '@salesforce/apex/carController.getCars'

//Lightning Message Service related imports
import CARS_FILTER from '@salesforce/messageChannel/CarsFiltered__c'
import CAR_SELECTED from '@salesforce/messageChannel/CarSelected__c'
import { publish,subscribe,MessageContext } from 'lightning/messageService'

export default class CarTileList extends LightningElement {
    cars=[]
    error
    filters = {}
    carFilterSubscription
    @wire(getCars,{filters:'$filters'})
    carHandler({data,error}){
        if(data){
//            console.log(data);
            this.cars = data;
        }
        if(error){
            console.error(error);
            this.error = error;
        }
    }

    //LMS Related code

    @wire(MessageContext)
    messageContext
    // subscribing to car filters
    connectedCallback(){
        this.carFilterSubscription = subscribe(this.messageContext,CARS_FILTER,(message)=>{this.handleFilterChanges(message)})
    }

    handleFilterChanges(message){
        console.log(message.filters)
        this.filters = {...message.filters}
    }

    //publishing the selected car
    //Handle Car click event

    handleClick(event){
        publish(this.messageContext,CAR_SELECTED,{
            selection : event.detail
        })
        console.log('car is',event.detail)
    }

}