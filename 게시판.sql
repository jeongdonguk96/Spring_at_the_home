CREATE TABLE board(
  bno NUMBER PRIMARY KEY,
  title VARCHAR2(100) NOT NULL,
  content VARCHAR2(100) NOT NULL,
  writer VARCHAR2(100) NOT NULL,
  hit NUMBER DEFAULT 0,
  regDate DATE DEFAULT SYSDATE
);

CREATE SEQUENCE board_seq
START WITH 1
INCREMENT BY 1;

SELECT *
  FROM board
ORDER BY bno DESC;

INSERT
  INTO board(bno, title, content, writer, hit, regDate)
       (SELECT board_seq.NEXTVAL, title, content, writer, hit, regDate
          FROM board);

commit;