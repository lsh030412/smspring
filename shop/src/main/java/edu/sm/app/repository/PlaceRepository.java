package edu.sm.app.repository;

import edu.sm.app.dto.Place;
import edu.sm.app.dto.Search;
import edu.sm.common.frame.SmRepository;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@Mapper
public interface PlaceRepository extends SmRepository<Place, Integer> {
    // 주소 + 타입으로 조회
    List<Place> findByAddrAndType(Search search) throws Exception;
}