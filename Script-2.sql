/*Добавь нового активного пользователя (укажи уникальный email, дату рождения можно указать или оставить null).
Сделай одного из существующих пользователей неактивным по email.
Измени full_name у одного пользователя по email.
Удали пользователя по email (выбери любого из вставленных, кроме того, кого добавил в п.1).
Посчитай общее количество пользователей.
Посчитай количество пользователей в разрезе is_active через group by.
Найди минимальный и максимальный created_at среди пользователей.
Посчитай количество пользователей с birth_date is null.
Проверь, что unique(email) работает: попробуй вставить пользователя с уже существующим email и зафиксируй ошибку (текст ошибки можно кратко).
Проверь, что not null работает: попробуй вставить пользователя с full_name = null и зафиксируй ошибку.*/


INSERT INTO customers  (full_name, email, birth_date, is_active, created_at)
VALUES ('Kolya', 'kolya@mail.ru', '2000-01-01', true, '2026-01-13 18:40:00');

update customers set is_active = false where id = 2;

update customers set full_name = 'KOLYA' where email = 'pavel.orlov@example.com';

delete customers where email = 'pavel.orlov@example.com';

select count(*) from customers c; 

select is_active, count(id) as usercount from customers c group by is_active;

select MIN(created_at) from customers c;

select MAX(created_at)  from customers;

select count(*) from customers c where birth_date is null;

INSERT INTO customers  (full_name, email, birth_date, is_active, created_at)
VALUES ('Kolya', 'kolya@mail.ru', '2000-01-01', true, '2026-01-13 18:40:00');

/*SQL Error [23505]: ERROR: duplicate key value violates unique constraint "customers_email_key"
  Подробности: Key (email)=(kolya@mail.ru) already exists.*/

INSERT INTO customers  (full_name, email, birth_date, is_active, created_at)
VALUES (null, 'kolya@mail.ru', '2000-01-01', true, '2026-01-13 18:40:00');

/*SQL Error [23502]: ERROR: null value in column "full_name" of relation "customers" violates not-null constraint
  Подробности: Failing row contains (9, null, kolya@mail.ru, 2000-01-01, t, 2026-01-13 18:40:00).*/

/*Добавь новый продукт с уникальным name, положительной price, stock_qty >= 0.
Увеличь stock_qty у продукта Coffee 250g на 10.
Сделай продукт Chocolate доступным (is_available = true) и поставь stock_qty = 15.
Удали продукт по имени (любой из списка, кроме Milk 1L).
Посчитай общее количество продуктов.
Посчитай количество продуктов в разрезе category через group by.
Посчитай среднюю цену по category через group by + avg(price).
Найди min(price) и max(price) среди всех продуктов.
Посчитай количество недоступных продуктов (is_available = false).
Проверь check(price > 0): попробуй вставить продукт с price = 0 и зафиксируй ошибку.
Проверь check(stock_qty >= 0): попробуй обновить любой продукт так, чтобы stock_qty = -1, и зафиксируй ошибку.
Проверь unique(name): попробуй вставить продукт с name = 'Milk 1L' и зафиксируй ошибку.*/

update products p set stock_qty = p.stock_qty + 10 where p."name" = 'Coffee 250g';

update products p set is_available = true, stock_qty = 15 where p."name" = 'Chocolate';

delete from products where name = 'Cheese';

select count(name) from products p;

select category, count(*) from products p group by p.category ;

select category, count(*) from products p group by p.category ;

select category, AVG(price) from products p group by category;

select MIN(price), MAX(price) from products p;

select count(*) from products p where is_available = false;

insert into products (name, category, price, stock_qty, is_available, created_at) values
('Milk 2L',        'dairy',   0, 120, true,  '2026-01-05 10:00:00');

/*SQL Error [23514]: ERROR: new row for relation "products" violates check constraint "products_price_check"
  Подробности: Failing row contains (7, Milk 2L, dairy, 0.00, 120, t, 2026-01-05 10:00:00).

Позиция ошибки:*/

update products p set stock_qty = -1 where p."name" = 'Chocolate';

/*SQL Error [23514]: ERROR: new row for relation "products" violates check constraint "products_stock_qty_check"
  Подробности: Failing row contains (6, Chocolate, grocery, 1.90, -1, t, 2026-01-08 09:00:00).*/

insert into products (name, category, price, stock_qty, is_available, created_at) values
('Milk 1L',        'dairy',   1.49, 120, true,  '2026-01-05 10:00:00');

/*SQL Error [23505]: ERROR: duplicate key value violates unique constraint "products_name_key"
  Подробности: Key (name)=(Milk 1L) already exists.*/

/*Добавь заказ для любого customer_email из таблицы customers со статусом new и суммой > 0.
Переведи все заказы со статусом new в статус paid.
Измени сумму (total_amount) у заказа с id = 1 на другое значение > 0.
Удали все заказы со статусом cancelled.
Посчитай общее количество заказов.
Посчитай количество заказов по статусам (status) через group by.
Посчитай количество заказов по customer_email через group by.
Найди avg(total_amount) по всем заказам.
Найди min(total_amount) и max(total_amount) по всем заказам.
Проверь check(status in ...): попробуй вставить заказ со статусом processing и зафиксируй ошибку.
Проверь check(total_amount > 0): попробуй обновить любой заказ, поставив total_amount = 0, и зафиксируй ошибку.
Посчитай количество заказов со статусом paid.*/

insert into orders (customer_email, status, total_amount, created_at) 
select email, 'new',  100, now() from customers limit 1 ;

update orders o set status = 'paid' where o.status = 'new';

update orders o set total_amount = 125.65 where o.id = 1;

delete from orders where status = 'cancelled';

select count(*) from orders;

select status, count(*) from orders o group by o.status;

select customer_email, count(*) from orders o group by o.customer_email;

select AVG(total_amount) from orders o;

select MIN(total_amount),max(total_amount)  from orders o;

insert into orders (customer_email, status, total_amount, created_at) values
('ivan.petrov@example.com',   'processing',       12.40, '2026-01-10 10:10:00');

/*SQL Error [23514]: ERROR: new row for relation "orders" violates check constraint "orders_status_check"
  Подробности: Failing row contains (7, ivan.petrov@example.com, processing, 12.40, 2026-01-10 10:10:00).*/

update orders o set total_amount = 0 where id = 1;

/*SQL Error [23514]: ERROR: new row for relation "orders" violates check constraint "orders_total_amount_check"
  Подробности: Failing row contains (1, ivan.petrov@example.com, paid, 0.00, 2026-01-10 10:10:00).*/

select count(*) from orders where status = 'paid';

/*Добавь платёж для существующего customer_email (из customers), метод из списка (card/cash/sbp), сумма > 0.
Измени метод оплаты у всех платежей конкретного клиента (выбери ivan.petrov@example.com) на sbp.
Измени сумму платежа с id = 1 на другое значение > 0.
Удали все платежи методом cash.
Посчитай общее количество платежей.
Посчитай количество платежей по method через group by.
Для каждого customer_email посчитай avg(amount), min(amount), max(amount) через group by.
Посчитай количество платежей по customer_email через group by.
Проверь check(method in ...): попробуй вставить платёж с методом crypto и зафиксируй ошибку.
Проверь check(amount > 0): попробуй вставить платёж с amount = -10 и зафиксируй ошибку.
Проверь not null: попробуй вставить платёж с paid_at = null и зафиксируй ошибку.
Посчитай min(paid_at) и max(paid_at) по всем платежам.*/

insert into payments (customer_email, method, amount, paid_at)
select email,'cash',2500,now() from customers c limit 1;

update payments p set method = 'sbp' where customer_email = 'ivan.petrov@example.com';

update payments p set amount = 100 where p.id = 1;

delete from payments where method = cash;

select count(*) from payments p ;

select method,count(*) from payments p group by "method" ;

select customer_email,avg(amount),min(amount), max(amount) from payments p group by customer_email;

select customer_email,count(*) from payments p group by customer_email;

insert into payments (customer_email, method, amount, paid_at) values
('maria.smirnova@example.com', 'crypto', 22.10, '2026-01-11 13:02:00');

/*SQL Error [23514]: ERROR: new row for relation "payments" violates check constraint "payments_method_check"
  Подробности: Failing row contains (7, maria.smirnova@example.com, crypto, 22.10, 2026-01-11 13:02:00).*/

insert into payments (customer_email, method, amount, paid_at) values
('maria.smirnova@example.com', 'crypto', -10, '2026-01-11 13:02:00');

/*SQL Error [23514]: ERROR: new row for relation "payments" violates check constraint "payments_amount_check"
  Подробности: Failing row contains (8, maria.smirnova@example.com, crypto, -10.00, 2026-01-11 13:02:00).*/

insert into payments (customer_email, method, amount, paid_at) values
('maria.smirnova@example.com', 'crypto', -10, null);

/*SQL Error [23502]: ERROR: null value in column "paid_at" of relation "payments" violates not-null constraint
  Подробности: Failing row contains (9, maria.smirnova@example.com, crypto, -10.00, null).*/


select min(paid_at), max(paid_at) from payments p;








































