USE clothing_shop;

SELECT
*
FROM 
Supplier;

-- 1 Вивести всю інформацію про товар Х.
SELECT * 
FROM Product 
WHERE product_id = 10;



-- 2 Вивести список клієнтів, які здійснювали покупки в магазині більше 3 разів.
SELECT c.customer_id, c.first_name, c.last_name, email 
FROM Customer c
JOIN Customer_Order co ON c.customer_id = co.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(co.customer_order_id) >= 3;


-- 3 Відобразити кількість проданих одиниць товару бренду Х у 2023 році. 
SELECT 
    Product.product_name,
    SUM(Customer_Order.product_amount) AS 'total_sold'
FROM 
    Customer_Order 
JOIN 
    Product ON Customer_Order.product_id = Product.product_id 
WHERE 
    Product.manufacture = 'Denim Delight' AND YEAR(Customer_Order.customer_order_datetime) = 2023
GROUP BY 
    Product.product_name;
    
    
-- 4 Вивести список замовлень зі статусом «Скасовано».
SELECT * FROM Customer_Order WHERE status = 'Cancelled';


-- 5 Перегляд усіх замовлень, зроблених клієнтами з певного міста.
SELECT co.*, city
FROM Customer_Order co
JOIN Customer c ON co.customer_id = c.customer_id
WHERE c.city = 'Kyiv';


-- 6 Вивести список клієнтів, в яких загальна сума одного замовлення або покупки в 2023 перевищує суму 3000 грн.
SELECT c.customer_id , c.first_name, c.last_name
FROM Customer c
JOIN Customer_Order co ON c.customer_id = co.customer_id
JOIN Product p ON co.product_id = p.product_id
WHERE YEAR(co.customer_order_datetime) = 2023
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING SUM(p.sale_price * co.product_amount) > 3000;


-- 7 Вивести ім'я та прізвище працівника, який обробив найбільшу кількість замовлень за останній місяць.
SELECT e.employee_id, e.first_name, e.last_name
FROM Employee e
JOIN Customer_Order co ON e.employee_id = co.employee_id
WHERE YEAR(co.customer_order_datetime) = YEAR(CURRENT_DATE - INTERVAL 1 MONTH)
AND MONTH(co.customer_order_datetime) = MONTH(CURRENT_DATE - INTERVAL 1 MONTH)
GROUP BY e.employee_id, e.first_name, e.last_name
ORDER BY COUNT(co.customer_order_id) DESC
LIMIT 1;


-- 8 Відобразити відсортований список за спаданням значення середньої вартості замовлень за останні 3 місяці для кожного клієнта.
SELECT 
    co.customer_id,
    c.first_name,
    c.last_name,
    AVG(co.product_amount * p.sale_price) AS average_order_value
FROM 
    Customer_Order co
JOIN 
    Product p ON co.product_id = p.product_id
JOIN
    Customer c ON co.customer_id = c.customer_id
WHERE 
    co.customer_order_datetime >= DATE_SUB(CURRENT_DATE, INTERVAL 3 MONTH)
GROUP BY 
    co.customer_id
ORDER BY 
    average_order_value DESC;
    
    
-- 9 Вивести відсоток скасованих замовлень від загальної кількості замовлень зі значеннями постачальників протягом останнього року.
SELECT 
    s.supplier_id, 
    s.company_name, 
    CONCAT(ROUND(SUM(CASE WHEN co.status = 'Cancelled' THEN 1 ELSE 0 END) / COUNT(*) * 100, 1), '%') AS cancellation_percentage
FROM 
    Customer_Order co
JOIN 
    Product p ON co.product_id = p.product_id
JOIN 
    Supplier s ON p.supplier_id = s.supplier_id
WHERE 
    co.customer_order_datetime >= DATE_SUB(CURRENT_DATE, INTERVAL 1 YEAR)
GROUP BY 
    s.supplier_id, s.company_name;
    
    
-- 10 Вивести список постачальників, з якими було укладено найбільшу кількість договорів за останні 5 років.
SELECT 
    supplier_id, 
    company_name, 
    COUNT(*) AS contract_count
FROM 
    Supplier
WHERE 
    contract_start_date >= DATE_SUB(CURRENT_DATE, INTERVAL 5 YEAR)
GROUP BY 
    supplier_id, company_name
ORDER BY 
    contract_count DESC;
    
    
-- 11 Вивести список працівників, які працюють більше року, із зазначенням їхніх посад і загального стажу роботи.
SELECT 
    employee_id,
    first_name,
    last_name,
    position,
    CONCAT(DATEDIFF(CURRENT_DATE, employment_date), ' days') AS total_work_experience
FROM 
    Employee
WHERE 
    DATEDIFF(CURRENT_DATE, employment_date) > 360;
    
    
-- 12 Переглянути список товарів з найбільшим прибутком (різниця між ціною продажу та закупівлі) за останній рік з вказанням постачальника.
SELECT 
    p.product_id,
    p.product_name,
    p.sale_price - p.purchase_price AS profit,
    s.company_name AS supplier
FROM 
    Product p
JOIN 
    Supplier s ON p.supplier_id = s.supplier_id
WHERE 
    p.product_id IN (
        SELECT 
            product_id
        FROM 
            Customer_Order
        WHERE 
            customer_order_datetime >= DATE_SUB(CURRENT_DATE, INTERVAL 1 YEAR)
    )
ORDER BY 
    profit DESC;


-- 13 Перегляд усіх постачальників, які мають активні договори з магазином, зі зазначенням терміну дії договорів та дати закінчення дії договору.
SELECT 
    company_name,
    contract_start_date,
    contract_end_date,
    DATEDIFF(contract_end_date, CURDATE()) AS days_until_contract_end
FROM 
    Supplier
WHERE 
    contract_end_date >= CURDATE()
ORDER BY 
    days_until_contract_end DESC;
    
    
-- 14 Перегляну товари, які мають найменшу кількість проданих одиниць протягом останніх 2 місяців, і знизити їм ціну на 15%. 
SELECT 
    p.product_id,
    p.product_name,
    p.sale_price,
    SUM(co.product_amount) AS total_sold
FROM 
    Product p
JOIN 
    Customer_Order co ON p.product_id = co.product_id
WHERE 
    co.customer_order_datetime >= DATE_SUB(CURDATE(), INTERVAL 2 MONTH)
GROUP BY 
    p.product_id,
    p.sale_price,
    p.product_name
ORDER BY 
    total_sold ASC
LIMIT 10;
    
    
UPDATE Product
SET sale_price = sale_price * 0.85
WHERE product_id IN (
    SELECT 
        product_id
    FROM 
        (
            SELECT 
                product_id,
                SUM(product_amount) AS total_amount
            FROM 
                Customer_Order
            WHERE 
                customer_order_datetime >= DATE_SUB(CURDATE(), INTERVAL 2 MONTH)
            GROUP BY 
                product_id
            ORDER BY 
                total_amount ASC
            LIMIT 5
        ) AS subquery
);
    
    
-- 15 
    --  1. Вибирає товари, які були продані протягом останніх 6 місяців.
--      2. Обчислює загальну кількість продажів і загальну виручку по кожному товару.
--      3. Фільтрує товари, що належать до категорії "Dresses".
--      4. Включає тільки ті товари, де кількість продажів перевищує 800.
--      5. Впорядковує результати за спаданням загальної виручки.
--      6. Виводить назву товару, загальну кількість продажів, загальну виручку, і ціну продажу.
     
SELECT
    p.product_name,
    SUM(co.product_amount) AS 'total_amount',
    SUM(co.product_amount * p.sale_price) AS 'total_revenue',
    AVG(p.sale_price) AS 'sale_price'
FROM
    Product p
JOIN
    Customer_Order co ON p.product_id = co.product_id
WHERE
    p.category = 'Dresses'
    AND co.customer_order_datetime >= DATE_SUB(CURDATE(), INTERVAL 10 MONTH)
GROUP BY
    p.product_id, p.product_name
HAVING
    SUM(co.product_amount * p.sale_price) > 800
ORDER BY
    SUM(co.product_amount * p.sale_price) DESC;



-- 16 Відобразити список товарів, які принесли найбільший дохід (більше 4000 грн.).
SELECT 
    p.product_id,
    p.product_name,
    SUM(co.product_amount * p.sale_price) AS total_revenue
FROM 
    Product p
JOIN 
    Customer_Order co ON p.product_id = co.product_id
GROUP BY 
    p.product_id,
    p.product_name
HAVING 
    total_revenue > 4000
ORDER BY 
    total_revenue DESC;
    
-- 17 
-- 1. Обчислює загальну кількість замовлень, оброблених кожним працівником за 12 місяців в проміжку між '2023-10-10 00:00:00' та '2024-10-10 00:00:00';
-- 2. Обчислює загальну виручку, отриману від цих замовлень;
-- 3. Виводить середню знижку, яку надавав кожен працівник у відсотках.
-- 4. Включає тільки тих працівників, які обробили більше 3 замовлень.
-- 5. Впорядковує результати за спаданням загальної виручки.
-- 6. Виводить ім'я працівника, кількість оброблених замовлень, загальну виручку, і середню знижку.

SELECT
    e.first_name ,
    e.last_name,
    COUNT(co.customer_order_id) AS 'order_amount',
    SUM(co.product_amount * p.sale_price * (1 - co.discount / 100)) AS 'total_revenue',
    CONCAT(ROUND(AVG(co.discount)), '%') AS 'average_discount'
FROM
    Employee e
JOIN
    Customer_Order co ON e.employee_id = co.employee_id
JOIN
    Product p ON co.product_id = p.product_id
WHERE
    co.customer_order_datetime BETWEEN '2023-10-10 00:00:00' AND '2024-10-10 00:00:00'
GROUP BY
    e.employee_id, e.first_name, e.last_name
HAVING
    COUNT(co.customer_order_id) > 3
ORDER BY
    `total_revenue` DESC;
    
    
INSERT INTO Supplier (supplier_id, company_name, phone_number, email, physical_address, contract_id, contract_start_date, contract_end_date)
VALUES (16, 'ABC Company', '380986627145','abc@gmail.com', '123 Pasichna St, Lviv, Ukraine', 100016,  '2024-05-23', '2026-05-03');   

SELECT
*
FROM 
Supplier;