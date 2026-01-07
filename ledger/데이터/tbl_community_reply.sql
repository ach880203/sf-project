use springdb;

create table tbl_community_reply(
	rno int auto_increment primary key,
    replyText varchar(500) not null,
    replyer varchar(50) not null,
    replydate timestamp default now(),
    updatedate timestamp default now() on update now(),
    delflag boolean default false,
    bno int not null
    );
    
    alter table tbl_community_reply add constraint fk_reply_board foreign key(bno)
    references tbl_community(bno);
    
    create index idx_tbl_community_reply on tbl_community_reply(bno desc, rno asc);
    
    select * from tbl_community_reply
    order by bno desc;
    
    desc tbl_community_reply;
    
    select * from tbl_community_reply
		where bno = 49999 and rno>0
		order by rno asc
		limit 10 offset 10;