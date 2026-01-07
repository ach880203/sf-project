package org.zerock.reply;

import java.util.List;
import java.util.stream.IntStream;

import lombok.Data;

@Data
public class CommunityReplyListPaginDTO {

    private List<CommunityReplyDTO> communityReplyDTOList;
    private int totalCount;
    private int page, size;
    private int start, end;
    private boolean prev, next;
    private List<Integer> pageNums;

    public CommunityReplyListPaginDTO(
            List<CommunityReplyDTO> list,
            int totalCount,
            int page,
            int size) {

        this.communityReplyDTOList = list;
        this.totalCount = totalCount;
        this.page = page;
        this.size = size;

        int tempEnd = (int) (Math.ceil(page / 10.0)) * 10;
        this.start = tempEnd - 9;

        this.end = Math.min(
                (int) Math.ceil(totalCount / (double) size),
                tempEnd
        );

        this.prev = start > 1;
        this.next = totalCount > end * size;

        this.pageNums = IntStream.rangeClosed(start, end).boxed().toList();
    }
}
