import { LightningElement, api } from "lwc";

/**
 * Child component demonstrating Light DOM (static renderMode = 'light').
 * Rendered without Shadow DOM — styles pierce in from the parent and can escape outward.
 * Used by modernLwcFeatures via the lwc:is dynamic-component directive.
 */
export default class ModernLwcCard extends LightningElement {
  static renderMode = "light";

  @api name;
  @api email;
  @api phone;
}
