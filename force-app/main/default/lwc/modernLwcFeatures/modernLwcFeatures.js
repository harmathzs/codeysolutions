import { LightningElement, wire } from "lwc";
import { getRecord, getFieldValue } from "lightning/uiRecordApi";
import CONTACT_NAME from "@salesforce/schema/Contact.Name";
import CONTACT_EMAIL from "@salesforce/schema/Contact.Email";
import CONTACT_PHONE from "@salesforce/schema/Contact.Phone";
import CONTACT_ACCOUNT_NAME from "@salesforce/schema/Contact.Account.Name";

// Constructors imported for Feature 4 (lwc:is dynamic component)
import ModernLwcCard from "c/modernLwcCard";
import ModernLwcList from "c/modernLwcList";

const CONTACT_FIELDS = [
  CONTACT_NAME,
  CONTACT_EMAIL,
  CONTACT_PHONE,
  CONTACT_ACCOUNT_NAME
];

export default class ModernLwcFeatures extends LightningElement {
  // ---------------------------------------------------------------
  // Feature 1  ·  lwc:if / lwc:elseif / lwc:else  (Spring '23)
  // No @track needed — plain class fields are auto-reactive in modern LWC
  // ---------------------------------------------------------------
  status = "new";

  get isNew() {
    return this.status === "new";
  }
  get isActive() {
    return this.status === "active";
  }

  setStatusNew() {
    this.status = "new";
  }
  setStatusActive() {
    this.status = "active";
  }
  setStatusClosed() {
    this.status = "closed";
  }

  // ---------------------------------------------------------------
  // Feature 2  ·  lwc:ref  (Summer '23)
  // this.refs.<name> gives a direct reference to the DOM element
  // tagged with lwc:ref="name" — no querySelector required
  // ---------------------------------------------------------------
  focusInput() {
    this.refs.searchInput.focus();
  }

  // ---------------------------------------------------------------
  // Feature 3  ·  lwc:spread  (Summer '23)
  // Build a property object and spread it onto a child component
  // ---------------------------------------------------------------
  isButtonDisabled = false;

  get spreadButtonProps() {
    return {
      label: this.isButtonDisabled
        ? "Button is Disabled"
        : "Click Me (Enabled)",
      variant: this.isButtonDisabled ? "destructive-text" : "brand",
      disabled: this.isButtonDisabled
    };
  }

  // Display the current spread object as JSON for transparency
  get spreadButtonPropsJson() {
    return JSON.stringify(this.spreadButtonProps);
  }

  handleToggleDisabled(event) {
    this.isButtonDisabled = event.detail.checked;
  }

  // ---------------------------------------------------------------
  // Feature 4  ·  lwc:is — Dynamic Components  (Winter '24)
  // Set dynamicCtor to a component constructor; <lwc:component lwc:is={...}>
  // renders it.  lwc:spread forwards props without knowing the concrete type.
  // Child components also showcase Light DOM (static renderMode = 'light').
  // ---------------------------------------------------------------
  dynamicCtor = null;

  // Both child components share the same @api surface, so the same
  // spread object works regardless of which constructor is active.
  get sampleContactProps() {
    return {
      name: "Jane Doe",
      email: "jane.doe@example.com",
      phone: "+1 (555) 234-5678"
    };
  }

  showCardView() {
    this.dynamicCtor = ModernLwcCard;
  }
  showListView() {
    this.dynamicCtor = ModernLwcList;
  }
  clearDynamicView() {
    this.dynamicCtor = null;
  }

  // ---------------------------------------------------------------
  // Feature 5  ·  lightning-record-picker + reactive @wire  (Winter '24)
  // The $ prefix makes selectedRecordId a reactive wire parameter:
  // every time it changes the wire adapter re-executes automatically.
  // ---------------------------------------------------------------
  selectedRecordId = null;
  contactData = null;
  contactError = null;

  @wire(getRecord, { recordId: "$selectedRecordId", fields: CONTACT_FIELDS })
  handleContactWire({ data, error }) {
    if (data) {
      this.contactData = data;
      this.contactError = null;
    } else if (error) {
      this.contactError = error;
      this.contactData = null;
    }
  }

  get contactName() {
    return getFieldValue(this.contactData, CONTACT_NAME);
  }
  get contactEmail() {
    return getFieldValue(this.contactData, CONTACT_EMAIL);
  }
  get contactPhone() {
    return getFieldValue(this.contactData, CONTACT_PHONE);
  }
  get contactAccount() {
    return getFieldValue(this.contactData, CONTACT_ACCOUNT_NAME);
  }

  get contactErrorMessage() {
    if (!this.contactError) return "";
    if (Array.isArray(this.contactError)) {
      return this.contactError.map((e) => e.message).join(", ");
    }
    return this.contactError?.body?.message ?? "Failed to load contact record.";
  }

  handleRecordPickerChange(event) {
    // Reset wire state so the spinner shows while the new record loads
    this.selectedRecordId = event.detail.recordId;
    this.contactData = null;
    this.contactError = null;
  }
}
