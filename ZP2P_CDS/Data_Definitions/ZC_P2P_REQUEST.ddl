@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'P2P Purchase Request Root CDS'
@Metadata.ignorePropagatedAnnotations: true

define root view entity ZC_P2P_REQUEST
  as select from zp2p_request

  composition [0..*] of ZC_P2P_REQ_ITEM as _Item
{
  key request_uuid,

      request_id,
      requester_id,
      department,
      category,
      description,

      @Semantics.amount.currencyCode: 'currency'
      total_amount,
      currency,

      required_date,
      justification,
      status,

      created_by,
      created_at,
      last_changed_by,
      last_changed_at,

      _Item
}
