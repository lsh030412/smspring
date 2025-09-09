<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
  /* 레이아웃 */
  #mapWrap {
    display: grid;
    grid-template-columns: 320px 1fr;
    gap: 12px;
    width: 100%;
  }
  /* 좌측 검색/목록 패널 */
  #menu_wrap {
    border: 1px solid #ddd;
    border-radius: 8px;
    padding: 12px;
    height: 400px;
    overflow: hidden;
    display: flex;
    flex-direction: column;
  }
  #menu_wrap .input_wrap {
    display: flex;
    gap: 8px;
    margin-bottom: 10px;
  }
  #menu_wrap .input_wrap input[type="text"] {
    flex: 1;
    padding: 6px 8px;
    border: 1px solid #ccc;
    border-radius: 6px;
  }
  #menu_wrap .input_wrap button {
    padding: 6px 10px;
    border: 1px solid #ccc;
    background: #f8f8f8;
    border-radius: 6px;
    cursor: pointer;
  }
  #placesList {
    list-style: none;
    padding: 0;
    margin: 0;
    overflow: auto;
    flex: 1 1 auto;
    border-top: 1px dashed #eee;
  }
  #placesList .item {
    display: grid;
    grid-template-columns: 28px 1fr;
    gap: 8px;
    padding: 10px 0;
    border-bottom: 1px solid #f2f2f2;
  }
  .markerbg {
    width: 28px; height: 36px;
    background: url('https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_number_blue.png') no-repeat;
  }
  /* 1~15까지 스프라이트용 클래스 (필요 개수만큼) */
  .marker_1  { background-position: 0 -10px; }
  .marker_2  { background-position: 0 -56px; }
  .marker_3  { background-position: 0 -102px; }
  .marker_4  { background-position: 0 -148px; }
  .marker_5  { background-position: 0 -194px; }
  .marker_6  { background-position: 0 -240px; }
  .marker_7  { background-position: 0 -286px; }
  .marker_8  { background-position: 0 -332px; }
  .marker_9  { background-position: 0 -378px; }
  .marker_10 { background-position: 0 -424px; }
  .marker_11 { background-position: 0 -470px; }
  .marker_12 { background-position: 0 -516px; }
  .marker_13 { background-position: 0 -562px; }
  .marker_14 { background-position: 0 -608px; }
  .marker_15 { background-position: 0 -654px; }

  .info h5 { margin: 0 0 4px; font-size: 15px; }
  .info span { display: block; font-size: 12px; color: #666; }
  .info .tel { color: #222; margin-top: 4px; }

  #pagination {
    text-align: center;
    padding-top: 8px;
    border-top: 1px dashed #eee;
  }
  #pagination a {
    display: inline-block;
    margin: 0 3px;
    padding: 2px 6px;
    border: 1px solid #ddd;
    border-radius: 4px;
    text-decoration: none;
    color: #333;
  }
  #pagination a.on {
    background: #333;
    color: #fff;
    border-color: #333;
  }

  /* 지도 */
  #map {
    width: 100%;
    height: 400px;
    border: 2px solid red;
    border-radius: 8px;
  }
</style>

<script>
  let map = {
    kMap: null,
    ps: null,
    infowindow: null,
    markers: [],

    init: function () {
      // 지도 생성
      const mapContainer = document.getElementById('map');
      const mapOption = {
        center: new kakao.maps.LatLng(37.566826, 126.9786567),
        level: 3
      };
      this.kMap = new kakao.maps.Map(mapContainer, mapOption);

      // Places, InfoWindow
      this.ps = new kakao.maps.services.Places();
      this.infowindow = new kakao.maps.InfoWindow({ zIndex: 1 });

      // 검색 버튼 & 엔터 키 동작
      const btn = document.getElementById('searchBtn');
      const input = document.getElementById('keyword');

      btn.addEventListener('click', () => this.searchPlaces());
      input.addEventListener('keydown', (e) => {
        if (e.key === 'Enter') this.searchPlaces();
      });
    },

    // 키워드 검색
    searchPlaces: function () {
      const keywordEl = document.getElementById('keyword');
      const keyword = keywordEl.value;

      if (!keyword.replace(/^\s+|\s+$/g, '')) {
        alert('키워드를 입력해주세요!');
        return;
      }
      this.ps.keywordSearch(keyword, (data, status, pagination) => {
        this.placesSearchCB(data, status, pagination);
      });
    },

    // 검색 콜백
    placesSearchCB: function (data, status, pagination) {
      if (status === kakao.maps.services.Status.OK) {
        this.displayPlaces(data);
        this.displayPagination(pagination);
      } else if (status === kakao.maps.services.Status.ZERO_RESULT) {
        alert('검색 결과가 존재하지 않습니다.');
      } else if (status === kakao.maps.services.Status.ERROR) {
        alert('검색 결과 중 오류가 발생했습니다.');
      }
    },

    // 목록/마커 표시
    displayPlaces: function (places) {
      const listEl = document.getElementById('placesList');
      const menuEl = document.getElementById('menu_wrap');
      const fragment = document.createDocumentFragment();
      const bounds = new kakao.maps.LatLngBounds();

      // 목록/마커 초기화
      this.removeAllChildNodes(listEl);
      this.removeMarker();

      for (let i = 0; i < places.length; i++) {
        const placePosition = new kakao.maps.LatLng(places[i].y, places[i].x);
        const marker = this.addMarker(placePosition, i);
        const itemEl = this.getListItem(i, places[i]);

        bounds.extend(placePosition);

        // hover 시 인포윈도우
        ((marker, title) => {
          kakao.maps.event.addListener(marker, 'mouseover', () => {
            this.displayInfowindow(marker, title);
          });
          kakao.maps.event.addListener(marker, 'mouseout', () => {
            this.infowindow.close();
          });

          itemEl.onmouseover = () => this.displayInfowindow(marker, title);
          itemEl.onmouseout  = () => this.infowindow.close();

          // 클릭 시 지도 중심 이동(선호에 맞게 동작 추가 가능)
          kakao.maps.event.addListener(marker, 'click', () => {
            this.kMap.panTo(marker.getPosition());
          });
          itemEl.onclick = () => this.kMap.panTo(marker.getPosition());
        })(marker, places[i].place_name);

        fragment.appendChild(itemEl);
      }

      listEl.appendChild(fragment);
      menuEl.scrollTop = 0;
      this.kMap.setBounds(bounds);
    },

    // 목록 item 엘리먼트 생성
    getListItem: function (index, place) {
      const el = document.createElement('li');
      let itemStr =
              '<span class="markerbg marker_' + (index + 1) + '"></span>' +
              '<div class="info">' +
              '  <h5>' + place.place_name + '</h5>';

      if (place.road_address_name) {
        itemStr +=
                '  <span>' + place.road_address_name + '</span>' +
                '  <span class="jibun gray">' + place.address_name + '</span>';
      } else {
        itemStr += '  <span>' + place.address_name + '</span>';
      }

      itemStr += '  <span class="tel">' + (place.phone || '') + '</span>' +
              '</div>';

      el.innerHTML = itemStr;
      el.className = 'item';
      return el;
    },

    // 마커 생성
    addMarker: function (position, idx) {
      const imageSrc = 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_number_blue.png';
      const imageSize = new kakao.maps.Size(36, 37);
      const imgOptions = {
        spriteSize: new kakao.maps.Size(36, 691),
        spriteOrigin: new kakao.maps.Point(0, (idx * 46) + 10),
        offset: new kakao.maps.Point(13, 37)
      };
      const markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imgOptions);

      const marker = new kakao.maps.Marker({
        position,
        image: markerImage
      });

      marker.setMap(this.kMap);
      this.markers.push(marker);
      return marker;
    },

    // 모든 마커 제거
    removeMarker: function () {
      for (let i = 0; i < this.markers.length; i++) {
        this.markers[i].setMap(null);
      }
      this.markers = [];
    },

    // 페이지네이션 표시
    displayPagination: function (pagination) {
      const paginationEl = document.getElementById('pagination');
      const fragment = document.createDocumentFragment();

      while (paginationEl.hasChildNodes()) {
        paginationEl.removeChild(paginationEl.lastChild);
      }

      for (let i = 1; i <= pagination.last; i++) {
        const a = document.createElement('a');
        a.href = '#';
        a.innerHTML = i;

        if (i === pagination.current) {
          a.className = 'on';
        } else {
          a.onclick = ((i) => () => pagination.gotoPage(i))(i);
        }
        fragment.appendChild(a);
      }
      paginationEl.appendChild(fragment);
    },

    // 인포윈도우
    displayInfowindow: function (marker, title) {
      const content = '<div style="padding:5px;z-index:1;">' + title + '</div>';
      this.infowindow.setContent(content);
      this.infowindow.open(this.kMap, marker);
    },

    // 자식 노드 제거
    removeAllChildNodes: function (el) {
      while (el.hasChildNodes()) {
        el.removeChild(el.lastChild);
      }
    }
  };

  document.addEventListener("DOMContentLoaded", function() {
    map.init();
  });
</script>

<div class="col-sm-10">
  <h2>Map6 : 키워드 장소검색</h2>
  <div id="mapWrap">
    <!-- 좌측 검색/목록 패널 -->
    <div id="menu_wrap">
      <div class="input_wrap">
        <input type="text" id="keyword" placeholder="예: 카페, 편의점, 충전소 등">
        <button id="searchBtn">검색</button>
      </div>
      <ul id="placesList"></ul>
      <div id="pagination"></div>
    </div>

    <!-- 지도 -->
    <div id="map"></div>
  </div>
</div>
