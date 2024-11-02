-- Package definition
CREATE OR REPLACE PACKAGE employee_pkg AS
    PROCEDURE process_employees;
    FUNCTION get_department_name(p_dept_id IN NUMBER) RETURN VARCHAR2;
END employee_pkg;
/

-- Package body
CREATE OR REPLACE PACKAGE BODY employee_pkg AS

    -- Procedure to process employee data
    PROCEDURE process_employees IS
        CURSOR emp_cur IS
            SELECT employee_id, first_name, last_name, department_id
            FROM employees
            WHERE status = 'ACTIVE';
        
        CURSOR dept_cur IS
            SELECT department_id, department_name
            FROM departments;
        
        v_emp_record employees%ROWTYPE;
        v_dept_record departments%ROWTYPE;
        v_dept_name VARCHAR2(100);
    BEGIN
        OPEN emp_cur;
        LOOP
            FETCH emp_cur INTO v_emp_record;
            EXIT WHEN emp_cur%NOTFOUND;

            -- Retrieve department name using function
            v_dept_name := get_department_name(v_emp_record.department_id);

            DBMS_OUTPUT.PUT_LINE('Employee: ' || v_emp_record.first_name || ' ' || v_emp_record.last_name || 
                                 ' works in ' || v_dept_name);
        END LOOP;
        CLOSE emp_cur;
        
        OPEN dept_cur;
        LOOP
            FETCH dept_cur INTO v_dept_record;
            EXIT WHEN dept_cur%NOTFOUND;
            
            DBMS_OUTPUT.PUT_LINE('Department: ' || v_dept_record.department_name);
        END LOOP;
        CLOSE dept_cur;
    END process_employees;

    -- Function to get department name
    FUNCTION get_department_name(p_dept_id IN NUMBER) RETURN VARCHAR2 IS
        v_dept_name VARCHAR2(100);
    BEGIN
        SELECT department_name
        INTO v_dept_name
        FROM departments
        WHERE department_id = p_dept_id;
        RETURN v_dept_name;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 'Unknown Department';
    END get_department_name;

END employee_pkg;
/

-- Anonymous block to execute the package procedure
BEGIN
    employee_pkg.process_employees;
END;
/

-- Example of handling employee bonuses
DECLARE
    CURSOR bonus_cur IS
        SELECT employee_id, salary
        FROM employees
        WHERE status = 'ACTIVE';
    
    v_emp_id employees.employee_id%TYPE;
    v_salary employees.salary%TYPE;
    v_bonus employees.bonus%TYPE;
BEGIN
    OPEN bonus_cur;
    LOOP
        FETCH bonus_cur INTO v_emp_id, v_salary;
        EXIT WHEN bonus_cur%NOTFOUND;
        
        -- Calculate bonus based on salary
        IF v_salary > 5000 THEN
            v_bonus := v_salary * 0.10;
        ELSE
            v_bonus := v_salary * 0.05;
        END IF;
        
        -- Update employee record with bonus
        UPDATE employees
        SET bonus = v_bonus
        WHERE employee_id = v_emp_id;
        
        DBMS_OUTPUT.PUT_LINE('Employee ID: ' || v_emp_id || ' receives bonus of ' || v_bonus);
    END LOOP;
    CLOSE bonus_cur;
    
    COMMIT;
END;
/
