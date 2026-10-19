INSERT INTO roles (role_name)
VALUES
    ('administrator'),
    ('inputer');

SELECT id, role_name
FROM roles
ORDER BY id;