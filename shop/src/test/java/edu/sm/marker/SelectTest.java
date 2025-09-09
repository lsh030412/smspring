package edu.sm.marker;

import edu.sm.app.dto.Marker;
import edu.sm.app.service.MarkerService;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.List;
@Slf4j
@SpringBootTest
class SelectTest {

    @Autowired
    MarkerService markerService;

    @Test
    void contextLoads() {
        try {
            log.info("selectAll start-----------------");
            List<Marker> list = markerService.get();
            list.forEach(System.out::println);

            log.info("select start-----------------");
            Marker marker = markerService.get(101);
            log.info(marker.toString());

            log.info("findByLoc start-----------------");
            List<Marker> list2 = markerService.findByLoc(200);
            list2.forEach((data)-> {log.info(data.toString());});
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}