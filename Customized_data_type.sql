/*

Version 1
This works in Oracle 19.0

*/

DECLARE
    TYPE T_RECTYPE IS RECORD(
        ID   NUMBER,
        NAME VARCHAR2(150));
    TYPE T_RECTAB IS TABLE OF T_RECTYPE;

    V_RECS T_RECTAB DEFAULT T_RECTAB(T_RECTYPE(1, 'one'),
                                     T_RECTYPE(2, 'two'));

BEGIN

    FOR IDX IN 1 .. V_RECS.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE(V_RECS(IDX).ID || ' -> ' || V_RECS(IDX).NAME);
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
        DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_STACK);
        DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
END;


/*

Version 2

Version 1 does not work in Oracle 11.0. We would have
to initialize with functions.

*/

DECLARE
    TYPE T_RECTYPE IS RECORD(
        ID   NUMBER,
        NAME VARCHAR2(150));
    TYPE T_RECTAB IS TABLE OF T_RECTYPE;
    V_RECS T_RECTAB;


    FUNCTION INIT_REC(ID NUMBER, NAME VARCHAR2) RETURN T_RECTYPE IS
        L_REC T_RECTYPE;
    BEGIN
        L_REC.ID   := ID;
        L_REC.NAME := NAME;
        RETURN L_REC;
    END;

    FUNCTION INIT_TAB RETURN T_RECTAB IS
        L_TAB T_RECTAB;
    BEGIN
        L_TAB := T_RECTAB(INIT_REC(1, 'one'),
                          INIT_REC(2, 'two'));
        RETURN L_TAB;
    END;

BEGIN
    V_RECS := INIT_TAB;

    FOR IDX IN 1 .. V_RECS.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE(V_RECS(IDX).ID || ' -> ' || V_RECS(IDX).NAME);
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
        DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_STACK);
        DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
END;
