@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@EndUserText.label: 'P2P Purchase Request Projection'

@UI.headerInfo: {
  typeName: 'Purchase Request',
  typeNamePlural: 'Purchase Requests',
  title: {
    type: #STANDARD,
    value: 'request_id'
  },
  description: {
    type: #STANDARD,
    value: 'description'
  }
}


define root view entity ZC_P2P_REQUEST_P
  provider contract transactional_query
  as projection on ZC_P2P_REQUEST
{
  key request_uuid,

  @UI.lineItem: [{ position: 20 }]
  @UI.identification: [{ position: 20 }]
  @EndUserText.label: 'Request ID'
  request_id,

  @UI.lineItem: [{ position: 30 }]
  @UI.identification: [{ position: 30 }]
  @EndUserText.label: 'Requester ID'
  requester_id,

  @UI.lineItem: [{ position: 40 }]
  @UI.identification: [{ position: 40 }]
  @EndUserText.label: 'Department'
  department,

  @UI.lineItem: [{ position: 50 }]
  @UI.identification: [{ position: 50 }]
  @EndUserText.label: 'Category'
  category,

  @UI.lineItem: [{ position: 60 }]
  @UI.identification: [{ position: 60 }]
  @EndUserText.label: 'Description'
  description,

  @UI.lineItem: [{ position: 70 }]
  @UI.identification: [{ position: 70 }]
  @EndUserText.label: 'Total Amount'
  @Semantics.amount.currencyCode: 'currency'
  total_amount,

  @UI.lineItem: [{ position: 80 }]
  @UI.identification: [{ position: 80 }]
  @EndUserText.label: 'Currency'
  currency,

  @UI.lineItem: [{ position: 90 }]
  @UI.identification: [{ position: 90 }]
  @EndUserText.label: 'Required Date'
  required_date,

  @UI.identification: [{ position: 100 }]
  @EndUserText.label: 'Justification'
  justification,

  @UI.lineItem: [{ position: 100 }]
  @UI.identification: [{ position: 110 }]
  @EndUserText.label: 'Status'
  status,

  @UI.identification: [{ position: 120 }]
  @EndUserText.label: 'Created By'
  created_by,

  @UI.identification: [{ position: 130 }]
  @EndUserText.label: 'Created On'
  created_at,

  @UI.identification: [{ position: 140 }]
  @EndUserText.label: 'Changed By'
  last_changed_by,

  @UI.identification: [{ position: 150 }]
  @EndUserText.label: 'Changed On'
  last_changed_at,

  _Item : redirected to composition child ZC_P2P_REQ_ITEM_P
}
