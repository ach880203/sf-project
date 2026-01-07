package org.zerock.mapper;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.IntStream;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.zerock.community.CommunityDTO;
import org.zerock.community.CommunityMapper;

import lombok.extern.log4j.Log4j2;

@ExtendWith(SpringExtension.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j2
public class CommunityMapperTests {

    @Autowired
    private CommunityMapper communityMapper;

    @Test
    public void testInsert() {

        CommunityDTO dto = CommunityDTO.builder()
                .title("test title")
                .content("test content")
                .writer("user01")
                .build();

        int count = communityMapper.insert(dto);

        log.info("insert count: " + count);
        log.info("bno: " + dto.getBno());
    }

    @Test
    public void testSelectOne() {
        CommunityDTO dto = communityMapper.selectOne(1L);
        log.info(dto);
    }

    @Test
    public void testUpdate() {

        CommunityDTO dto = CommunityDTO.builder()
                .bno(1L)
                .title("updated title")
                .content("updated content")
                .build();

        int count = communityMapper.update(dto);
        log.info("update count: " + count);
    }

    @Test
    public void testRemove() {
        int count = communityMapper.remove(1L);
        log.info("remove count: " + count);
    }

    @Test
    public void testListSearch() {

        int page = 1;
        int size = 10;
        int skip = (page - 1) * size;

        String[] types = {"T", "C"};
        String keyword = "test";

        communityMapper.listSearch(skip, size, types, keyword)
                .forEach(dto -> log.info(dto));
    }

    @Test
    public void testListCountSearch() {

        String[] types = {"T", "C"};
        String keyword = "test";

        int total = communityMapper.listCountSearch(types, keyword);
        log.info("total count: " + total);
    }
}
