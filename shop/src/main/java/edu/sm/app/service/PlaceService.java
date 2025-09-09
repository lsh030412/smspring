package edu.sm.app.service;

import edu.sm.app.dto.Place;
import edu.sm.app.dto.Search;
import edu.sm.app.repository.PlaceRepository;
import edu.sm.common.frame.SmService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class PlaceService implements SmService<Place, Integer> {

    final PlaceRepository placeRepository;

    @Override
    public void register(Place place) throws Exception {
        placeRepository.insert(place);
    }

    @Override
    public void modify(Place place) throws Exception {
        placeRepository.update(place);
    }

    @Override
    public void remove(Integer id) throws Exception {
        placeRepository.delete(id);
    }

    @Override
    public List<Place> get() throws Exception {
        return placeRepository.selectAll();
    }

    @Override
    public Place get(Integer id) throws Exception {
        return placeRepository.select(id);
    }

    // 추가 기능
    public List<Place> findByAddrAndType(Search search) throws Exception {
        return placeRepository.findByAddrAndType(search);
    }
}