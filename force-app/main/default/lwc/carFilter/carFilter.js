import { LightningElement,wire } from 'lwc';
import { getObjectInfo,getPicklistValues } from 'lightning/uiObjectInfoApi'
import CAR_OBJECT from '@salesforce/schema/Car__c'

//Lightning Message Service related imports
import CARS_FILTER from '@salesforce/messageChannel/CarsFiltered__c'
import { publish,MessageContext } from 'lightning/messageService'

//car schema
import CATEGORY from '@salesforce/schema/Car__c.Category__c'
import MAKE from '@salesforce/schema/Car__c.Make__c'

export default class CarFilter extends LightningElement {
    timer
    filters = {
        searchKey : '',
        maxPrice : 999999
    }
    // getting record type id
    @wire(getObjectInfo,{objectApiName:CAR_OBJECT})
    objectData
    
    //getting category field picklist values
    @wire(getPicklistValues,{recordTypeId:'$objectData.data.defaultRecordTypeId',fieldApiName:CATEGORY})
    categoryData

    //getting Make field picklist values
    @wire(getPicklistValues,{recordTypeId:'$objectData.data.defaultRecordTypeId',fieldApiName:MAKE})
    makeTypeData

    //Lightning Message Service related code
    @wire(MessageContext)
    messageContext

    sendDataToCarList(){
        window.clearTimeout(this.timer)
        this.timer=window.setTimeout(()=>{
            publish(this.messageContext,CARS_FILTER,{
                filters : this.filters
            })
        },400)
    }

    // search key handler
    handleSearchKeyChange(event){
        console.log(event.target.value)
        this.filters = {...this.filters, 'searchKey':event.target.value}
        this.sendDataToCarList();
    }

    //Price handler
    handleMaxPriceChange(event){
        console.log(event.target.value)
        this.filters = {...this.filters,'maxPrice':event.target.value}
        this.sendDataToCarList();
    }

    //Checkbox handler
    handleCheckbox(event){

        if(!this.filters.categories){
            const categories = this.categoryData.data.values.map(item=>item.value)
            const makeTypes = this.makeTypeData.data.values.map(item=>item.value)
            this.filters = {...this.filters,categories,makeTypes}
        }

        const {name,value} = event.target.dataset;
        if(event.target.checked){
            if(!this.filters[name].includes(value)){
                this.filters[name] = [...this.filters[name],value]
            }
        }else{
            this.filters[name] = this.filters[name].filter(item=>item!=value)
        }
        this.sendDataToCarList();
//        console.log('name', name);
//        console.log('value',value);
    }
}