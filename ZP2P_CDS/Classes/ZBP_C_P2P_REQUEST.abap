CLASS lhc_zc_p2p_req_item DEFINITION
  INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS calculateItemTotal
      FOR DETERMINE ON MODIFY
      IMPORTING keys
      FOR ZC_P2P_REQ_ITEM~calculateItemTotal.

ENDCLASS.


CLASS lhc_zc_p2p_req_item IMPLEMENTATION.

  METHOD calculateItemTotal.

    READ ENTITIES OF zc_p2p_request IN LOCAL MODE
      ENTITY ZC_P2P_REQ_ITEM
        FIELDS ( quantity unit_price )
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_items).

    MODIFY ENTITIES OF zc_p2p_request IN LOCAL MODE
      ENTITY ZC_P2P_REQ_ITEM
        UPDATE FIELDS ( item_total )
        WITH VALUE #(
          FOR ls_item IN lt_items
          (
            %tky       = ls_item-%tky
            item_total = ls_item-quantity * ls_item-unit_price
          )
        ).

  ENDMETHOD.

ENDCLASS.


CLASS lhc_zc_p2p_request DEFINITION
  INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS get_instance_features
      FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR ZC_P2P_REQUEST
      RESULT result.

    METHODS approveRequest
      FOR MODIFY
      IMPORTING keys
      FOR ACTION ZC_P2P_REQUEST~approveRequest
      RESULT result.

    METHODS recalculateTotal
      FOR MODIFY
      IMPORTING keys
      FOR ACTION ZC_P2P_REQUEST~recalculateTotal
      RESULT result.

    METHODS rejectRequest
      FOR MODIFY
      IMPORTING keys
      FOR ACTION ZC_P2P_REQUEST~rejectRequest
      RESULT result.

    METHODS submitRequest
      FOR MODIFY
      IMPORTING keys
      FOR ACTION ZC_P2P_REQUEST~submitRequest
      RESULT result.

    METHODS setInitialStatus
      FOR DETERMINE ON MODIFY
      IMPORTING keys
      FOR ZC_P2P_REQUEST~setInitialStatus.


    METHODS validateTotalAmount
     FOR VALIDATE ON SAVE
     IMPORTING keys
     FOR ZC_P2P_REQUEST~validateTotalAmount.
    METHODS validateRequiredDate FOR VALIDATE ON SAVE
      keys FOR ZC_P2P_REQUEST~validateRequiredDate.


ENDCLASS.


CLASS lhc_zc_p2p_request IMPLEMENTATION.

  METHOD approveRequest.

  READ ENTITIES OF zc_p2p_request IN LOCAL MODE
    ENTITY ZC_P2P_REQUEST
      FIELDS ( status )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_requests).

  MODIFY ENTITIES OF zc_p2p_request IN LOCAL MODE
    ENTITY ZC_P2P_REQUEST
      UPDATE FIELDS ( status )
      WITH VALUE #(
        FOR ls_request IN lt_requests
        WHERE ( status = 'Submitted' )
        (
          %tky   = ls_request-%tky
          status = 'Approved'
        )
    ).

  READ ENTITIES OF zc_p2p_request IN LOCAL MODE
    ENTITY ZC_P2P_REQUEST
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_result).

  result = VALUE #(
    FOR ls_result IN lt_result
    (
      %tky   = ls_result-%tky
      %param = ls_result
    )
  ).

ENDMETHOD.


  METHOD recalculateTotal.

    READ ENTITIES OF zc_p2p_request IN LOCAL MODE
      ENTITY ZC_P2P_REQUEST
        FIELDS ( request_uuid )
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_requests).

    READ ENTITIES OF zc_p2p_request IN LOCAL MODE
      ENTITY ZC_P2P_REQUEST BY \_Item
        FIELDS ( request_uuid item_total )
        WITH CORRESPONDING #( lt_requests )
        RESULT DATA(lt_items).

    DATA lt_update TYPE TABLE FOR UPDATE zc_p2p_request.

    LOOP AT lt_requests INTO DATA(ls_request).

      DATA(lv_total) = CONV zc_p2p_request-total_amount( 0 ).

      LOOP AT lt_items INTO DATA(ls_item)
        WHERE request_uuid = ls_request-request_uuid.

        lv_total = lv_total + ls_item-item_total.

      ENDLOOP.

      APPEND VALUE #(
        %tky         = ls_request-%tky
        total_amount = lv_total
      ) TO lt_update.

    ENDLOOP.

    MODIFY ENTITIES OF zc_p2p_request IN LOCAL MODE
      ENTITY ZC_P2P_REQUEST
        UPDATE FIELDS ( total_amount )
        WITH lt_update.

    READ ENTITIES OF zc_p2p_request IN LOCAL MODE
      ENTITY ZC_P2P_REQUEST
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_result).

    result = VALUE #(
      FOR ls_result IN lt_result
      (
        %tky   = ls_result-%tky
        %param = ls_result
      )
    ).

  ENDMETHOD.


  METHOD rejectRequest.

  READ ENTITIES OF zc_p2p_request IN LOCAL MODE
    ENTITY ZC_P2P_REQUEST
      FIELDS ( status )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_requests).

  MODIFY ENTITIES OF zc_p2p_request IN LOCAL MODE
    ENTITY ZC_P2P_REQUEST
      UPDATE FIELDS ( status )
      WITH VALUE #(
        FOR ls_request IN lt_requests
        WHERE ( status = 'Submitted' )
        (
          %tky   = ls_request-%tky
          status = 'Rejected'
        )
    ).

  READ ENTITIES OF zc_p2p_request IN LOCAL MODE
    ENTITY ZC_P2P_REQUEST
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_result).

  result = VALUE #(
    FOR ls_result IN lt_result
    (
      %tky   = ls_result-%tky
      %param = ls_result
    )
  ).

ENDMETHOD.

  METHOD submitRequest.

   READ ENTITIES OF zc_p2p_request IN LOCAL MODE
    ENTITY ZC_P2P_REQUEST
      FIELDS ( status )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_requests).

   MODIFY ENTITIES OF zc_p2p_request IN LOCAL MODE
    ENTITY ZC_P2P_REQUEST
      UPDATE FIELDS ( status )
      WITH VALUE #(
        FOR ls_request IN lt_requests
        WHERE ( status = 'Draft' )
        (
          %tky   = ls_request-%tky
          status = 'Submitted'
        )
    ).

   READ ENTITIES OF zc_p2p_request IN LOCAL MODE
    ENTITY ZC_P2P_REQUEST
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_result).

   result = VALUE #(
    FOR ls_result IN lt_result
    (
      %tky   = ls_result-%tky
      %param = ls_result
    )
   ).

ENDMETHOD.


  METHOD setInitialStatus.

   MODIFY ENTITIES OF zc_p2p_request IN LOCAL MODE
     ENTITY ZC_P2P_REQUEST
      UPDATE FIELDS ( status )
      WITH VALUE #(
        FOR ls_key IN keys
        (
          %tky    = ls_key-%tky
          status  = 'Draft'
        )
     ).

  ENDMETHOD.

  METHOD validateTotalAmount.
    READ ENTITIES OF zc_p2p_request IN LOCAL MODE
     ENTITY ZC_P2P_REQUEST
      FIELDS ( total_amount )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_requests).
    LOOP AT lt_requests INTO DATA(ls_request).
     IF ls_request-total_amount <= 0.
      APPEND VALUE #(
        %tky = ls_request-%tky
      ) TO failed-zc_p2p_request.
      APPEND VALUE #(
        %tky = ls_request-%tky
        %msg = new_message(
          id       = 'ZP2P'
          number   = '001'
          severity = if_abap_behv_message=>severity-error
          v1       = 'Total amount must be greater than zero'
        )
      ) TO reported-zc_p2p_request.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validateRequiredDate.
   READ ENTITIES OF zc_p2p_request IN LOCAL MODE
    ENTITY ZC_P2P_REQUEST
      FIELDS ( required_date )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_requests).

   LOOP AT lt_requests INTO DATA(ls_request).

    IF ls_request-required_date < cl_abap_context_info=>get_system_date( ).

      APPEND VALUE #(
        %tky = ls_request-%tky
      ) TO failed-zc_p2p_request.

      APPEND VALUE #(
        %tky = ls_request-%tky
        %msg = new_message_with_text(
          severity = if_abap_behv_message=>severity-error
          text     = 'Required date cannot be in the past'
        )
      ) TO reported-zc_p2p_request.

    ENDIF.

   ENDLOOP.

  ENDMETHOD.

  METHOD get_instance_features.

   READ ENTITIES OF zc_p2p_request IN LOCAL MODE
    ENTITY ZC_P2P_REQUEST
      FIELDS ( status )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_requests).

   result = VALUE #(
    FOR ls_request IN lt_requests
    (
      %tky = ls_request-%tky

      %action-submitRequest = COND #(
        WHEN ls_request-status = 'Draft'
          THEN if_abap_behv=>fc-o-enabled
        ELSE if_abap_behv=>fc-o-disabled )

      %action-approveRequest = COND #(
        WHEN ls_request-status = 'Submitted'
          THEN if_abap_behv=>fc-o-enabled
        ELSE if_abap_behv=>fc-o-disabled )

      %action-rejectRequest = COND #(
        WHEN ls_request-status = 'Submitted'
          THEN if_abap_behv=>fc-o-enabled
        ELSE if_abap_behv=>fc-o-disabled )
    )
   ).

ENDMETHOD.

ENDCLASS.
