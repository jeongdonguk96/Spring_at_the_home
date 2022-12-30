-- ID : side_user
-- pwd : ora123
-- �����(������), �����Խ���, �����Խ��� ���, ��ȭ, ��ȭ�Խ���, ��ȭ�Խ��� ���, �÷���

-------------------------------------------------------------------------------------------------
-- ����� ���̺�
CREATE TABLE users(
  id VARCHAR2(50) PRIMARY KEY, /* ���̵� */
  pwd VARCHAR2(50) NOT NULL, /* ��й�ȣ */
  name VARCHAR2(50) NOT NULL, /* �̸� */
  email VARCHAR2(50) NOT NULL, /* �̸��� */
  phone VARCHAR2(50) NOT NULL, /* ��ȭ��ȣ */
  hit NUMBER(10), /* �α⵵ */
  regDate DATE DEFAULT SYSDATE, /* ������ */
  role VARCHAR2(50) DEFAULT 'user', /* ���� */
  useryn CHAR(1) DEFAULT 'y' /* Ż�𿩺� */
);

INSERT INTO users VALUES('admin', '1234', '������', sysdate, 'admin');
INSERT INTO users VALUES('jk', '1234', '����', sysdate, 'admin');

SELECT * FROM users ORDER BY regDate DESC;
DROP TABLE users;
commit;
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
-- �����Խ��� ���̺�
CREATE TABLE OpenBoard(
  bseq NUMBER(10) PRIMARY KEY, /* �۹�ȣ */
  tab VARCHAR2(50) NOT NULL, /* �� */
  title VARCHAR2(50) NOT NULL, /* ���� */
  writer VARCHAR2(50) NOT NULL, /* �ۼ��� */
  content VARCHAR2(1024) NOT NULL, /* ���� */
  regDate DATE DEFAULT SYSDATE, /* ����� */
  count NUMBER(10) DEFAULT 0, /* ��ȸ�� */
  hit NUMBER(10) DEFAULT 0, /* ��õ�� */
  uploadFile VARCHAR2(100), /* ÷������ */
  obyn CHAR(1) DEFAULT 'n', /* �������� */
  CONSTRAINT board_writer_fk FOREIGN KEY(writer) REFERENCES users(id) ON DELETE CASCADE /* ����� ���� �� �Խñ۵� ���� */
);

-- �Խñ� ������
CREATE SEQUENCE board_seq
START WITH 1
INCREMENT BY 1;

SELECT * FROM board ORDER BY bseq DESC;
DROP TABLE board;
commit;

DELETE board WHERE seq=22;

INSERT
  INTO board(seq, tab, title, writer, content, uploadFile)
VALUES (board_seq.NEXTVAL, '����', '�ȳ�', '�Ǹ���', '�ȳ�1', 'nothing.jsp');
INSERT
  INTO board(seq, tab, title, writer, content, uploadFile)
VALUES (board_seq.NEXTVAL, '����', '�ȳ�2', '�Ǹ���', '�ȳ�2', 'nothing.jsp');
INSERT
  INTO board(seq, tab, title, writer, content, uploadFile)
VALUES (board_seq.NEXTVAL, '����', '�ȳ�3', '�Ǹ���', '�ȳ�3', 'nothing.jsp');

-- ��ȸ�� ����
UPDATE board
   SET count=count+1
 WHERE seq=22;

-- ��õ�� ����
UPDATE board
   SET hit=hit+1
 WHERE seq=22;
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
-- �����Խ��� ���
CREATE TABLE openBoardReply(
  bseq NUMBER(10) NOT NULL, /* �Խñ� ��ȣ */
  brseq NUMBER(10) PRIMARY KEY, /* ��� ��ȣ */
  parent_brseq NUMBER(10) DEFAULT 0, /* ���� ��ȣ */
  writer VARCHAR2(50) NOT NULL, /* �ۼ��� */
  content VARCHAR2(1024) NOT NULL, /* ���� */
  hit NUMBER(10) DEFAULT 0, /* ��õ�� */
  regDate DATE DEFAULT SYSDATE, /* �ۼ��� */
  modDate DATE DEFAULT SYSDATE, /* ������ */
  obryn CHAR(1) DEFAULT 'n', /* �������� */  
  CONSTRAINT openBoardReply_bseq_fk FOREIGN KEY(bseq) REFERENCES openBoard(bseq) ON DELETE CASCADE, /* �Խñ� ������ ��۵� ���� */
  CONSTRAINT openBoardReply_writer_fk FOREIGN KEY(writer) REFERENCES users(id) ON DELETE CASCADE/* ����� ������ ��۵� ���� */
);

CREATE SEQUENCE openBoardReply_seq
START WITH 1
INCREMENT BY 1;

SELECT * FROM openBoardReply ORDER BY brseq DESC;
DROP TABLE openBoardReply;
commit;
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
-- ��ȭ ���̺�
CREATE TABLE movie(
  mseq NUMBER(10) PRIMARY KEY, /* ��ȭ��ȣ */
  title VARCHAR2(50) NOT NULL, /* ���� */
  genre VARCHAR2(50) NOT NULL, /* �帣 */
  nation VARCHAR2(50) NOT NULL,/* ���� */
  director VARCHAR2(50) NOT NULL, /* ���� */
  actor VARCHAR2(50) NOT NULL, /* �⿬�� */
  story VARCHAR2(1024) NOT NULL, /* ���� */
  openingDate DATE DEFAULT SYSDATE, /* ������ */
  audience NUMBER(10), /* ������ */
  photo VARCHAR2(100), /* ���� */
  hit NUMBER(10), /* ��õ�� */
  myn CHAR(1) DEFAULT 'n' /* �������� */
);

CREATE SEQUENCE movie_seq
START WITH 1
INCREMENT BY 1;

SELECT * FROM movie ORDER BY mseq DESC;
DROP TABLE movie;
commit;
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
-- ��ȭ�Խ���
CREATE TABLE movieBoard(
  mseq NUMBER(10) NOT NULL, /* ��ȭ ��ȣ */
  mbseq NUMBER(10) PRIMARY KEY, /* �Խñ� ��ȣ */
  title VARCHAR2(50) NOT NULL, /* ���� */
  writer VARCHAR2(50) NOT NULL, /* �ۼ��� */
  content VARCHAR2(1024) NOT NULL, /* ���� */
  hit NUMBER(10) DEFAULT 0, /* ��õ�� */
  regDate DATE DEFAULT SYSDATE, /* �ۼ��� */
  modDate DATE DEFAULT SYSDATE, /* ������ */
  mryn CHAR(1) DEFAULT 'n', /* �������� */
  CONSTRAINT movieBoard_writer_fk FOREIGN KEY(writer) REFERENCES users(id) ON DELETE CASCADE, /* ����� ������ �Խñ۵� ���� */
  CONSTRAINT movieBoard_mseq_fk FOREIGN KEY(mseq) REFERENCES movie(mseq) ON DELETE CASCADE /* ��ȭ ������ �Խñ۵� ���� */
);

CREATE SEQUENCE movieBoard_seq
START WITH 1
INCREMENT BY 1;

SELECT * FROM movieBoard ORDER BY mrseq DESC;
DROP TABLE movieBoard;
commit;
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
-- ��ȭ�Խ��� ���
CREATE TABLE movieBoardReply(
  mbseq NUMBER(10) NOT NULL, /* �Խñ� ��ȣ */
  mbrseq NUMBER(10) PRIMARY KEY, /* ��� ��ȣ */
  parent_mbseq NUMBER(10) DEFAULT 0, /* ���� ��ȣ */
  writer VARCHAR2(50) NOT NULL, /* �ۼ��� */
  content VARCHAR2(1024) NOT NULL, /* ���� */
  hit NUMBER(10) DEFAULT 0, /* ��õ�� */
  regDate DATE DEFAULT SYSDATE, /* �ۼ��� */
  modDate DATE DEFAULT SYSDATE, /* ������ */
  mbryn CHAR(1) DEFAULT 'n', /* �������� */  
  CONSTRAINT movieBoardReply_mbseq_fk FOREIGN KEY(mbseq) REFERENCES movieBoard(mbseq) ON DELETE CASCADE, /* �Խñ� ������ ��۵� ���� */
  CONSTRAINT movieBoardReply_writer_fk FOREIGN KEY(writer) REFERENCES users(id) ON DELETE CASCADE/* ����� ������ ��۵� ���� */
);

CREATE SEQUENCE movieBoardReply_seq
START WITH 1
INCREMENT BY 1;

SELECT * FROM movieBoardReply ORDER BY mbrseq DESC;
DROP TABLE movieBoardReply;
commit;
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
-- �÷��� ���̺�
CREATE TABLE collection(
  cseq NUMBER(10) PRIMARY KEY, /* �÷��� ��ȣ */
  title /* ���� */
  writer /* ���� */
  intro /* �Ұ� */
  list /* ��� */
  post /* �Խñ� */
  hit /* ��õ�� */
  modDate /* ������ */
  
);
















