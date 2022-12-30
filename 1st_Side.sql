-- ID : side_user
-- pwd : ora123
-- 사용자(관리자), 자유게시판, 자유게시판 댓글, 영화, 영화게시판, 영화게시판 댓글, 컬렉션

-------------------------------------------------------------------------------------------------
-- 사용자 테이블
CREATE TABLE users(
  id VARCHAR2(50) PRIMARY KEY, /* 아이디 */
  pwd VARCHAR2(50) NOT NULL, /* 비밀번호 */
  name VARCHAR2(50) NOT NULL, /* 이름 */
  email VARCHAR2(50) NOT NULL, /* 이메일 */
  phone VARCHAR2(50) NOT NULL, /* 전화번호 */
  hit NUMBER(10), /* 인기도 */
  regDate DATE DEFAULT SYSDATE, /* 가입일 */
  role VARCHAR2(50) DEFAULT 'user', /* 권한 */
  useryn CHAR(1) DEFAULT 'y' /* 탈퇴여부 */
);

INSERT INTO users VALUES('admin', '1234', '정동욱', sysdate, 'admin');
INSERT INTO users VALUES('jk', '1234', '구슬', sysdate, 'admin');

SELECT * FROM users ORDER BY regDate DESC;
DROP TABLE users;
commit;
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
-- 자유게시판 테이블
CREATE TABLE OpenBoard(
  bseq NUMBER(10) PRIMARY KEY, /* 글번호 */
  tab VARCHAR2(50) NOT NULL, /* 탭 */
  title VARCHAR2(50) NOT NULL, /* 제목 */
  writer VARCHAR2(50) NOT NULL, /* 작성자 */
  content VARCHAR2(1024) NOT NULL, /* 내용 */
  regDate DATE DEFAULT SYSDATE, /* 등록일 */
  count NUMBER(10) DEFAULT 0, /* 조회수 */
  hit NUMBER(10) DEFAULT 0, /* 추천수 */
  uploadFile VARCHAR2(100), /* 첨부파일 */
  obyn CHAR(1) DEFAULT 'n', /* 삭제여부 */
  CONSTRAINT board_writer_fk FOREIGN KEY(writer) REFERENCES users(id) ON DELETE CASCADE /* 사용자 삭제 시 게시글도 삭제 */
);

-- 게시글 시퀀스
CREATE SEQUENCE board_seq
START WITH 1
INCREMENT BY 1;

SELECT * FROM board ORDER BY bseq DESC;
DROP TABLE board;
commit;

DELETE board WHERE seq=22;

INSERT
  INTO board(seq, tab, title, writer, content, uploadFile)
VALUES (board_seq.NEXTVAL, '공지', '안녕', '판리자', '안녕1', 'nothing.jsp');
INSERT
  INTO board(seq, tab, title, writer, content, uploadFile)
VALUES (board_seq.NEXTVAL, '유머', '안녕2', '판리자', '안녕2', 'nothing.jsp');
INSERT
  INTO board(seq, tab, title, writer, content, uploadFile)
VALUES (board_seq.NEXTVAL, '정보', '안녕3', '판리자', '안녕3', 'nothing.jsp');

-- 조회수 증가
UPDATE board
   SET count=count+1
 WHERE seq=22;

-- 추천수 증가
UPDATE board
   SET hit=hit+1
 WHERE seq=22;
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
-- 자유게시판 댓글
CREATE TABLE openBoardReply(
  bseq NUMBER(10) NOT NULL, /* 게시글 번호 */
  brseq NUMBER(10) PRIMARY KEY, /* 댓글 번호 */
  parent_brseq NUMBER(10) DEFAULT 0, /* 모댓글 번호 */
  writer VARCHAR2(50) NOT NULL, /* 작성자 */
  content VARCHAR2(1024) NOT NULL, /* 내용 */
  hit NUMBER(10) DEFAULT 0, /* 추천수 */
  regDate DATE DEFAULT SYSDATE, /* 작성일 */
  modDate DATE DEFAULT SYSDATE, /* 수정일 */
  obryn CHAR(1) DEFAULT 'n', /* 삭제여부 */  
  CONSTRAINT openBoardReply_bseq_fk FOREIGN KEY(bseq) REFERENCES openBoard(bseq) ON DELETE CASCADE, /* 게시글 삭제시 댓글도 삭제 */
  CONSTRAINT openBoardReply_writer_fk FOREIGN KEY(writer) REFERENCES users(id) ON DELETE CASCADE/* 사용자 삭제시 댓글도 삭제 */
);

CREATE SEQUENCE openBoardReply_seq
START WITH 1
INCREMENT BY 1;

SELECT * FROM openBoardReply ORDER BY brseq DESC;
DROP TABLE openBoardReply;
commit;
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
-- 영화 테이블
CREATE TABLE movie(
  mseq NUMBER(10) PRIMARY KEY, /* 영화번호 */
  title VARCHAR2(50) NOT NULL, /* 제목 */
  genre VARCHAR2(50) NOT NULL, /* 장르 */
  nation VARCHAR2(50) NOT NULL,/* 국가 */
  director VARCHAR2(50) NOT NULL, /* 감독 */
  actor VARCHAR2(50) NOT NULL, /* 출연진 */
  story VARCHAR2(1024) NOT NULL, /* 내용 */
  openingDate DATE DEFAULT SYSDATE, /* 개봉일 */
  audience NUMBER(10), /* 관객수 */
  photo VARCHAR2(100), /* 사진 */
  hit NUMBER(10), /* 추천수 */
  myn CHAR(1) DEFAULT 'n' /* 삭제여부 */
);

CREATE SEQUENCE movie_seq
START WITH 1
INCREMENT BY 1;

SELECT * FROM movie ORDER BY mseq DESC;
DROP TABLE movie;
commit;
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
-- 영화게시판
CREATE TABLE movieBoard(
  mseq NUMBER(10) NOT NULL, /* 영화 번호 */
  mbseq NUMBER(10) PRIMARY KEY, /* 게시글 번호 */
  title VARCHAR2(50) NOT NULL, /* 제목 */
  writer VARCHAR2(50) NOT NULL, /* 작성자 */
  content VARCHAR2(1024) NOT NULL, /* 내용 */
  hit NUMBER(10) DEFAULT 0, /* 추천수 */
  regDate DATE DEFAULT SYSDATE, /* 작성일 */
  modDate DATE DEFAULT SYSDATE, /* 수정일 */
  mryn CHAR(1) DEFAULT 'n', /* 삭제여부 */
  CONSTRAINT movieBoard_writer_fk FOREIGN KEY(writer) REFERENCES users(id) ON DELETE CASCADE, /* 사용자 삭제시 게시글도 삭제 */
  CONSTRAINT movieBoard_mseq_fk FOREIGN KEY(mseq) REFERENCES movie(mseq) ON DELETE CASCADE /* 영화 삭제시 게시글도 삭제 */
);

CREATE SEQUENCE movieBoard_seq
START WITH 1
INCREMENT BY 1;

SELECT * FROM movieBoard ORDER BY mrseq DESC;
DROP TABLE movieBoard;
commit;
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
-- 영화게시판 댓글
CREATE TABLE movieBoardReply(
  mbseq NUMBER(10) NOT NULL, /* 게시글 번호 */
  mbrseq NUMBER(10) PRIMARY KEY, /* 댓글 번호 */
  parent_mbseq NUMBER(10) DEFAULT 0, /* 모댓글 번호 */
  writer VARCHAR2(50) NOT NULL, /* 작성자 */
  content VARCHAR2(1024) NOT NULL, /* 내용 */
  hit NUMBER(10) DEFAULT 0, /* 추천수 */
  regDate DATE DEFAULT SYSDATE, /* 작성일 */
  modDate DATE DEFAULT SYSDATE, /* 수정일 */
  mbryn CHAR(1) DEFAULT 'n', /* 삭제여부 */  
  CONSTRAINT movieBoardReply_mbseq_fk FOREIGN KEY(mbseq) REFERENCES movieBoard(mbseq) ON DELETE CASCADE, /* 게시글 삭제시 댓글도 삭제 */
  CONSTRAINT movieBoardReply_writer_fk FOREIGN KEY(writer) REFERENCES users(id) ON DELETE CASCADE/* 사용자 삭제시 댓글도 삭제 */
);

CREATE SEQUENCE movieBoardReply_seq
START WITH 1
INCREMENT BY 1;

SELECT * FROM movieBoardReply ORDER BY mbrseq DESC;
DROP TABLE movieBoardReply;
commit;
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
-- 컬렉션 테이블
CREATE TABLE collection(
  cseq NUMBER(10) PRIMARY KEY, /* 컬렉션 번호 */
  title /* 제목 */
  writer /* 유저 */
  intro /* 소개 */
  list /* 목록 */
  post /* 게시글 */
  hit /* 추천수 */
  modDate /* 수정일 */
  
);
















