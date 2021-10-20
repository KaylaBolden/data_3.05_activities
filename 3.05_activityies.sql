-- 3.05.1

-- Find out the average number of transactions by account. 
-- 		Get those accounts that have more transactions than the average.

drop table if exists bank.accTrans;
create temporary table accTrans
select account_id, count(*) as transCount
from bank.trans
group by account_id;

select * from accTrans
where transCount > 
(select avg(transCount) from accTrans
);

select account_id from accTrans
where transCount > 
(select avg(transCount) from (select account_id, count(*) as transCount
from bank.trans
group by account_id)sub1
);

-- 3.05.2

-- 1. Get a list of accounts from Central Bohemia using a subquery.
select distinct account_id from 
bank.disp d
join bank.client c using (client_id)
where c.district_id in (
select a1 from bank.district where a3 = "Central Bohemia");

-- 2. Rewrite the previous as a join query.
select distinct d.account_id 
from bank.disp d 
join bank.client c using (client_id)
join bank.district dt on c.district_id = dt.A1
where a3 = "Central Bohemia";

-- 3. Discuss which method will be more efficient.

-- 3.05.3
-- 1.Find the most active customer for each district in Central Bohemia.
select * from (
select  a2 as district,d.client_id, transCount
,rank () over(partition by a2 order by transCount desc) as customerActivity
from accTrans t
join bank.account a using (account_id)
join bank.disp d using (account_id)
join bank.district ds on a.district_id=ds.a1
where a3 = "Central Bohemia")sub1
where customerActivity=1;