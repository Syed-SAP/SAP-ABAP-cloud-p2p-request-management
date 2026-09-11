
# SAP ABAP Cloud – Purchase-to-Pay Request Management System

## Project Overview

The **Purchase-to-Pay (P2P) Request Management System** is an SAP BTP ABAP Cloud application developed using the **ABAP RESTful Application Programming Model (RAP)**.

The application manages the internal purchase request process from request creation through approval or rejection.

The solution allows an employee/requester to:

- Create a purchase request
- Enter purchase request header information
- Add multiple request items
- Automatically calculate item totals
- Recalculate the complete request total
- Submit a purchase request
- Allow the request to move through an approval workflow
- Approve or reject submitted requests
- Prevent invalid data from being saved
- Control workflow actions according to the current request status
- Work with draft-enabled transactional processing
- Use a Fiori Elements user interface
- Expose the application through an OData V4 service

The project demonstrates a complete **SAP ABAP Cloud RAP transactional application** following a clean-core-oriented architecture.

---

# 1. Business Problem

## 1.1 Existing Business Situation

In a typical organization, employees require different materials, software licenses, services, or other resources.

A purchase request generally contains:

- Requester information
- Department
- Purchase category
- Description
- Required date
- Business justification
- Requested items
- Quantity
- Unit price
- Currency
- Total amount

Without a structured application, purchase requests can be handled through emails, spreadsheets, or manual communication.

This creates several business problems:

- Purchase requests are difficult to track
- Request status is not centrally maintained
- Incorrect amounts can be entered
- Item totals may not match quantities and prices
- Requests may be submitted without proper validation
- Approval decisions are difficult to control
- Users may perform actions that are not valid for the current status
- Draft information can be lost if there is no draft mechanism
- There is no structured transactional process

---

# 2. Business Requirement

The business requires a centralized application where purchase requests can be created and processed through a controlled lifecycle.

## Required Business Flow

```text
Employee Creates Purchase Request
              |
              v
           Draft
              |
              | Submit
              v
         Submitted
          /       \
         /         \
     Approve      Reject
       |             |
       v             v
   Approved       Rejected
````

The system must ensure that the user can only perform valid workflow actions according to the request status.

---

# 3. Consultant Problem-Solution Approach

The project was approached from a business-process perspective rather than only from a coding perspective.

## Step 1 – Understand the Business Process

The purchase request lifecycle was identified as:

```text
Create Request
      ↓
Enter Request Details
      ↓
Add Request Items
      ↓
Calculate Item Totals
      ↓
Calculate Request Total
      ↓
Validate Request
      ↓
Submit Request
      ↓
Approval Decision
      ↓
Approved / Rejected
```

---

## Step 2 – Identify Business Objects

The main business object identified was:

**Purchase Request**

The Purchase Request consists of:

### Header

* Request UUID
* Request ID
* Requester ID
* Department
* Category
* Description
* Total Amount
* Currency
* Required Date
* Justification
* Status
* Administrative fields

### Items

Each request can contain multiple items.

Each item contains:

* Item UUID
* Request UUID
* Item Number
* Material Description
* Quantity
* Unit
* Unit Price
* Item Total
* Currency
* Administrative fields

---

# 4. Solution Design

The solution was implemented using SAP's **ABAP RESTful Application Programming Model (RAP)**.

The application follows a layered structure:

```text
Fiori Elements UI
        |
        v
OData V4 Service
        |
        v
Projection CDS Views
        |
        v
RAP Projection Behavior
        |
        v
RAP Interface CDS Views
        |
        v
RAP Behavior Definition
        |
        v
Behavior Implementation Class
        |
        v
Database Tables
```

---

# 5. SAP Technologies Used

The project uses:

* SAP BTP ABAP Cloud
* ABAP RESTful Application Programming Model (RAP)
* ABAP Cloud
* Core Data Services (CDS)
* CDS View Entities
* Projection Views
* Metadata Extensions
* RAP Behavior Definition
* Managed RAP
* Draft
* Determinations
* Validations
* Actions
* Dynamic Instance Feature Control
* ETag
* Locking
* OData V4
* Fiori Elements
* Clean Core principles
* Eclipse / ABAP Development Tools (ADT)

---

# 6. Project Structure

The main package structure is:

```text
ZP2P_REQ
│
├── ZP2P_BEHAVIOR
│   └── ZC_P2P_REQUEST_P.bdef
│
├── ZP2P_CDS
│   │
│   ├── ZC_P2P_REQUEST
│   ├── ZC_P2P_REQUEST_P
│   ├── ZC_P2P_REQ_ITEM
│   ├── ZC_P2P_REQ_ITEM_P
│   │
│   ├── ZC_P2P_REQUEST_P
│   └── ZC_P2P_REQ_ITEM_P
│
├── ZP2P_DATABASE
│   │
│   ├── ZP2P_REQUEST
│   ├── ZP2P_REQUEST_D
│   ├── ZP2P_REQ_ITEM
│   └── ZP2P_REQ_ITEM_D
│
└── ZP2P_SERVICE
    │
    ├── ZUI_P2P
    └── ZUI_P2P_O4
```

The RAP behavior implementation class is:

```text
ZBP_C_P2P_REQUEST
```

---

# 7. Database Design

## 7.1 Purchase Request Header Table

### Object

```text
ZP2P_DATABASE / ZP2P_REQUEST
```

### Purpose

Stores the persistent purchase request header data.

### Fields

| Field           | Purpose                  |
| --------------- | ------------------------ |
| CLIENT          | Client                   |
| REQUEST_UUID    | Technical unique key     |
| REQUEST_ID      | Business request ID      |
| REQUESTER_ID    | Employee/requester       |
| DEPARTMENT      | Requesting department    |
| CATEGORY        | Purchase category        |
| DESCRIPTION     | Request description      |
| TOTAL_AMOUNT    | Total request amount     |
| CURRENCY        | Currency                 |
| REQUIRED_DATE   | Required date            |
| JUSTIFICATION   | Business justification   |
| STATUS          | Request lifecycle status |
| CREATED_BY      | Creation user            |
| CREATED_AT      | Creation timestamp       |
| LAST_CHANGED_BY | Last change user         |
| LAST_CHANGED_AT | Last change timestamp    |

---

# 8. Draft Database Design

## 8.1 Purchase Request Draft Table

### Object

```text
ZP2P_DATABASE / ZP2P_REQUEST_D
```

This table is used by RAP draft processing.

It contains the purchase request fields together with the RAP draft administrative include:

```abap
"%admin" : include sych_bdl_draft_admin_inc;
```

The draft table allows users to work on purchase requests before final activation.

---

# 9. Purchase Request Item Table

## 9.1 Object

```text
ZP2P_DATABASE / ZP2P_REQ_ITEM
```

### Purpose

Stores the individual items belonging to a purchase request.

### Fields

| Field           | Purpose                   |
| --------------- | ------------------------- |
| CLIENT          | Client                    |
| ITEM_UUID       | Technical unique item key |
| REQUEST_UUID    | Parent request reference  |
| ITEM_NUMBER     | Item number               |
| MATERIAL_DESC   | Material/item description |
| QUANTITY        | Requested quantity        |
| UNIT            | Unit                      |
| UNIT_PRICE      | Price per unit            |
| ITEM_TOTAL      | Calculated item total     |
| CURRENCY        | Currency                  |
| CREATED_BY      | Creation user             |
| CREATED_AT      | Creation timestamp        |
| LAST_CHANGED_BY | Last change user          |
| LAST_CHANGED_AT | Last change timestamp     |

---

# 10. Item Draft Table

## Object

```text
ZP2P_DATABASE / ZP2P_REQ_ITEM_D
```

This table stores draft item data.

It also contains:

```abap
"%admin" : include sych_bdl_draft_admin_inc;
```

The draft item table also contains:

```abap
item_total : abap.dec(15,2);
```

so that the calculated item total is available during draft processing.

---

# 11. CDS Data Model

The application uses a RAP composition between Purchase Request and Request Items.

The relationship is:

```text
ZC_P2P_REQUEST
       |
       | Composition [0..*]
       |
       v
ZC_P2P_REQ_ITEM
```

One Purchase Request can contain multiple Request Items.

---

# 12. Interface CDS – Purchase Request

## Object

```text
ZP2P_CDS / ZC_P2P_REQUEST
```

### Purpose

This is the root interface CDS view entity.

It is based on:

```text
ZP2P_REQUEST
```

The root CDS contains the request header fields and composition to the request items.

### Composition

```abap
composition [0..*] of ZC_P2P_REQ_ITEM as _Item
```

This establishes the parent-child relationship.

---

# 13. Interface CDS – Request Item

## Object

```text
ZP2P_CDS / ZC_P2P_REQ_ITEM
```

### Purpose

Represents the request item business object.

It is based on:

```text
ZP2P_REQ_ITEM
```

The item has a parent association:

```abap
association to parent ZC_P2P_REQUEST as _Request
```

The relationship is based on:

```abap
$projection.request_uuid = _Request.request_uuid
```

---

# 14. Amount and Currency Handling

The application uses CDS semantic annotations for amount fields.

For example:

```abap
@Semantics.amount.currencyCode: 'currency'
total_amount
```

For request items:

```abap
@Semantics.amount.currencyCode: 'currency'
unit_price
```

and:

```abap
@Semantics.amount.currencyCode: 'currency'
item_total
```

This allows the Fiori Elements UI to understand the relationship between an amount and its currency.

---

# 15. Projection CDS – Purchase Request

## Object

```text
ZP2P_CDS / ZC_P2P_REQUEST_P
```

### Purpose

This is the transactional projection used by the service/UI layer.

It is defined as:

```abap
define root view entity ZC_P2P_REQUEST_P
  provider contract transactional_query
  as projection on ZC_P2P_REQUEST
```

The technical UUID is hidden in the UI through:

```abap
@UI.hidden: true
request_uuid;
```

The projection contains UI-related annotations for the request fields.

---

# 16. Projection CDS – Request Item

## Object

```text
ZP2P_CDS / ZC_P2P_REQ_ITEM_P
```

### Purpose

Provides the transactional projection of request items.

It is defined as a projection on:

```text
ZC_P2P_REQ_ITEM
```

The item projection contains:

* Item Number
* Material Description
* Quantity
* Unit
* Unit Price
* Item Total
* Currency

The parent association is redirected to the purchase request projection.

---

# 17. Fiori UI Design

The application uses **Fiori Elements**.

The main Purchase Request Object Page contains:

```text
Purchase Request
│
├── General Information
│
└── Request Items
```

---

# 18. General Information Section

The General Information section displays:

* Request ID
* Requester ID
* Department
* Category
* Description
* Total Amount
* Currency
* Required Date
* Justification
* Status
* Created By
* Created On
* Changed By
* Changed On

---

# 19. Request Items Section

The Request Items table displays:

* Item Number
* Material Description
* Quantity
* Unit
* Unit Price
* Item Total
* Currency

Users can navigate from the request to its individual items.

---

# 20. Metadata Extensions

The UI annotations are separated into metadata extensions.

## Root Metadata Extension

```text
ZP2P_CDS / ZC_P2P_REQUEST_P
```

The root metadata extension controls:

* Object Page facets
* General Information section
* Request Items section
* List report fields
* Identification fields
* Action buttons
* Labels
* Technical field visibility

---

## Item Metadata Extension

```text
ZP2P_CDS / ZC_P2P_REQ_ITEM_P
```

The item metadata extension controls:

* Item Information facet
* Item Number
* Material Description
* Quantity
* Unit
* Unit Price
* Item Total
* Currency

The metadata extension uses:

```abap
@Metadata.layer: #CUSTOMER
```

---

# 21. Object Page Facets

The Purchase Request Object Page contains two major sections.

### General Information

```text
GeneralInformation
```

### Request Items

```text
RequestItems
```

The Request Items facet targets:

```text
_Item
```

This provides the item table directly inside the Purchase Request Object Page.

---

# 22. RAP Behavior Definition

## Object

```text
ZP2P_BEHAVIOR / ZC_P2P_REQUEST_P.bdef
```

The application uses:

```abap
managed implementation in class zbp_c_p2p_request unique;
```

and:

```abap
strict(2);
```

with draft:

```abap
with draft;
```

---

# 23. Root Behavior

The root behavior is defined for:

```text
ZC_P2P_REQUEST
```

Persistent table:

```text
ZP2P_REQUEST
```

Draft table:

```text
ZP2P_REQUEST_D
```

The root uses:

```abap
lock master
total etag last_changed_at
authorization master ( none )
etag master last_changed_at
```

---

# 24. CRUD Operations

The Purchase Request supports:

```abap
create;
update;
delete;
```

This allows users to create, modify, and delete purchase requests through the RAP transactional framework.

---

# 25. Managed Numbering

The technical request UUID uses managed numbering:

```abap
field ( numbering : managed, readonly ) request_uuid;
```

The framework therefore manages the technical UUID.

---

# 26. Read-Only Fields

The following fields are protected from direct modification:

```abap
field ( readonly ) last_changed_at;
field ( readonly ) status;
```

The status is changed through business logic rather than direct user editing.

---

# 27. Request Item Association

The root behavior provides:

```abap
association _Item { create; with draft; }
```

This allows request items to be created as part of the purchase request and supports draft processing.

---

# 28. Request Item Behavior

The item behavior is defined for:

```text
ZC_P2P_REQ_ITEM
```

Persistent table:

```text
ZP2P_REQ_ITEM
```

Draft table:

```text
ZP2P_REQ_ITEM_D
```

The item uses dependent locking:

```abap
lock dependent by _Request
```

and dependent authorization:

```abap
authorization dependent by _Request
```

---

# 29. Item Read-Only Fields

The item technical key is managed:

```abap
field ( numbering : managed, readonly ) item_uuid;
```

The parent request UUID is read-only:

```abap
field ( readonly ) request_uuid;
```

The last changed timestamp is read-only:

```abap
field ( readonly ) last_changed_at;
```

The calculated item total is also read-only:

```abap
field ( readonly ) item_total;
```

The user provides quantity and unit price, while the application calculates the item total.

---

# 30. Business Workflow Actions

The application implements four actions:

```text
Submit Request
Approve Request
Reject Request
Recalculate Total
```

---

# 31. Submit Request

## Business Requirement

A request in Draft status must be submitted before it can enter the approval process.

## Status Transition

```text
Draft
  |
  | Submit Request
  v
Submitted
```

The implementation reads the current request status and changes:

```text
Draft → Submitted
```

Only requests currently in Draft status are changed.

---

# 32. Approve Request

## Business Requirement

A submitted request can be approved by the responsible approval process.

## Status Transition

```text
Submitted
    |
    | Approve Request
    v
Approved
```

The implementation changes:

```text
Submitted → Approved
```

---

# 33. Reject Request

## Business Requirement

A submitted request can be rejected.

## Status Transition

```text
Submitted
    |
    | Reject Request
    v
Rejected
```

The implementation changes:

```text
Submitted → Rejected
```

---

# 34. Recalculate Total

## Business Requirement

The request header total must represent the sum of all request item totals.

The calculation is:

```text
Request Total
    =
Item 1 Total
+
Item 2 Total
+
Item 3 Total
+ ...
```

The Recalculate Total action reads the request items and sums their `item_total` values.

The calculated value is then written to:

```text
total_amount
```

---

# 35. Item Total Determination

The system automatically calculates the item total.

Formula:

```text
Item Total = Quantity × Unit Price
```

For example:

```text
Quantity    = 2
Unit Price  = 25,000

Item Total  = 2 × 25,000
            = 50,000
```

The determination is:

```abap
determination calculateItemTotal on modify {
  create;
  field quantity, unit_price;
}
```

Therefore, the calculation is triggered when an item is created or when the relevant quantity/unit price fields are modified.

---

# 36. Initial Status Determination

When a Purchase Request is created, the system initializes the status.

Determination:

```abap
determination setInitialStatus on modify { create; }
```

The initial status is:

```text
Draft
```

This prevents a newly created request from entering the workflow without going through the submission step.

---

# 37. Total Amount Validation

The system validates that the total amount is greater than zero.

Validation:

```abap
validation validateTotalAmount on save { create; update; }
```

Business rule:

```text
Total Amount > 0
```

If:

```text
Total Amount <= 0
```

the save is rejected.

The application reports:

```text
Total amount must be greater than zero
```

---

# 38. Required Date Validation

The system prevents users from entering a required date in the past.

Validation:

```abap
validation validateRequiredDate on save { create; update; }
```

The system compares the entered required date with the current system date.

Business rule:

```text
Required Date >= Current System Date
```

If the required date is earlier than the current date, saving is blocked.

The application reports:

```text
Required date cannot be in the past
```

---

# 39. RAP Message Handling

The validations use RAP message handling.

For the total amount validation, the application uses:

```abap
new_message(
  id       = 'ZP2P'
  number   = '001'
  severity = if_abap_behv_message=>severity-error
  v1       = 'Total amount must be greater than zero'
)
```

For required date validation, the application uses:

```abap
new_message_with_text(
  severity = if_abap_behv_message=>severity-error
  text     = 'Required date cannot be in the past'
)
```

This provides the user with meaningful business validation messages.

---

# 40. Dynamic Action Feature Control

The workflow actions are controlled according to the current request status.

The actions use instance feature control:

```abap
action ( features : instance ) submitRequest result [1] $self;
action ( features : instance ) approveRequest result [1] $self;
action ( features : instance ) rejectRequest result [1] $self;
```

---

# 41. Action Availability Rules

## Draft

For:

```text
Status = Draft
```

The UI allows:

```text
Submit Request     Enabled
Approve Request    Disabled
Reject Request     Disabled
```

---

## Submitted

For:

```text
Status = Submitted
```

The UI allows:

```text
Submit Request     Disabled
Approve Request    Enabled
Reject Request     Enabled
```

---

## Approved

For:

```text
Status = Approved
```

Workflow actions are disabled:

```text
Submit Request     Disabled
Approve Request    Disabled
Reject Request     Disabled
```

---

## Rejected

For:

```text
Status = Rejected
```

Workflow actions are disabled:

```text
Submit Request     Disabled
Approve Request    Disabled
Reject Request     Disabled
```

---

# 42. Dynamic Feature Control Implementation

The behavior handler contains an instance feature method:

```abap
METHODS get_instance_features
  FOR INSTANCE FEATURES
  IMPORTING keys REQUEST requested_features FOR ZC_P2P_REQUEST
  RESULT result.
```

The method reads the current request status and controls the action availability.

The implementation follows the business rules:

```text
Draft
 └── Submit enabled

Submitted
 ├── Approve enabled
 └── Reject enabled

Approved
 └── Workflow actions disabled

Rejected
 └── Workflow actions disabled
```

The feature control is therefore driven by business state rather than by static UI configuration.

---

# 43. Behavior Implementation Class

## Object

```text
ZP2P_CDS / ZBP_C_P2P_REQUEST
```

The class contains the RAP behavior implementation.

The implementation contains logic for:

```text
calculateItemTotal
setInitialStatus
submitRequest
approveRequest
rejectRequest
recalculateTotal
validateTotalAmount
validateRequiredDate
get_instance_features
```

The behavior is divided into local handler classes for the root and item entities.

---

# 44. calculateItemTotal Implementation

The implementation reads:

```text
quantity
unit_price
```

and calculates:

```text
item_total = quantity × unit_price
```

The result is written back to the request item using:

```abap
MODIFY ENTITIES OF zc_p2p_request IN LOCAL MODE
```

The item total is not entered manually by the user.

---

# 45. setInitialStatus Implementation

When a new request is created, the determination updates:

```text
status = Draft
```

This establishes the starting point of the workflow.

---

# 46. submitRequest Implementation

The action:

1. Reads the current request
2. Reads its status
3. Checks whether the status is `Draft`
4. Changes the status to `Submitted`
5. Reads the updated request
6. Returns the updated entity as the action result

Business transition:

```text
Draft → Submitted
```

---

# 47. approveRequest Implementation

The action:

1. Reads the request
2. Reads the current status
3. Processes requests in `Submitted` status
4. Changes the status to `Approved`
5. Reads the updated request
6. Returns the updated entity

Business transition:

```text
Submitted → Approved
```

---

# 48. rejectRequest Implementation

The action:

1. Reads the request
2. Reads the current status
3. Processes requests in `Submitted` status
4. Changes the status to `Rejected`
5. Reads the updated request
6. Returns the updated entity

Business transition:

```text
Submitted → Rejected
```

---

# 49. recalculateTotal Implementation

The action:

1. Reads the selected Purchase Request
2. Reads the associated `_Item` records
3. Reads each item's `item_total`
4. Adds all item totals
5. Updates the request's `total_amount`
6. Reads the updated request
7. Returns the updated entity

Example:

```text
Item 1 = 50,000
Item 2 = 30,000

Total = 50,000 + 30,000
      = 80,000
```

---

# 50. Draft Processing

The Purchase Request is draft-enabled.

The behavior contains:

```abap
with draft;
```

The following draft actions are available:

```abap
draft action Edit;
draft action Activate optimized;
draft action Discard;
draft action Resume;
draft determine action Prepare;
```

This supports the Fiori Elements draft lifecycle.

---

# 51. Locking and ETag

The root entity uses:

```abap
lock master
```

and:

```abap
total etag last_changed_at
```

The root also defines:

```abap
etag master last_changed_at
```

The item uses dependent locking:

```abap
lock dependent by _Request
```

This supports transactional consistency and protects the application against conflicting changes.

---

# 52. Authorization Design

The current implementation uses:

```abap
authorization master ( none )
```

for the root behavior.

The item behavior uses:

```abap
authorization dependent by _Request
```

No custom authorization implementation is currently part of this project.

---

# 53. Projection Behavior

## Object

```text
ZP2P_BEHAVIOR / ZC_P2P_REQUEST_P.bdef
```

The projection behavior exposes the transactional capabilities of the underlying RAP business object.

It includes:

```abap
use create;
use update;
use delete;
```

Draft actions:

```abap
use action Edit;
use action Activate;
use action Discard;
use action Resume;
use action Prepare;
```

Business actions:

```abap
use action submitRequest;
use action approveRequest;
use action rejectRequest;
use action recalculateTotal;
```

The item projection uses:

```abap
use update;
use delete;
```

and the parent association:

```abap
use association _Request { with draft; }
```

---

# 54. OData V4 Service

## Service Definition

```text
ZP2P_SERVICE / ZUI_P2P
```

The service exposes:

```text
PurchaseRequest
PurchaseRequestItem
```

The service definition contains:

```abap
define service ZUI_P2P {
  expose ZC_P2P_REQUEST_P as PurchaseRequest;
  expose ZC_P2P_REQ_ITEM_P as PurchaseRequestItem;
}
```

---

# 55. Service Binding

## Object

```text
ZP2P_SERVICE / ZUI_P2P_O4
```

Binding type:

```text
OData V4 - UI
```

The service binding is published and used to launch the Fiori Elements application.

---

# 56. Fiori Elements Application

The application is generated through the RAP OData V4 UI service.

The application provides:

```text
List Report
     |
     v
Purchase Request Object Page
     |
     ├── General Information
     |
     └── Request Items
```

The application supports transactional operations through the RAP framework.

---

# 57. Implemented Business Process

The complete implemented process is:

```text
1. Create Purchase Request
          |
          v
2. Enter Header Information
          |
          v
3. Add Request Items
          |
          v
4. Item Total Automatically Calculated
          |
          v
5. Request Total Recalculated
          |
          v
6. Save / Validate
          |
          v
7. Submit Request
          |
          v
8. Submitted
       /     \
      /       \
 Approve     Reject
    |           |
    v           v
Approved     Rejected
```

---

# 58. Test Scenario 1 – Create Purchase Request

A test request was successfully created:

```text
Request ID:       PR00000003
Requester ID:     EMP003
Department:       IT
Category:         Software
Description:      Software licenses for development team
Currency:         INR
Required Date:    Sep 30, 2026
Justification:    Required for development team
```

Initial status:

```text
Draft
```

---

# 59. Test Scenario 2 – Item Total Calculation

### Item 1

```text
Material Description: Development IDE License
Quantity:              2
Unit Price:            25,000
```

Calculation:

```text
2 × 25,000 = 50,000
```

Result:

```text
Item Total = 50,000 INR
```

---

### Item 2

```text
Material Description: Cloud Development License
Quantity:              3
Unit Price:            10,000
```

Calculation:

```text
3 × 10,000 = 30,000
```

Result:

```text
Item Total = 30,000 INR
```

---

# 60. Test Scenario 3 – Request Total

The request contained:

```text
Item 1 = 50,000 INR
Item 2 = 30,000 INR
```

The Recalculate Total action produced:

```text
50,000 + 30,000 = 80,000 INR
```

The Purchase Request header displayed:

```text
Total Amount = 80,000 INR
```

This verified the parent-level total calculation.

---

# 61. Test Scenario 4 – Submit Request

Request:

```text
PR00000003
```

Before action:

```text
Status = Draft
```

After selecting:

```text
Submit Request
```

the status changed to:

```text
Submitted
```

---

# 62. Test Scenario 5 – Approve Request

Request:

```text
PR00000003
```

Before action:

```text
Status = Submitted
```

After:

```text
Approve Request
```

the status changed to:

```text
Approved
```

---

# 63. Test Scenario 6 – Reject Request

A separate test request was used:

```text
PR00000004
```

The request was submitted and then rejected.

Final status:

```text
Rejected
```

This verified the rejection branch of the workflow.

---

# 64. Test Scenario 7 – Total Amount Validation

Test request:

```text
PR00000005
```

The total amount was set to:

```text
0
```

The validation prevented the save.

Message:

```text
Total amount must be greater than zero
```

This confirmed that the business validation works at save time.

---

# 65. Test Scenario 8 – Required Date Validation

The required date was intentionally set to:

```text
Sep 10, 2026
```

The system date was later than the entered date.

The validation prevented the save.

Message:

```text
Required date cannot be in the past
```

This confirmed the date validation.

---

# 66. Test Scenario 9 – Dynamic Action Control

The UI was tested against different request statuses.

### Approved Request

Example:

```text
PR00000003
Status = Approved
```

The workflow actions were disabled.

---

### Submitted Request

Example:

```text
PR00000005
Status = Submitted
```

The UI showed:

```text
Submit Request     Disabled
Approve Request    Enabled
Reject Request     Enabled
```

This verified status-based action control.

---

### Rejected Request

Example:

```text
PR00000004
Status = Rejected
```

The workflow actions were disabled.

---

# 67. Issues Encountered During Development

## Issue 1 – Incorrect Feature Control Syntax

An initial attempt used an incorrect action syntax.

The incorrect form was:

```abap
action submitRequest result [1] $self features : instance;
```

This produced syntax errors.

The action definition was corrected to:

```abap
action ( features : instance ) submitRequest result [1] $self;
```

Similarly:

```abap
action ( features : instance ) approveRequest result [1] $self;
```

and:

```abap
action ( features : instance ) rejectRequest result [1] $self;
```

The corrected syntax activated successfully.

---

# 68. Issue 2 – Authorization Instance Runtime Error

An earlier implementation attempted instance authorization:

```abap
authorization master ( instance )
```

This caused a RAP runtime error involving instance authorization handling.

The implementation was changed to:

```abap
authorization master ( none )
```

The application then continued using the intended authorization configuration.

---

# 69. Issue 3 – ETag Placement

The RAP behavior definition required the total ETag declaration in the correct position.

The root behavior uses:

```abap
lock master
total etag last_changed_at
```

followed by:

```abap
authorization master ( none )
etag master last_changed_at
```

This corrected the behavior definition syntax.

---

# 70. Issue 4 – Draft Table Administration

The draft tables initially required the RAP draft administration include.

The draft tables were corrected to include:

```abap
"%admin" : include sych_bdl_draft_admin_inc;
```

This allowed the draft behavior to work correctly.

---

# 71. Issue 5 – Item Total Persistence

The item draft table needed to contain the calculated field:

```abap
item_total : abap.dec(15,2);
```

This was added to:

```text
ZP2P_REQ_ITEM_D
```

---

# 72. Issue 6 – Required Date System Date

The first implementation used:

```abap
sy-datum
```

ADT warned that the old variant should not be used in the current ABAP environment.

The implementation was changed to:

```abap
cl_abap_context_info=>get_system_date( )
```

This is the current implementation used for the required-date validation.

---

# 73. Issue 7 – Draft Locking During Testing

During workflow testing, an action initially produced locking messages such as:

```text
Edit not possible: locking of entity ZC_P2P_REQUEST failed
```

and:

```text
Edit not possible: entity ZC_P2P_REQUEST is currently being edited by another user.
```

After the draft/locking state was cleared, the Reject Request action completed successfully.

The test request subsequently showed:

```text
Status = Rejected
```

---

# 74. Clean Core Approach

The application is designed around the ABAP Cloud programming model.

The solution uses:

* CDS view entities
* RAP behavior definitions
* RAP behavior implementation
* OData V4
* Fiori Elements
* Metadata extensions
* Managed RAP
* Draft
* RAP validations
* RAP determinations
* RAP actions

The application does not depend on classic procedural report-based transaction processing.

---

# 75. Business Rules Summary

| Rule                                        | Implementation           |
| ------------------------------------------- | ------------------------ |
| New request starts as Draft                 | `setInitialStatus`       |
| Item total must equal Quantity × Unit Price | `calculateItemTotal`     |
| Request total must equal sum of item totals | `recalculateTotal`       |
| Total amount must be greater than zero      | `validateTotalAmount`    |
| Required date cannot be in the past         | `validateRequiredDate`   |
| Draft can be submitted                      | `submitRequest`          |
| Submitted request can be approved           | `approveRequest`         |
| Submitted request can be rejected           | `rejectRequest`          |
| Workflow actions depend on status           | Instance feature control |
| Draft changes must be supported             | RAP Draft                |
| Concurrent modifications must be controlled | Lock / ETag              |

---

# 76. Status Lifecycle

The implemented lifecycle is:

```text
                +-------------+
                |    Draft    |
                +-------------+
                       |
                       | Submit
                       v
                +-------------+
                |  Submitted  |
                +-------------+
                  /         \
                 /           \
            Approve          Reject
               /               \
              v                 v
       +-------------+    +-------------+
       |  Approved   |    |  Rejected   |
       +-------------+    +-------------+
```

Terminal workflow states:

```text
Approved
Rejected
```

---

# 77. Technical Object Inventory

## Database

```text
ZP2P_DATABASE
│
├── ZP2P_REQUEST
├── ZP2P_REQUEST_D
├── ZP2P_REQ_ITEM
└── ZP2P_REQ_ITEM_D
```

## CDS

```text
ZP2P_CDS
│
├── ZC_P2P_REQUEST
├── ZC_P2P_REQUEST_P
├── ZC_P2P_REQ_ITEM
└── ZC_P2P_REQ_ITEM_P
```

## Metadata Extensions

```text
ZP2P_CDS
│
├── ZC_P2P_REQUEST_P
└── ZC_P2P_REQ_ITEM_P
```

## Behavior

```text
ZP2P_BEHAVIOR
│
└── ZC_P2P_REQUEST_P.bdef
```

## Behavior Implementation

```text
ZBP_C_P2P_REQUEST
```

## Service

```text
ZP2P_SERVICE
│
├── ZUI_P2P
└── ZUI_P2P_O4
```

---

# 78. End-to-End Technical Flow

```text
User
 |
 | Fiori Elements
 v
OData V4 UI Service
 |
 | ZUI_P2P_O4
 v
Service Definition
 |
 | ZUI_P2P
 v
Projection CDS
 |
 | ZC_P2P_REQUEST_P
 v
Projection Behavior
 |
 | use actions / CRUD / draft
 v
Interface CDS
 |
 | ZC_P2P_REQUEST
 v
RAP Behavior
 |
 | Determinations
 | Validations
 | Actions
 | Feature Control
 v
ZBP_C_P2P_REQUEST
 |
 v
Database
 |
 ├── ZP2P_REQUEST
 ├── ZP2P_REQUEST_D
 ├── ZP2P_REQ_ITEM
 └── ZP2P_REQ_ITEM_D
```

---

# 79. Consultant Perspective – Problem to Solution

## Business Problem

Purchase requests need a controlled and traceable process.

## Analysis

The process requires:

* A request header
* Multiple request items
* Automatic amount calculations
* Validation
* Draft handling
* Submission
* Approval/rejection
* Status-based controls

## Solution

A RAP-based Purchase Request Management application was designed.

## Data Model

A header-item composition was created:

```text
Purchase Request
       |
       +---- Request Item
       |
       +---- Request Item
       |
       +---- Request Item
```

## Business Logic

RAP determinations, validations and actions were used.

## User Interface

Fiori Elements was used to provide:

* List Report
* Object Page
* General Information
* Request Items
* Workflow actions

## Service

OData V4 UI service was created.

## Result

The organization receives a structured purchase request workflow with controlled data entry, automatic calculations, validation and approval processing.

---

# 80. Functional Result

The completed application provides the following functionality:

```text
✓ Purchase Request Creation
✓ Purchase Request Editing
✓ Purchase Request Deletion
✓ Multiple Request Items
✓ Draft Processing
✓ Item Total Calculation
✓ Request Total Calculation
✓ Total Amount Validation
✓ Required Date Validation
✓ Submit Workflow
✓ Approve Workflow
✓ Reject Workflow
✓ Status Management
✓ Dynamic Action Control
✓ Locking
✓ ETag
✓ Fiori Elements UI
✓ OData V4 Service
✓ Header-Item Navigation
✓ Request Item Object Page
```

---

# 81. Final Application Result

The final Fiori Elements application provides a Purchase Request management interface where users can see:

```text
Purchase Request
│
├── Request ID
├── Requester ID
├── Department
├── Category
├── Description
├── Total Amount
├── Currency
├── Required Date
├── Justification
├── Status
│
└── Request Items
      ├── Item Number
      ├── Material Description
      ├── Quantity
      ├── Unit
      ├── Unit Price
      ├── Item Total
      └── Currency
```

The application successfully demonstrates an end-to-end SAP ABAP Cloud RAP transactional scenario.

---

# 82. Project Outcome

The Purchase-to-Pay Request Management System demonstrates how a business requirement can be transformed into an SAP ABAP Cloud solution using RAP.

The project covers the complete development flow:

```text
Business Requirement
        ↓
Business Object Design
        ↓
Database Design
        ↓
CDS Data Model
        ↓
RAP Behavior
        ↓
Business Logic
        ↓
Validation
        ↓
Determination
        ↓
Workflow Actions
        ↓
Dynamic Feature Control
        ↓
Draft Processing
        ↓
OData V4 Service
        ↓
Fiori Elements UI
        ↓
Functional Testing
```

The resulting application provides a structured purchase request lifecycle from **Draft → Submitted → Approved/Rejected**, while enforcing business validations and automatic amount calculations.

---

# 83. Current Project Scope

The implemented scope covers:

* Purchase request management
* Purchase request items
* Draft processing
* Amount calculations
* Business validations
* Workflow actions
* Status-based action control
* Fiori Elements UI
* OData V4 exposure
* RAP transactional processing

The application is focused specifically on the **Purchase Request Management** portion of the broader Purchase-to-Pay process.

---

# 84. Conclusion

The SAP ABAP Cloud Purchase-to-Pay Request Management System provides a complete RAP-based transactional application for managing internal purchase requests.

The solution demonstrates the consultant approach of:

```text
Understand the Business Problem
          ↓
Define Business Requirements
          ↓
Design the Business Object
          ↓
Model the Data
          ↓
Implement Business Rules
          ↓
Implement Validations
          ↓
Implement Workflow
          ↓
Expose the Service
          ↓
Build the Fiori UI
          ↓
Test the Business Process
          ↓
Deliver the Solution
```

The project demonstrates practical use of **SAP ABAP Cloud, RAP, CDS, Draft, Determinations, Validations, Actions, Dynamic Feature Control, OData V4 and Fiori Elements** to build a business-oriented transactional application following the SAP Cloud development model.


