-- ID : side_user
-- pwd : ora123
-- 사용자(관리자), 자유게시판, 자유게시판 댓글, 영화, 영화게시판, 영화게시판 댓글, 컬렉션

/**
[사용자]
  회원가입
  회원정보수정
  회원탈퇴
  로그인

[관리자]
  회원조회
  회원삭제
 
[영화]
  영화등록(관리자)
  영화수정(관리자)
  영화삭제(관리자)
  영화조회
  영화추천

[영화게시판]
  게시글등록
  게시글수정
  게시글삭제
  게시글조회
  게시글추천

[영화게시판 댓글]
  댓글등록
  댓글수정
  댓글삭제
  댓글조회  
  대댓글

[일반게시판]
  게시글등록
  게시글수정
  게시글삭제
  게시글조회
  게시글추천

[일반게시판 댓글]
  댓글등록
  댓글수정
  댓글삭제
  댓글조회  
  대댓글
**/

-------------------------------------------------------------------------------------------------
-- 사용자 테이블
CREATE TABLE users(
  id VARCHAR2(50) PRIMARY KEY, /* 아이디 */
  pwd VARCHAR2(50) NOT NULL, /* 비밀번호 */
  name VARCHAR2(50) NOT NULL, /* 이름 */
  email VARCHAR2(50) NOT NULL, /* 이메일 */
  phone VARCHAR2(50) NOT NULL, /* 전화번호 */
  regDate DATE DEFAULT SYSDATE, /* 가입일 */
  role VARCHAR2(50) DEFAULT 'user', /* 권한 */
  useryn CHAR(1) DEFAULT 'n' /* 삭제여부 */
);

INSERT 
  INTO users(id, pwd, name, email, phone)
VALUES ('one', '1111', '하나', 'email@google.com', '010-1111-1111');


SELECT * FROM users ORDER BY regDate DESC;
DROP TABLE users;
commit;
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
-- 자유게시판 테이블
CREATE TABLE openBoard(
  obseq NUMBER(10) PRIMARY KEY, /* 글번호 */
  tab VARCHAR2(50) NOT NULL, /* 탭 */
  title VARCHAR2(50) NOT NULL, /* 제목 */
  writer VARCHAR2(50) NOT NULL, /* 작성자 */
  content VARCHAR2(1024) NOT NULL, /* 내용 */
  readCount NUMBER(10) DEFAULT 0, /* 조회수 */
  hit NUMBER(10) DEFAULT 0, /* 추천수 */
  uploadFile VARCHAR2(100) DEFAULT 'nothing.jpg', /* 첨부파일 */
  regDate DATE DEFAULT SYSDATE, /* 등록일 */
  modDate DATE, /* 수정일 */
  obyn CHAR(1) DEFAULT 'n', /* 삭제여부 */
  CONSTRAINT board_writer_fk FOREIGN KEY(writer) REFERENCES users(id) ON DELETE CASCADE /* 사용자 삭제 시 게시글도 삭제 */
);

-- 게시글 시퀀스
CREATE SEQUENCE openBoard_seq
START WITH 1
INCREMENT BY 1;

SELECT * FROM openBoard ORDER BY obseq DESC;
DROP TABLE openBoard;
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
-- 자유게시판 댓글 테이블
CREATE TABLE openBoardReply(
  obseq NUMBER(10) NOT NULL, /* 게시글 번호 */
  obrseq NUMBER(10) PRIMARY KEY, /* 댓글 번호 */
  parent_brseq NUMBER(10) DEFAULT 0, /* 모댓글 번호 */
  depth CHAR(1) DEFAULT 0, /* 댓글: 0, 대댓글: 1 */
  writer VARCHAR2(50) NOT NULL, /* 작성자 */
  content VARCHAR2(1024) NOT NULL, /* 내용 */
  hit NUMBER(10) DEFAULT 0, /* 추천수 */
  regDate DATE DEFAULT SYSDATE, /* 작성일 */
  modDate DATE, /* 수정일 */
  obryn CHAR(1) DEFAULT 'n', /* 삭제여부 */  
  CONSTRAINT openBoardReply_obseq_fk FOREIGN KEY(obseq) REFERENCES openBoard(obseq) ON DELETE CASCADE, /* 게시글 삭제시 댓글도 삭제 */
  CONSTRAINT openBoardReply_writer_fk FOREIGN KEY(writer) REFERENCES users(id) ON DELETE CASCADE/* 사용자 삭제시 댓글도 삭제 */
);

-- 댓글 시퀀스
CREATE SEQUENCE openBoardReply_seq
START WITH 1
INCREMENT BY 1;

SELECT * FROM openBoardReply ORDER BY obrseq DESC;
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
  photo VARCHAR2(100) DEFAULT 'nothing.jpg', /* 사진 */
  hit NUMBER(10), /* 추천수 */
  myn CHAR(1) DEFAULT 'n' /* 삭제여부 */
);

-- 영화 시퀀스
CREATE SEQUENCE movie_seq
START WITH 1
INCREMENT BY 1;

SELECT * FROM movie ORDER BY mseq DESC;
DROP TABLE movie;
commit;
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
-- 영화게시판 테이블
CREATE TABLE movieBoard(
  mseq NUMBER(10) NOT NULL, /* 영화 번호 */
  mbseq NUMBER(10) PRIMARY KEY, /* 게시글 번호 */
  title VARCHAR2(50) NOT NULL, /* 제목 */
  writer VARCHAR2(50) NOT NULL, /* 작성자 */
  content VARCHAR2(1024) NOT NULL, /* 내용 */
  readCount NUMBER(10) DEFAULT 0, /* 조회수 */
  hit NUMBER(10) DEFAULT 0, /* 추천수 */
  uploadFile VARCHAR2(100) DEFAULT 'nothing.jpg', /* 첨부파일 */  
  regDate DATE DEFAULT SYSDATE, /* 작성일 */
  modDate DATE, /* 수정일 */
  mbyn CHAR(1) DEFAULT 'n', /* 삭제여부 */
  CONSTRAINT movieBoard_writer_fk FOREIGN KEY(writer) REFERENCES users(id) ON DELETE CASCADE, /* 사용자 삭제시 게시글도 삭제 */
  CONSTRAINT movieBoard_mseq_fk FOREIGN KEY(mseq) REFERENCES movie(mseq) ON DELETE CASCADE /* 영화 삭제시 게시글도 삭제 */
);

-- 게시글 시퀀스
CREATE SEQUENCE movieBoard_seq
START WITH 1
INCREMENT BY 1;

SELECT * FROM movieBoard ORDER BY mbseq DESC;
DROP TABLE movieBoard;
commit;
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
-- 영화게시판 댓글 테이블
CREATE TABLE movieBoardReply(
  mbseq NUMBER(10) NOT NULL, /* 게시글 번호 */
  mbrseq NUMBER(10) PRIMARY KEY, /* 댓글 번호 */
  parent_mbrseq NUMBER(10) DEFAULT 0, /* 모댓글 번호 */
  depth CHAR(10) DEFAULT 0, /* 댓글: 0, 대댓글: 1 */
  writer VARCHAR2(50) NOT NULL, /* 작성자 */
  content VARCHAR2(1024) NOT NULL, /* 내용 */
  hit NUMBER(10) DEFAULT 0, /* 추천수 */
  regDate DATE DEFAULT SYSDATE, /* 작성일 */
  modDate DATE, /* 수정일 */
  mbryn CHAR(1) DEFAULT 'n', /* 삭제여부 */  
  CONSTRAINT movieBoardReply_mbseq_fk FOREIGN KEY(mbseq) REFERENCES movieBoard(mbseq) ON DELETE CASCADE, /* 게시글 삭제시 댓글도 삭제 */
  CONSTRAINT movieBoardReply_writer_fk FOREIGN KEY(writer) REFERENCES users(id) ON DELETE CASCADE/* 사용자 삭제시 댓글도 삭제 */
);

-- 댓글 시퀀스
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
  title VARCHAR2(50) NOT NULL, /* 제목 */
  writer VARCHAR2(50) NOT NULL, /* 유저 */
  intro VARCHAR2(50) NOT NULL, /* 소개 */
  post /* 게시글 */
  hit /* 추천수 */
  modDate /* 수정일 */
  cyn
);
