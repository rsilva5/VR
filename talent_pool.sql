-- Number 1: Examine the data from the employees table.
SELECT * 
FROM employees; 

-- Number 2: Examine the data in the projects table.
SELECT * 
FROM projects;

-- Number 3: What are the names of employees who have not chosen a project?
SELECT *
FROM employees
WHERE current_project IS NULL; 

SELECT COUNT(*)
FROM employees 
WHERE current_project IS NULL;

SELECT *
FROM employees
JOIN projects 
ON employees.current_project = projects.project_id;

SELECT COUNT(*)
FROM employees
JOIN projects 
ON employees.current_project = projects.project_id;

SELECT *
FROM employees
JOIN projects 
ON employees.current_project = projects.project_id
ORDER BY project_name ASC;

-- Number 4
SELECT project_name
FROM projects 
WHERE project_id NOT IN (
  SELECT current_project
  FROM employees
  WHERE current_project IS NOT NULL
);

-- Number 5
SELECT project_name
FROM projects
INNER JOIN employees
  ON projects.project_id = employees.current_project
WHERE current_project IS NOT NULL 
GROUP BY project_name
ORDER BY COUNT(employee_id) DESC
LIMIT 1;

-- Number 6 
SELECT project_name
FROM projects
INNER JOIN employees
  ON projects.project_id = employees.current_project
WHERE current_project IS NOT NULL 
GROUP BY project_name
HAVING COUNT(current_project) > 1;

-- Number 7
SELECT position, COUNT(position)
FROM employees
GROUP BY position
ORDER BY position DESC;

SELECT project_name
FROM projects 
WHERE project_id NOT IN (
  SELECT current_project
  FROM employees
  WHERE current_project IS NOT NULL
);

-- Number 7 Answer
SELECT (COUNT(*) * 2) - (
  SELECT COUNT(*)
  FROM employees
  WHERE current_project IS NOT NULL
    AND position = 'Developer') AS 'Count'
FROM projects;

-- Number 9: Which personality is the most common across our employees?
SELECT personality, COUNT(personality) AS 'total'
FROM employees
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;
-- The personality that is most common from employees is ENFJ

-- My number 10: What are the names of projects chosen by employees with the most common personality type?
SELECT project_name
FROM projects 
INNER JOIN employees
  ON projects.project_id = employees.current_project
WHERE current_project IS NOT NULL 
  AND employees.personality = "ENFJ"
;
-- The names of the project chosen by employees with the most common personality type are: RocketRush, BravoBoxing, and AlienInvasion


-- Number 11: Find the personality type most represented by employees with a selected project.
SELECT last_name, first_name, personality, project_name
FROM employees 
INNER JOIN projects 
  ON employees.current_project = projects.project_id
  WHERE personality = (
    SELECT personality 
    FROM employees
    WHERE current_project IS NOT NULL 
    GROUP BY personality
    ORDER BY COUNT(personality) DESC
    LIMIT 1);
-- The personality type most represented by employees with a selected project is ISTJ

-- Number 12: For each employee, provide their name, personality, the names of any projects they’ve chosen, and the number of incompatible co-workers.

SELECT last_name, first_name, personality, project_name,
CASE 
   WHEN personality = 'INFP' 
   THEN (SELECT COUNT(*)
      FROM employees 
      WHERE personality IN ('ISFP', 'ESFP', 'ISTP', 'ESTP', 'ISFJ', 'ESFJ', 'ISTJ', 'ESTJ'))
   WHEN personality = 'ISFP' 
   THEN (SELECT COUNT(*)
      FROM employees 
      WHERE personality IN ('INFP', 'ENTP', 'INFJ'))
   -- ... etc.
   ELSE 0
END AS 'IMCOMPATS'
FROM employees
LEFT JOIN projects on employees.current_project = projects.project_id;
