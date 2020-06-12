
# JUST PLAY

# SELECT title FROM titles
# LIMIT 5;


# CHECKING CORRECT NUMBER OF DEPARTMENTS AND DETERMINING THEIR NAMES

# SELECT dept_name FROM departments;


# CHECKING COUNT OF EMPLOYEES

# SELECT COUNT(*) FROM employees;


# FIND ALL MANAGERS
# ====WORKED=====

SELECT employees.emp_no, first_name, last_name, title
FROM employees
INNER JOIN titles
  ON employees.emp_no = titles.emp_no
WHERE title = "Manager";

# FIND ALL CURRENT MANAGERS WITH THEIR SALARIES
# =======WORKED=======

SELECT employees.emp_no, first_name, last_name, title, salary, salaries.from_date, salaries.to_date
FROM employees
INNER JOIN titles
  ON employees.emp_no = titles.emp_no
INNER JOIN salaries
  ON employees.emp_no =  salaries.emp_no
WHERE title = "Manager"
  # AND salaries.to_date = "9999-01-01";  -----HARD-CODED GIVES SAME RESULT
   AND salaries.to_date = (SELECT MAX(salaries.to_date) FROM salaries);


# HOW MANY DIFFERENT TITLES ARE THERE IN THE COMPANY
# =======WORKED======

SELECT title FROM titles
GROUP BY title;


# WHO IS THE MANAGER OF EACH DEPARTMENT
# =======WORKED????======

SELECT departments.dept_name, employees.last_name FROM dept_manager
INNER JOIN employees
  ON employees.emp_no = dept_manager.emp_no
INNER JOIN departments
  ON dept_manager.dept_no = departments.dept_no
WHERE to_date = (SELECT MAX(to_date) FROM dept_manager);


# FIND THE SALARY OF MANAGERS OF EACH DEPARTMENT
# =======WORKED???=======

SELECT departments.dept_name AS Department, titles.title AS Title, employees.last_name AS "Last Name", salaries.salary AS Salary, dept_manager.to_date
FROM dept_manager
INNER JOIN employees
  ON employees.emp_no = dept_manager.emp_no
INNER JOIN departments
  ON dept_manager.dept_no = departments.dept_no
INNER JOIN salaries
  ON salaries.emp_no = employees.emp_no
INNER JOIN titles
  ON titles.emp_no = employees.emp_no
WHERE dept_manager.to_date = (SELECT MAX(to_date) FROM dept_manager)
GROUP BY employees.last_name;


# HOW MANY DEPARTMENT MANAGERS ARE THERE?
# =====WORKED========

SELECT COUNT(*) FROM dept_manager
WHERE to_date = (SELECT MAX(to_date) FROM dept_manager);


# HOW MANY EMPLOYEES ARE IN EACH DEPARTMENT
# =======WORKED======

SELECT dept_name, COUNT(*) FROM departments
INNER JOIN dept_emp
  ON departments.dept_no = dept_emp.dept_no
# INNER JOIN employees
#   ON employees.emp_no = dept_emp.emp_no
WHERE dept_emp.to_date = (SELECT MAX(to_date) FROM dept_emp)
# WHERE dept_emp.to_date = "9999-01-01"  ------HARD-CODED GIVES SAME RESULTS
GROUP BY departments.dept_name;

# # =====CHECK AGAIN========
SELECT dept_name, COUNT(*) FROM departments
INNER JOIN dept_emp
  ON departments.dept_no = dept_emp.dept_no
# INNER JOIN employees
#   ON employees.emp_no = dept_emp.emp_no
WHERE dept_emp.to_date = (SELECT MAX(to_date) FROM dept_emp)
# WHERE dept_emp.to_date = "9999-01-01"  ------HARD-CODED GIVES SAME RESULTS
GROUP BY departments.dept_name
WITH ROLLUP;

# # ======TRIPLE CHECK======
SELECT COUNT(*) FROM dept_emp 
WHERE to_date = (SELECT MAX(to_date) FROM dept_emp);


# HOW CAN THERE BY 24 MANAGERS BUT ONLY 9 DEPARTMENTS WHERE ONLY 9 MANAGERS APPEAR???
# =================LET'S TRY AGAIN=====================

SELECT employees.emp_no, first_name, last_name, dept_name, title, salary, salaries.from_date, salaries.to_date
FROM employees
INNER JOIN titles
  ON employees.emp_no = titles.emp_no
INNER JOIN dept_manager
  ON dept_manager.emp_no = employees.emp_no
INNER JOIN departments
  ON departments.dept_no = dept_manager.dept_no
INNER JOIN salaries
  ON employees.emp_no =  salaries.emp_no
WHERE title = "Manager"
#   # AND salaries.to_date = "9999-01-01";  -----HARD-CODED GIVES SAME RESULT
   AND salaries.to_date = (SELECT MAX(salaries.to_date) FROM salaries);
