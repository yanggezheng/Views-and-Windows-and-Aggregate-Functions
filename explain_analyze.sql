-- TODO: use explain / analyze, create an index

drop index if exists athlete_event_name_idx;


select * from athlete_event
where name = 'Michael Fred Phelps, II';

EXPLAIN ANALYZE select * from athlete_event
where name = 'Michael Fred Phelps, II';

homework08=*# EXPLAIN ANALYZE SELECT * FROM athlete_event
                WHERE name = 'Michael Fred Phelps, II';
                                                          QUERY PLAN                                                           
-------------------------------------------------------------------------------------------------------------------------------
 Gather  (cost=1000.00..8218.46 rows=54 width=137) (actual time=33.328..38.646 rows=30 loops=1)
   Workers Planned: 2
   Workers Launched: 2
   ->  Parallel Seq Scan on athlete_event  (cost=0.00..7213.06 rows=22 width=137) (actual time=26.012..29.045 rows=10 loops=3)
         Filter: (name = 'Michael Fred Phelps, II'::text)
         Rows Removed by Filter: 90362
 Planning Time: 1.387 ms
 Execution Time: 38.739 ms
(8 rows)


homework08=*# EXPLAIN ANALYZE select * from athlete_event
where name = 'Michael Fred Phelps, II';
                                                           QUERY PLAN                                                            
---------------------------------------------------------------------------------------------------------------------------------
 Bitmap Heap Scan on athlete_event  (cost=4.84..205.89 rows=54 width=137) (actual time=0.611..0.615 rows=30 loops=1)
   Recheck Cond: (name = 'Michael Fred Phelps, II'::text)
   Heap Blocks: exact=2
   ->  Bitmap Index Scan on athlete_event_name_idx  (cost=0.00..4.83 rows=54 width=0) (actual time=0.604..0.604 rows=30 loops=1)
         Index Cond: (name = 'Michael Fred Phelps, II'::text)
 Planning Time: 1.014 ms
 Execution Time: 0.642 ms
(7 rows)

homework08=*# explain analyze SELECT * FROM athlete_event
WHERE name LIKE '%Phelps%' limit 10;
                                                     QUERY PLAN                                                     
--------------------------------------------------------------------------------------------------------------------
 Limit  (cost=0.00..1134.56 rows=10 width=137) (actual time=0.077..0.082 rows=10 loops=1)
   ->  Seq Scan on athlete_event  (cost=0.00..9189.95 rows=81 width=137) (actual time=0.074..0.077 rows=10 loops=1)
         Filter: (name ~~ '%Phelps%'::text)
         Rows Removed by Filter: 55
 Planning Time: 0.385 ms
 Execution Time: 0.122 ms
(6 rows)