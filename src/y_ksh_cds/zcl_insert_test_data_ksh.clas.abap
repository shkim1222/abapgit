CLASS zcl_insert_test_data_ksh DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_INSERT_TEST_DATA_KSH IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA: ls_data_m TYPE ztest_master_ksh.
    DATA: ls_data_i1 TYPE ztest_item1_ksh.
    DATA: ls_data_i2 TYPE ztest_item2_ksh.

    DELETE FROM ztest_master_ksh.
    DELETE FROM ztest_item1_ksh.
    DELETE FROM ztest_item2_ksh.

    ls_data_m-client = '080'.
    ls_data_m-tkey = '1000'.
    ls_data_m-total_name = '철수'.
    ls_data_m-total_amount = '1000'.
    ls_data_m-total_cuky = 'USD'.
    INSERT ztest_master_ksh FROM @ls_data_m.

    ls_data_m-client = '080'.
    ls_data_m-tkey = '2000'.
    ls_data_m-total_name = '영수'.
    ls_data_m-total_amount = '1000'.
    ls_data_m-total_cuky = 'USD'.
    INSERT ztest_master_ksh FROM @ls_data_m.

    ls_data_i1-client = '080'.
    ls_data_i1-tkey = '1000'.
    ls_data_i1-name1 = '과자'.
    ls_data_i1-amount1 = '1000'.
    ls_data_i1-cuky1 = 'USD'.
    INSERT ztest_item1_ksh FROM @ls_data_i1.

    ls_data_i1-client = '080'.
    ls_data_i1-tkey = '1000'.
    ls_data_i1-name1 = '사탕'.
    ls_data_i1-amount1 = '1000'.
    ls_data_i1-cuky1 = 'USD'.
    INSERT ztest_item1_ksh FROM @ls_data_i1.

    ls_data_i1-client = '080'.
    ls_data_i1-tkey = '1000'.
    ls_data_i1-name1 = '음료'.
    ls_data_i1-amount1 = '1000'.
    ls_data_i1-cuky1 = 'USD'.
    INSERT ztest_item1_ksh FROM @ls_data_i1.

    ls_data_i2-client = '080'.
    ls_data_i2-tkey = '2000'.
    ls_data_i2-name2 = '라면'.
    ls_data_i2-amount2 = '1000'.
    ls_data_i2-cuky2 = 'USD'.
    INSERT ztest_item2_ksh FROM @ls_data_i2.

  ENDMETHOD.
ENDCLASS.
