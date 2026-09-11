@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@EndUserText.label: 'P2P Request Item Projection'

@UI.headerInfo: {
  typeName: 'Request Item',
  typeNamePlural: 'Request Items',
  title: {
    type: #STANDARD,
    value: 'item_number'
  },
  description: {
    type: #STANDARD,
    value: 'material_desc'
  }
}

define view entity ZC_P2P_REQ_ITEM_P
  as projection on ZC_P2P_REQ_ITEM
{
  key item_uuid,

  request_uuid,

  @UI.lineItem: [{ position: 10 }]
  @UI.identification: [{ position: 10 }]
  item_number,

  @UI.lineItem: [{ position: 20 }]
  @UI.identification: [{ position: 20 }]
  material_desc,

  @UI.lineItem: [{ position: 30 }]
  @UI.identification: [{ position: 30 }]
  quantity,

  @UI.lineItem: [{ position: 40 }]
  @UI.identification: [{ position: 40 }]
  unit,

  @UI.lineItem: [{ position: 50 }]
  @UI.identification: [{ position: 50 }]
  @Semantics.amount.currencyCode: 'currency'
  unit_price,

  @UI.lineItem: [{ position: 60 }]
  @UI.identification: [{ position: 60 }]
  @Semantics.amount.currencyCode: 'currency'
  item_total,

  @UI.lineItem: [{ position: 70 }]
  @UI.identification: [{ position: 70 }]
  currency,

  created_by,
  created_at,
  last_changed_by,
  last_changed_at,

  _Request : redirected to parent ZC_P2P_REQUEST_P
}
