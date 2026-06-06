
CREATE TABLE employees
    (id      INTEGER PRIMARY KEY,
    name    VARCHAR(50),
    salary  INTEGER,
    depart  INTEGER,
    surname VARCHAR(50));

INSERT INTO employees (id, name, salary, depart, surname) VALUES
(1, 'Дима',     5000,  4, 'Иванов'),
(2, 'Андрей',   15000, 5, 'Петров'),
(3, 'Анна',     2000,  3, 'Сидорова'),
(4, 'Вадим',    4000,  4, 'Зайцев'),
(5, 'Арсений',  45000, 5, 'Игнатьев'),
(6, 'Людмила',  3400,  4, 'Синицына'),
(7, 'Людмила',  5000,  3, 'Петрова');

-- -----------------------------------------------------------------------------
 1. Handle the division_by_zero exception
-- -----------------------------------------------------------------------------
DO $$
DECLARE
    v_numb1 INTEGER := 20;
    v_numb2 INTEGER := 0;
    v_res   INTEGER;
BEGIN 
    v_res := v_numb1 / v_numb2;
    RAISE NOTICE 'Результат деления равен %', v_res; 

EXCEPTION
    WHEN division_by_zero THEN 
        RAISE NOTICE 'На ноль делить нельзя!';
        v_res := NULL;
END;
$$;

-- -----------------------------------------------------------------------------
2. Handle the no_data_found exception (using STRICT)
-- -----------------------------------------------------------------------------
DO $$
DECLARE
    v_id   INTEGER := 9;
    v_name TEXT;
BEGIN 
    SELECT name INTO STRICT v_name FROM employees WHERE id = v_id;
    RAISE NOTICE 'Сотрудника с id % зовут %', v_id, v_name;

EXCEPTION 
    WHEN no_data_found THEN 
        RAISE NOTICE 'Сотрудник с id % не найден', v_id;
END;
$$;

-- -----------------------------------------------------------------------------
3. Handle the too_many_rows exception
-- -----------------------------------------------------------------------------
DO $$
DECLARE 
    v_search_name TEXT := 'Людмила';
    v_res_name    TEXT;
BEGIN
    SELECT name INTO STRICT v_res_name FROM employees WHERE name = v_search_name;
    RAISE NOTICE 'Найден сотрудник с именем %', v_res_name;

EXCEPTION
    WHEN too_many_rows THEN 
        RAISE NOTICE 'Найдено больше одного сотрудника c именем %!', v_search_name;
    WHEN no_data_found THEN 
        RAISE NOTICE 'Сотрудник % не найден в базе!', v_search_name;
END;
$$;

-- -----------------------------------------------------------------------------
4. Handle the invalid_text_representation exception (conversion error)
-- -----------------------------------------------------------------------------
DO $$
DECLARE 
    v_bad       VARCHAR(50) := '5oo';
    v_good_numb NUMERIC;
BEGIN 
    v_good_numb := v_bad::NUMERIC;
    RAISE NOTICE 'Число успешно преобразовано в %', v_good_numb;

EXCEPTION 
    WHEN invalid_text_representation THEN 
        RAISE NOTICE 'Выражение "%" невозможно преобразовать в число', v_bad;
END;
$$;

-- -----------------------------------------------------------------------------
5. Handle the unique_violation exception (duplicate primary key)
-- -----------------------------------------------------------------------------
DO $$
BEGIN 
    INSERT INTO employees (id, name, salary, depart, surname)
    VALUES (2, 'Марина', 4000, 2, 'Петрова');
    
    RAISE NOTICE 'Новый сотрудник успешно добавлен!'; 

EXCEPTION 
    WHEN unique_violation THEN 
        RAISE NOTICE 'Сотрудник с таким id уже есть!';
END;
$$;

-- -----------------------------------------------------------------------------
6. Handle the data_exception (value errors / string truncation)
-- -----------------------------------------------------------------------------
DO $$
DECLARE
    short_txt VARCHAR(3) := 'try';
BEGIN 
    short_txt := 'Белград';
    RAISE NOTICE 'Слово успешно записано';

EXCEPTION 
    WHEN data_exception THEN 
        RAISE NOTICE 'Ограничение по количеству символов!';
END;
$$;

-- -----------------------------------------------------------------------------
7. Handle the duplicate_cursor exception (already open cursor)
-- -----------------------------------------------------------------------------
DO $$
DECLARE 
    curs_name CURSOR FOR SELECT name FROM employees;
    v_name    TEXT;
BEGIN
    OPEN curs_name;
    OPEN curs_name;
    
    FETCH curs_name INTO v_name;
    RAISE NOTICE 'Сотрудника зовут %', v_name;
    
    CLOSE curs_name;

EXCEPTION 
    WHEN duplicate_cursor THEN
        RAISE NOTICE 'Такой курсор уже открыт!';
END;
$$;
