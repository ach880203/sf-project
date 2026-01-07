use springdb;

DROP TABLE IF EXISTS tbl_ledger;

CREATE TABLE tbl_ledger (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,

  uid VARCHAR(50) NOT NULL, -- 로그인 사용자 식별 (AccountDTO.uid)

  type ENUM('INCOME', 'EXPENSE') NOT NULL,  -- 수입/지출
  amount INT NOT NULL,                      -- 금액(정수)
  category VARCHAR(30) NOT NULL,            -- 카테고리
  title VARCHAR(100) NOT NULL,              -- 거래명
  memo VARCHAR(500) NULL,                   -- 메모

  spent_at DATETIME NOT NULL,               -- 실제 거래 일시

  delflag TINYINT(1) NOT NULL DEFAULT 0,    -- 0=정상, 1=삭제

  regdate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updatedate DATETIME NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
select * from tbl_ledger;

-- 개인별 + 삭제 제외 + 날짜 정렬/검색 (가장 핵심 인덱스)
CREATE INDEX idx_ledger_uid_delflag_spentat
ON tbl_ledger(uid, delflag, spent_at);

-- 개인별로 타입/카테고리 필터 자주 하면 이렇게
CREATE INDEX idx_ledger_uid_type_category
ON tbl_ledger(uid, type, category);


DESC tbl_ledger;
SHOW INDEX FROM tbl_ledger;

-- 데이터 생성 확인
SELECT COUNT(*) as total_rows from tbl_ledger;
SELECT MIN(id) AS min_id, MAX(id) AS max_id FROM tbl_ledger;

SELECT uid, COUNT(*) AS cnt
FROM tbl_ledger
GROUP BY uid
ORDER BY uid
LIMIT 100;

SELECT * FROM tbl_ledger WHERE uid='user100' ORDER BY spent_at DESC;
SELECT COUNT(*) 
FROM tbl_ledger 
WHERE uid='user100' AND delflag=0;

-- 생성 데이터 삭제
TRUNCATE TABLE tbl_ledger; 

INSERT INTO tbl_ledger(uid, type, amount, category, title, memo, spent_at)
SELECT
  CONCAT('user', n.n) AS uid,
  IF(RAND() < 0.25, 'INCOME', 'EXPENSE') AS type,
  FLOOR(RAND() * 90000) + 1000 AS amount,
  ELT(FLOOR(RAND()*6)+1, 'FOOD','CAFE','TRANS','SHOP','SALARY','ETC') AS category,
  CONCAT(ELT(FLOOR(RAND()*6)+1, '식비','카페','교통','쇼핑','급여','기타'), ' - ', t.t, '번') AS title,
  CONCAT('seed-', n.n, '-', t.t) AS memo,
  DATE_ADD(DATE_SUB(NOW(), INTERVAL FLOOR(RAND()*365) DAY), INTERVAL FLOOR(RAND()*86400) SECOND) AS spent_at
FROM
(
  SELECT (a.d + b.d*10 + c.d*100 + d.d*1000) + 1 AS n
  FROM (SELECT 0 d UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
        UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) a
  CROSS JOIN (SELECT 0 d UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
        UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) b
  CROSS JOIN (SELECT 0 d UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
        UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) c
  CROSS JOIN (SELECT 0 d UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
        UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) d
) n
CROSS JOIN
(
  SELECT 1 AS t UNION ALL SELECT 2 UNION ALL SELECT 3
) t
WHERE n.n <= 10000;

select uid, delflag, count(*) cnt
from tbl_ledger
group by uid, delflag
order by cnt desc;

SELECT * FROM tbl_ledger ORDER BY bno DESC LIMIT 1000;





-- 지금 어떤 DB 보고있는지 (가끔 다른 스키마 보고 있기도 함)
SELECT DATABASE();

-- 전체 건수
SELECT COUNT(*) FROM tbl_ledger;

-- user100 건수
SELECT COUNT(*) FROM tbl_ledger WHERE uid = 'user100';

-- 삭제플래그까지 포함한 user100 유효 데이터
SELECT COUNT(*)
FROM tbl_ledger
WHERE uid='user100'
  AND (delflag = 0 OR delflag IS NULL);

-- 날짜까지 포함 (너 URL에 from/to가 들어가 있어서 이 조건이 실제로 적용되고 있음)
SELECT COUNT(*)
FROM tbl_ledger
WHERE uid='user100'
  AND (delflag = 0 OR delflag IS NULL)
  AND spent_at BETWEEN '2024-01-07 00:00:00' AND '2026-01-07 23:59:59';

-- 실제 row 20개 보기
SELECT id, uid, delflag, spent_at, type, amount, category, title
FROM tbl_ledger
WHERE uid='user100'
ORDER BY spent_at DESC, id DESC
LIMIT 20;

SELECT DATABASE() db, @@hostname host, @@port port, USER() user;

