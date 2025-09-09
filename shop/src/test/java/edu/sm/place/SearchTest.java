package edu.sm.place;

import edu.sm.app.dto.Place;
import edu.sm.app.dto.Search;
import edu.sm.app.service.PlaceService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.List;

@SpringBootTest
public class SearchTest {

    @Autowired
    PlaceService placeService;

    @Test
    void testFindByAddrAndType() throws Exception {
        // 검색 조건: "호산리" + type=10(병원)
        Search search = Search.builder()
                .addr("호산리")
                .type(20)
                .build();

        List<Place> list = placeService.findByAddrAndType(search);

        System.out.println("=== 검색 결과 ===");
        for (Place p : list) {
            System.out.println(p.getId() + " | " + p.getName() + " | " + p.getAddr() + " | " + p.getLat() + "," + p.getLng());
        }
        System.out.println("================");
    }
}
