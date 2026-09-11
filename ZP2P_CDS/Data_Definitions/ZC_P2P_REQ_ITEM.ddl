@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'P2P Purchase Request Item CDS'
@Metadata.ignorePropagatedAnnotations: true

define view entity ZC_P2P_REQ_ITEM
  as select from zp2p_req_item

  association to parent ZC_P2P_REQUEST as _Request
    on $projection.request_uuid = _Request.request_uuid
{
  key item_uuid,

      request_uuid,
      item_number,

      material_desc,
      quantity,
      unit,

      @Semantics.amount.currencyCode: 'currency'
      unit_price,

      @Semantics.amount.currencyCode: 'currency'
      item_total,

      currency,

      created_by,
      created_at,
      last_changed_by,
      last_changed_at,

      _Request
}
