package org.zerock.reply;

import java.util.List;

import org.apache.ibatis.annotations.Param;

public interface CommunityReplyMapper {

    int insert(CommunityReplyDTO dto);

    CommunityReplyDTO read(@Param("rno") int rno);

    int update(CommunityReplyDTO dto);

    int delete(@Param("rno") int rno); // soft delete

    List<CommunityReplyDTO> listOfBoard(
            @Param("bno") Long bno,
            @Param("skip") int skip,
            @Param("limit") int limit);

    int countOfBoard(Long bno);
}
