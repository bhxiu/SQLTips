  procedure get_top_n_xxxxxx(   p_d1  Date,
                                p_d2  Date,
                                p_mode varchar2
                                ) is
    l_cde fee.cde%type;
    l_amnt NUMBER;

    l_sql       varchar2(1000);
    l_cursor_id integer;
    l_return    integer;

    l_outmsg    varchar2(110);

  begin

    -- l_sql to store dynamic query
    -- Say, if ... then l_sql := 'select ... from ...' else ...
    -- Hard coded here for demo only

    l_sql := '
        select * from
                (
                select f.cde, SUM(ck.paid_amnt) AS amnt
                  from  invoice ck,
                        fee f
                  where ck.fee_id = f.id
                  and ck.paid_date between :d1 and :d2
                  group by f.cde
                  order by amnt desc
                ) t
                where rownum <= :fn     
    ';

    l_cursor_id := dbms_sql.open_cursor;

    dbms_sql.parse(l_cursor_id, l_sql, dbms_sql.native);
    dbms_sql.bind_variable(l_cursor_id, ':d1', p_d1);
    dbms_sql.bind_variable(l_cursor_id, ':d2', p_d2);
    dbms_sql.bind_variable(l_cursor_id, ':fn', p_cnt);

    dbms_sql.define_column(l_cursor_id, 1, l_cde, 10);
    dbms_sql.define_column(l_cursor_id, 2, l_amnt);

    l_return := dbms_sql.execute(l_cursor_id);

    DBMS_OUTPUT.PUT_LINE('Search period: [' || TO_CHAR(p_d1, 'DD MON YYYY')
                         || '] to [' || TO_CHAR(p_d2, 'DD MON YYYY')
                         || ']');


    DBMS_OUTPUT.PUT_LINE('');
    dbms_output.put_line('-----------------------------------------------------------');

    loop
      if dbms_sql.fetch_rows(l_cursor_id) = 0 then
        exit;
      end if;
      dbms_sql.column_value(l_cursor_id, 1, l_cde);
      dbms_sql.column_value(l_cursor_id, 2, l_amnt);
      DBMS_OUTPUT.PUT_LINE( 'CDE: ' || l_cde || ', paid amount: ' || l_amnt);
    end loop;
    dbms_sql.close_cursor(l_cursor_id);

    dbms_output.put_line('-----------------------------------------------------------');
    dbms_output.put_line(' ');

  end;