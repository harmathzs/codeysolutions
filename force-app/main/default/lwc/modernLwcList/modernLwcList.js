import { LightningElement, api } from "lwc";

/**
 * Child component demonstrating Light DOM (static renderMode = 'light').
 * Counterpart to modernLwcCard, used by modernLwcFeatures via lwc:is
 * to demonstrate swapping components dynamically at runtime.
 */
export default class ModernLwcList extends LightningElement {
  static renderMode = "light";

  @api name;
  @api email;
  @api phone;
}
