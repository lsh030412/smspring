<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
  /* 래퍼: 지도와 로드뷰를 나란히 배치 */
  #mapWrapper {
    display: flex;
    gap: 8px;
    width: 100%;
  }
  /* 지도/로드뷰 공통 높이 */
  #map, #roadview {
    height: 400px;
    border: 2px solid red;
  }
  /* 초기엔 로드뷰를 숨김 */
  #roadview { display: none; }
</style>

<script>
  let map = {
    init: function () {
      // 필수 요소 참조
      const mapWrapper = document.getElementById('mapWrapper');
      const mapContainer = document.getElementById('map');
      const rvContainer  = document.getElementById('roadview');

      // 중심 좌표
      const mapCenter = new kakao.maps.LatLng(33.450422139819736, 126.5709139924533);

      // 지도 생성
      const kMap = new kakao.maps.Map(mapContainer, {
        center: mapCenter,
        level: 3
      });

      // 지도 위에 로드뷰 도로 표시
      kMap.addOverlayMapTypeId(kakao.maps.MapTypeId.ROADVIEW);

      // 로드뷰/클라이언트 생성
      const rv       = new kakao.maps.Roadview(rvContainer);
      const rvClient = new kakao.maps.RoadviewClient();

      // 스프라이트 기반 로드뷰 마커 이미지
      const markImage = new kakao.maps.MarkerImage(
              'https://t1.daumcdn.net/localimg/localimages/07/2018/pc/roadview_minimap_wk_2018.png',
              new kakao.maps.Size(26, 46),
              {
                spriteSize:  new kakao.maps.Size(1666, 168),
                spriteOrigin:new kakao.maps.Point(705, 114),
                offset:      new kakao.maps.Point(13, 46)
              }
      );

      // 드래그 가능한 마커
      const rvMarker = new kakao.maps.Marker({
        image: markImage,
        position: mapCenter,
        draggable: true,
        map: kMap
      });

      // 로드뷰 토글 함수 (내부에서 캡쳐 사용)
      function toggleRoadview(position) {
        // position 인근의 로드뷰 panoId 조회 (반경 50m)
        rvClient.getNearestPanoId(position, 50, function (panoId) {
          if (panoId === null) {
            // 로드뷰가 없으면 지도만 100%
            rvContainer.style.display = 'none';
            // flex 환경에서는 width 조정보다 display로 분기하는 게 안정적
            mapContainer.style.flex = '1 1 100%';
            kMap.relayout();
          } else {
            // 로드뷰가 있으면 지/뷰 반반
            rvContainer.style.display = 'block';
            mapContainer.style.flex = '1 1 50%';
            rvContainer.style.flex  = '1 1 50%';
            kMap.relayout();
            rv.setPanoId(panoId, position);
            rv.relayout();
          }
        });
      }

      // 초기 토글
      toggleRoadview(mapCenter);

      // 마커 드래그 종료 시 해당 위치로 로드뷰 갱신
      kakao.maps.event.addListener(rvMarker, 'dragend', function () {
        const pos = rvMarker.getPosition();
        toggleRoadview(pos);
      });

      // 지도 클릭 시 마커 이동 + 로드뷰 갱신
      kakao.maps.event.addListener(kMap, 'click', function (mouseEvent) {
        const pos = mouseEvent.latLng;
        rvMarker.setPosition(pos);
        toggleRoadview(pos);
      });
    }
  };

  // jQuery 사용 버전 (프로젝트에 jQuery 포함되어 있다는 전제)
  $(function () {
    map.init();
  });
</script>

<div class="col-sm-10">
  <h2>Map5 : 로드뷰 토글 + 드래그 마커</h2>

  <!-- 지도/로드뷰 래퍼 -->
  <div id="mapWrapper">
    <div id="map" style="flex: 1 1 100%;"></div>
    <div id="roadview" style="flex: 1 1 50%;"></div>
  </div>
</div>