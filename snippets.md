# snippets

## sql

### combining ≥ 2 type-2 history models

```sql
with a as (
  select 1 as user_id, '123 Main St' as address, cast('2022-01-01' as date) as from_ts, cast('2023-01-01' as date) as to_ts
  union all
  select 1, '456 Elm St', cast('2023-01-01' as date), cast('2023-06-15' as date)
  union all
  select 1, '789 Oak Ave', cast('2023-06-15' as date), cast('2099-12-31' as date)
),

p as (
  select 1 as user_id, '555-111-2222' as phone, cast('2022-01-01' as date) as from_ts, cast('2023-05-01' as date) as to_ts
  union all
  select 1, '555-555-6666', cast('2023-05-01' as date), cast('2099-12-31' as date)
),

e as (
  select 1 as user_id, 'user1@example.com' as mail, cast('2023-02-01' as date) as from_ts, cast('2099-12-31' as date) as to_ts
  union all
  select 2 as user_id, 'user2@example.com' as mail, cast('2024-02-01' as date) as from_ts, cast('2099-12-31' as date) as to_ts
),

ts as (select from_ts, user_id from a union select from_ts, user_id from p union select from_ts, user_id from e),

ts_lead as (
  select
    user_id,
    from_ts,
    coalesce(lead(from_ts) over (partition by user_id order by from_ts), '9999-12-31') as to_ts,
    to_ts = '9999-12-31' as is_current,
    row_number() over (partition by user_id order by from_ts) as row_version
  from ts
),

  scd as (

select a.address, p.phone, e.mail, ts_lead.* from ts_lead
left join a on a.from_ts <= ts_lead.from_ts and ts_lead.from_ts < a.to_ts and a.user_id = ts_lead.user_id
left join p on p.from_ts <= ts_lead.from_ts and ts_lead.from_ts < p.to_ts and p.user_id = ts_lead.user_id
left join e on e.from_ts <= ts_lead.from_ts and ts_lead.from_ts < e.to_ts and e.user_id = ts_lead.user_id
)

select * from scd
--probably requires indexes on from_ts and user_id in upstream models to be performant. 
--requires inputs to be unique on id x timestamp grain. could be done with good old row_number()
--forget about incremental loads lol
```
