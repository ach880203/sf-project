use springdb;

CREATE TABLE tbl_community (
  bno BIGINT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(500) NOT NULL,
  content VARCHAR(2000) NOT NULL,
  writer VARCHAR(50) NOT NULL,

  regdate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updatedate TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  delflag BOOLEAN DEFAULT FALSE
);

select * from tbl_community;

-- (선택) 기존 데이터 비우고 새로 채우기
-- TRUNCATE TABLE tbl_community;

-- 0~9 숫자 테이블(파생) 정의를 여러 번 쓰기 위해 반복해서 씀
SET @row := 0;

INSERT INTO tbl_community (title, content, writer, regdate, updatedate, delflag)
SELECT
  CONCAT(
    '[머니플랜 #', LPAD(seq.n, 5, '0'), '] ',
    ELT(1 + MOD(seq.n, 12),
      '월급 관리 루틴',
      '저축 자동화 전략',
      '가계부로 새는 돈 막기',
      '고정비 다이어트',
      '변동비 예산 잡는 법',
      '부수입 만들기 아이디어',
      '연봉 협상 체크리스트',
      '투자 전 점검 리스트',
      '카드/현금 흐름 정리',
      '비상금 만드는 방법',
      '소비습관 리셋',
      '돈 버는 시간관리'
    ),
    ' - ',
    ELT(1 + MOD(seq.n, 6), '초보용', '실전용', '핵심정리', '오늘부터', '한달플랜', '체크리스트')
  ) AS title,

  CONCAT(
    '핵심 요약: ', ELT(1 + MOD(seq.n, 5), '흐름을 먼저 잡고', '고정비를 깎고', '저축을 자동화하고', '수입을 늘리고', '꾸준히 기록하자'), '\n\n',
    '1) 예산: 수입의 ', FLOOR(10 + RAND(seq.n) * 30), '%는 저축/투자, ',
                 FLOOR(30 + RAND(seq.n + 1) * 40), '%는 생활비로 설정.\n',
    '2) 지출: 카드 사용 내역을 주 1회 정리(카테고리: 식비/교통/쇼핑/구독).\n',
    '3) 수입: 부수입은 “작게 시작 → 반복 → 확장”이 정답. 이번 주 목표 1개만.\n',
    '4) 점검: 한 달에 한 번, 고정비(구독/통신/보험/대출)를 재검토.\n\n',
    '오늘의 미션: ',
    ELT(1 + MOD(seq.n, 8),
      '구독 1개 해지/다운그레이드',
      '주간 식비 상한 정하기',
      '비상금 통장 분리하기',
      '가계부 카테고리 5개로 단순화',
      '중고판매 1건 올리기',
      '이직/협상 자료 1개 정리',
      '자동이체(저축) 설정하기',
      '카드/계좌 1개 정리'
    ),
    '\n(메모) 이 글은 더미데이터입니다.'
  ) AS content,

  CONCAT('user', LPAD(1 + MOD(seq.n, 200), 3, '0')) AS writer,

  DATE_SUB(NOW(), INTERVAL FLOOR(RAND(seq.n + 2) * 365) DAY) AS regdate,
  DATE_SUB(NOW(), INTERVAL FLOOR(RAND(seq.n + 3) * 365) DAY) AS updatedate,

  CASE WHEN MOD(seq.n, 97) = 0 THEN TRUE ELSE FALSE END AS delflag
FROM (
  SELECT (@row := @row + 1) AS n
  FROM
    (SELECT 0 d UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
     UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) a
  CROSS JOIN
    (SELECT 0 d UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
     UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) b
  CROSS JOIN
    (SELECT 0 d UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
     UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) c
  CROSS JOIN
    (SELECT 0 d UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
     UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) e
) seq;

SELECT COUNT(*) FROM tbl_community;
SELECT * FROM tbl_community ORDER BY bno DESC LIMIT 1000;

