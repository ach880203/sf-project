 use springdb;
 create table tbl_account(
     uid varchar(50) primary key,
     upw varchar(100) not null,
     uname varchar(100) not null,
     email varchar(100) unicode,
     createDate timestamp default current_timestamp,
     updateDate timestamp default current_timestamp
     );
     
     create table tbl_account_roles(
     uid varchar(50) not null,
     rolename varchar (50) not null,
     foreign key (uid) references tbl_account(uid)
     );
     
desc tbl_account;

select * from tbl_account;
select * from tbl_account_roles;
     
select *
from  tbl_account a
inner join tbl_account_roles r
on a.uid = r.uid
where a.uid = 'user100';
     
CREATE TABLE persistent_logins (
    username VARCHAR(64) NOT NULL,
    series VARCHAR(64) PRIMARY KEY,
    token VARCHAR(64) NOT NULL,
    last_used TIMESTAMP NOT NULL
);

select * from persistent_logins;

SELECT DATABASE();