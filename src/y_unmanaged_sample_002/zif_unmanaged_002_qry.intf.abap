INTERFACE zif_unmanaged_002_qry
  PUBLIC .

    TYPES:
        tt_r_uuid  TYPE RANGE OF zunmanaged_002-uuid,
        tt_r_text TYPE RANGE OF zunmanaged_002-text,
        tt_r_date TYPE RANGE OF zunmanaged_002-cdate,

        ts_data   TYPE zunmanaged_002,
        tt_data   TYPE STANDARD TABLE OF ts_data WITH EMPTY KEY,

        gt_create TYPE tt_data,
        gt_update TYPE tt_data,
        gt_delete TYPE tt_data.

    METHODS:
        query
          IMPORTING it_r_uuid        TYPE tt_r_uuid  OPTIONAL
                    it_r_text        TYPE tt_r_text OPTIONAL
                    it_r_date        TYPE tt_r_date OPTIONAL
          RETURNING VALUE(rt_result) TYPE tt_data,

        read
          IMPORTING id_uuid          TYPE zunmanaged_002-uuid
          RETURNING VALUE(rs_result) TYPE ts_data,

        modify
          IMPORTING is_data          TYPE ts_data
          RETURNING VALUE(rd_result) TYPE abap_boolean,

        delete
          IMPORTING id_uuid          TYPE zunmanaged_002-uuid
          RETURNING VALUE(rd_result) TYPE abap_boolean.

ENDINTERFACE.
