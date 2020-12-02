USE AdventureWorks2017;

IF object_id('tempdb..#table_a', 'U') IS NOT NULL
	DROP TABLE #table_a

IF object_id('tempdb..#table_b', 'U') IS NOT NULL
	DROP TABLE #table_b

CREATE TABLE #table_a (id VARCHAR(5), seq_no INT);

CREATE TABLE #table_b (id VARCHAR(5), seq_no INT);

INSERT INTO #table_a
VALUES ('a', 1), ('a', 2), ('b', 1), ('b', 2), ('b', 3), ('c', 1), ('c', 2), ('c', 3), ('c', 4), ('c', 5), ('c', 6), ('c', 7), ('c', 8), ('d', 1), ('d', 2), ('d', 3), ('d', 4), ('d', 5)
INSERT INTO #table_b
VALUES ('a', 1), ('b', 1), ('b', 2), ('b', 3), ('c', 1), ('c', 2), ('c', 3), ('c', 4), ('c', 5), ('c', 6), ('c', 7)

--super convoluted method
SELECT a.id table_a_id, a.seq_no table_a_seq, b.id table_b_id, b.seq_no table_b_seq
FROM (
	--get id and sequence pair for table_a
	SELECT a.id, a.seq_no
	FROM #table_a a
	WHERE EXISTS (
			--select records where ids exist in both table_a and table_b
			SELECT 1
			FROM (
				SELECT id
				FROM (
					SELECT a.id
					FROM #table_a a
					JOIN #table_b b ON a.id = b.id
						AND a.seq_no = b.seq_no
					) x
				) x
			WHERE a.id = x.id
			)
	) a
FULL OUTER JOIN (
	--get id and sequence pair for table_b
	SELECT b.id, b.seq_no
	FROM #table_b b
	WHERE EXISTS (
			--select records where ids exist in both table_a and table_b
			SELECT 1
			FROM (
				SELECT id
				FROM (
					SELECT a.id
					FROM #table_a a
					JOIN #table_b b ON a.id = b.id
						AND a.seq_no = b.seq_no
					) x
				) x
			WHERE b.id = x.id
			)
	) b ON a.id = b.id
	AND a.seq_no = b.seq_no
WHERE b.id IS NULL;

--Simpler method found via reddit
select a.id as 'a_id',a.seq_no as 'a_seq_no',b.id as 'b_id',b.seq_no as 'b_seq_no'
from #table_a a
    left outer join #table_b b on a.id = b.id and a.seq_no = b.seq_no
where 
	b.id is null
	and exists (select 1 from #table_b where id = a.id);