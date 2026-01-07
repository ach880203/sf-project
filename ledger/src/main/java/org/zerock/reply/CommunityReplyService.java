package org.zerock.reply;

import java.util.List;

import org.springframework.stereotype.Service;
import org.zerock.exception.CommunityReplyException;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class CommunityReplyService {

    private final CommunityReplyMapper mapper;

    public void add(CommunityReplyDTO dto) {
        try {
            mapper.insert(dto);
        } catch (Exception e) {
            throw new CommunityReplyException(500, "Insert Error");
        }
    }

    public CommunityReplyDTO getOne(int rno) {
        CommunityReplyDTO dto = mapper.read(rno);
        if (dto == null) {
            throw new CommunityReplyException(404, "Not Found");
        }
        return dto;
    }

    public void modify(CommunityReplyDTO dto, String loginUser) {
        CommunityReplyDTO origin = mapper.read(dto.getRno());

        if (origin == null) {
            throw new CommunityReplyException(404, "Not Found");
        }

        if (!origin.getReplyer().equals(loginUser)) {
            throw new CommunityReplyException(403, "No Permission");
        }

        mapper.update(dto);
    }

    public void remove(int rno, String loginUser) {
        CommunityReplyDTO origin = mapper.read(rno);

        if (origin == null) {
            throw new CommunityReplyException(404, "Not Found");
        }

        if (!origin.getReplyer().equals(loginUser)) {
            throw new CommunityReplyException(403, "No Permission");
        }

        mapper.delete(rno);
    }

    public CommunityReplyListPaginDTO listOfBoard(Long bno, int page, int size) {
        int skip = (page - 1) * size;

        List<CommunityReplyDTO> list =
                mapper.listOfBoard(bno, skip, size);

        int count = mapper.countOfBoard(bno);

        return new CommunityReplyListPaginDTO(list, count, page, size);
    }
}
