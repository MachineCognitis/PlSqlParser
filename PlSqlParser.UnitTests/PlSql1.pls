-- Example of PL/SQL code
-- Package definition
CREATE OR REPLACE PACKAGE test_pkg AS
    PROCEDURE proc_example(p_input IN VARCHAR2, p_output OUT NUMBER);
    FUNCTION func_example(p_input IN NUMBER) RETURN VARCHAR2;
END test_pkg;
/

-- Package body
CREATE OR REPLACE PACKAGE BODY test_pkg AS

    -- Example of a simple procedure
    PROCEDURE proc_example(p_input IN VARCHAR2, p_output OUT NUMBER) IS
    BEGIN
        p_output := LENGTH(p_input);
    END proc_example;

    -- Example of a simple function
    FUNCTION func_example(p_input IN NUMBER) RETURN VARCHAR2 IS
        v_result VARCHAR2(100);
    BEGIN
        IF p_input > 10 THEN
            v_result := 'Greater than 10';
        ELSE
            v_result := '10 or less';
        END IF;
        RETURN v_result;
    END func_example;

END test_pkg;
/

-- Example of a trigger
CREATE OR REPLACE TRIGGER trg_example
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    :NEW.create_date := SYSDATE;
END trg_example;
/

-- Example of a cursor and loop
DECLARE
    CURSOR emp_cur IS
        SELECT employee_id, first_name, last_name FROM employees;
    v_emp emp_cur%ROWTYPE;
BEGIN
    OPEN emp_cur;
    LOOP
        FETCH emp_cur INTO v_emp;
        EXIT WHEN emp_cur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Employee: ' || v_emp.first_name || ' ' || v_emp.last_name);
    END LOOP;
    CLOSE emp_cur;
END;
/

-- Example of exception handling
BEGIN
    -- Attempt to divide by zero to trigger an exception
    DECLARE
        v_num NUMBER := 10;
        v_den NUMBER := 0;
        v_result NUMBER;
    BEGIN
        v_result := v_num / v_den;
    EXCEPTION
        WHEN ZERO_DIVIDE THEN
            DBMS_OUTPUT.PUT_LINE('Cannot divide by zero');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An unexpected error occurred: ' || SQLERRM);
    END;
END;
/

-- Example of a nested table type and bulk operations
DECLARE
    TYPE name_table IS TABLE OF VARCHAR2(100);
    v_names name_table := name_table();
BEGIN
    -- Populate the nested table
    v_names.EXTEND(3);
    v_names(1) := 'Alice';
    v_names(2) := 'Bob';
    v_names(3) := 'Charlie';

    -- Bulk insert using FORALL
    FORALL i IN v_names.FIRST .. v_names.LAST
        INSERT INTO employees (first_name) VALUES (v_names(i));

    -- Bulk collect
    DECLARE
        TYPE emp_table IS TABLE OF employees%ROWTYPE;
        v_emps emp_table;
    BEGIN
        SELECT * BULK COLLECT INTO v_emps FROM employees;
        FOR i IN v_emps.FIRST .. v_emps.LAST LOOP
            DBMS_OUTPUT.PUT_LINE('Employee: ' || v_emps(i).first_name);
        END LOOP;
    END;
END;
/