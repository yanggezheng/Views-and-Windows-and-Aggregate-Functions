-- TODO: write the task number and description followed by the query
1. Write a View

create view standing as (select
                    medal,
                    year,
                    height,
                event,
                coalesce(
                noc_region.region,
                case athlete_event.noc
                    when 'SGP' then 'Singapore'
                    when 'ROT' then 'Refugee'
                    when 'TUV' then 'Tuvalu'
                    when 'UNK' then 'Unknown'
                    else athlete_event.team
                    end
            ) as region
    from athlete_event
             full outer join noc_region on athlete_event.noc = noc_region.noc);

2. Use the Window Function, rank()

select * from
    (select
    region,
    event,
    count(*) as gold_medals,
    rank() over (partition by event order by count(*) desc) as rank
from standing
where medal = 'Gold' and event like '%Fencing%'
group by region, event
order by event, rank) as sub where rank <= 3;

3. Using Aggregate Functions as Window Functions

select region, year, medal, count(*) as c,
       sum(count(*)) over (partition by region, medal order by year) as sum
from standing
where medal is not null
group by region, year, medal
order by region, year, medal;

4. Use the Window Function, lag()

select
    event,
    year,
    height,
    lag(height) over (partition by event order by year) as previous_height
from
    standing
where
        event like '%Pole Vault' and medal = 'Gold' and height is not null
order by
    event,
    year;