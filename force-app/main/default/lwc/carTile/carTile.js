import { LightningElement,api } from 'lwc';

export default class CarTile extends LightningElement {
    @api car={}

   
    handleClick(){

        this.dispatchEvent(new CustomEvent('carclick',{detail:this.car.Id}))
        
    }
}