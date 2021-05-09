import { LightningElement,api } from 'lwc';
import PLACEHOLDER_IMAGE from '@salesforce/resourceUrl/Placeholder'
export default class PlaceHolder extends LightningElement {
    @api message
    placeholderUrl = PLACEHOLDER_IMAGE
}