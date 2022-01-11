-- Notice that 'drop' object would implicitly call 'commit'
-- So be careful to use this in a transaction
-- In most cases, we'd use this in housekeeping queries
  procedure drop_obj(objName VARCHAR2, objType VARCHAR2) is
    v_counter number;
  begin
    if (objType = 'TABLE') then
        select count(*) into v_counter from all_tables where table_name = upper(objName);
        if v_counter > 0 then
            DBMS_OUTPUT.PUT_LINE('TABLE ' || objName || ' ALREADY EXISTS. DROPPING TABLE.');
            execute immediate 'drop table ' || DEF_OWNER || '.'||  ObjName || ' cascade constraints';
        end if;
    elsif (objType = 'SEQUENCE') then
        select count(*) into v_counter from all_sequences where sequence_name = upper(ObjName);
        if v_counter > 0 then
            DBMS_OUTPUT.PUT_LINE('SEQUENCE ' || objName || ' ALREADY EXISTS. DROPPING SEQUENCE.');
            execute immediate 'DROP SEQUENCE ' || DEF_OWNER || '.'|| ObjName;
        end if;
    elsif (objType = 'TRIGGER') then
        select count(*) into v_counter from all_Triggers where TRIGGER_NAME = upper(ObjName);
        if v_counter > 0 then
            DBMS_OUTPUT.PUT_LINE('TRIGGER ' || objName || ' ALREADY EXISTS. DROPPING TRIGGER.');
            execute immediate 'DROP TRIGGER ' || DEF_OWNER || '.' || ObjName;
        end if;
    end if;
  end;
