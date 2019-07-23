-- Query 1
select distinct
s.subregion_name as "subregion",
d.num_day as "num_day",
p.isbn as "ISBN",
p.title as "title",
sum(t.sell_by_product) as
"total_sales"
from
olap_bookshop.subregion s,
olap_bookshop.day d,
olap_bookshop.books p,
olap_bookshop.facts_ticket t,
olap_bookshop.warehouse
where
t.warehouse_code = warehouse.code
and
warehouse.subregion_id =
s.subregion_id and
t.day_id = d.day_id and
t.books_isbn = p.isbn
group by
s.subregion_name,
d.num_day,
p.isbn
order by num_day asc;

-- Query 2
select distinct
an.year as "year",
p.isbn as "isbn",
p.title as "title",
sum(t.sell_by_product) as
"total_sales"
from
olap_bookshop.year an,
olap_bookshop.books p,
olap_bookshop.facts_ticket t
where
t.books_isbn= p.isbn
group by
an.year,
p.isbn
order by
p.isbn asc;

-- Query 3

with ventas_month as ( select
r.region_name,
count(f.ticket_number) as count
from
olap_bookshop.region r,
olap_bookshop.facts_ticket f,
olap_bookshop.day d,
olap_bookshop.month m,
olap_bookshop.warehouse t,
olap_bookshop.subregion s
where
m.month = 'october' and
f.day_id = d.day_id and
d.month_id=m.month_id and
f.warehouse_code = t.code and
t.subregion_id = s.subregion_id and
s.region_id = r.region_id
group by r.region_name)
select region_name, max(count)
from
ventas_month
group by region_name;

-- Query 4

select
r.region_name,
m.month,
avg(f.sell_by_product)
from
olap_bookshop.region r,
olap_bookshop.facts_ticket f,
olap_bookshop.day d,
olap_bookshop.month m,
olap_bookshop.warehouse t,
olap_bookshop.subregion s
where
f.day_id = d.day_id and
d.month_id=m.month_id and
f.warehouse_code= t.code and
t.subregion_id = s.subregion_id and
s.region_id = r.region_id
group by
r.region_name,
m.month
order by
r.region_name;


-- Query 5

with prod1 as (
select
f.ticket_number,
p.title
from
olap_bookshop.books p,
olap_bookshop.facts_ticket f
where
p.isbn = f.books_isbn
group by f.ticket_number, p.title
)
select prod1.title, pr.title
from olap_bookshop.books pr,
olap_bookshop.facts_ticket t, prod1
where t.ticket_number =
prod1.ticket_number