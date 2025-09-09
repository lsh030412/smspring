<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style>
  #map1 {
    width: auto;
    height: 400px;
    border: 2px solid deepskyblue;
  }
</style>
<script>
  let map1 = {
    addr: null,
    map: null,
    markers: [],

    init:function(){
      this.makeMap();

      // 병원 버튼 클릭
      $('#btn1').click(()=>{
        this.addr ? this.getData(10) : alert('주소를 찾을 수 없습니다.');
      });

      // 편의점 버튼 클릭
      $('#btn2').click(()=>{
        this.addr ? this.getData(20) : alert('주소를 찾을 수 없습니다.');
      });
    },

    // 서버에서 데이터 요청
    getData:function(type) {
      $.ajax({
        url:'/getaddrshop',
        data: {addr:this.addr, type:type},
        success:(result)=> {
          // 기존 마커 제거
          this.clearMarkers();
          // 새로운 마커 생성
          this.showMarkers(result);
        },
        error:()=>{
          alert("데이터 요청 실패");
        }
      });
    },

    // 지도 초기화
    makeMap:function() {
      let mapContainer = document.getElementById('map1');
      let mapOption = {
        center: new kakao.maps.LatLng(36.900209, 127.974968),
        level: 5
      }
      this.map = new kakao.maps.Map(mapContainer, mapOption);

      let mapTypeControl = new kakao.maps.MapTypeControl();
      this.map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);
      let zoomControl = new kakao.maps.ZoomControl();
      this.map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);

      // 현재 위치 가져오기
      if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition((position)=> {
          let lat = position.coords.latitude;   // 위도
          let lng = position.coords.longitude;  // 경도
            $('latlng').html(lat+' '+lng);
          let locPosition = new kakao.maps.LatLng(lat, lng);
          this.goMap(locPosition);
        });
      } else {
        alert('위치 정보를 지원하지 않습니다.');
      }
    },

    // 현재 위치 표시 + 주소 변환
    goMap:function(locPosition){
      let marker = new kakao.maps.Marker({
        map: this.map,
        position: locPosition
      });
      this.map.panTo(locPosition);

      let geocoder = new kakao.maps.services.Geocoder();
      geocoder.coord2RegionCode(
              locPosition.getLng(),
              locPosition.getLat(),
              this.addDisplay1.bind(this)
      );
      geocoder.coord2Address(
              locPosition.getLng(),
              locPosition.getLat(),
              this.addDisplay2.bind(this)
      );
    },

    // 간단 주소 표시
    addDisplay1:function(result, status){
      if (status === kakao.maps.services.Status.OK) {
        $('#addr1').html(result[0].address_name);
        this.addr=result[0].address_name; // 서버에 보낼 addr
      }
    },

    // 상세 주소 표시
    addDisplay2:function(result, status) {
      if (status === kakao.maps.services.Status.OK) {
        let detailAddr = !!result[0].road_address
                ? '<div>도로명주소 : ' + result[0].road_address.address_name + '</div>'
                : '';
        detailAddr += '<div>지번 주소 : ' + result[0].address.address_name + '</div>';
        $('#addr2').html(detailAddr);
      }
    },

    // 지도에 마커 출력
    showMarkers:function(datas) {
      datas.forEach(item => {
        let markerPosition = new kakao.maps.LatLng(item.lat, item.lng);
        let marker = new kakao.maps.Marker({
          map: this.map,
          position: markerPosition
        });

        let iwContent = `
          <div style="padding:5px;">
            <b>${item.name}</b><br>
            ${item.addr}<br>
            <img src="/img/${item.img}" width="60">
          </div>`;
        let infowindow = new kakao.maps.InfoWindow({ content: iwContent });

        kakao.maps.event.addListener(marker, 'mouseover', () => {
          infowindow.open(this.map, marker);
        });
        kakao.maps.event.addListener(marker, 'mouseout', () => {
          infowindow.close();
        });

        this.markers.push(marker);
      });
    },

    // 마커 초기화
    clearMarkers:function() {
      this.markers.forEach(m => m.setMap(null));
      this.markers = [];
    }

  } // end map1

  $(function(){
    map1.init();
  });
</script>

<div class="col-sm-10">
  <h2>Map1</h2>
  <h5 id="latlng"></h5>
  <h3 id="addr1"></h3>
  <h3 id="addr2"></h3>
  <button id="btn1" class="btn btn-primary">병원</button>
  <button id="btn2" class="btn btn-primary">편의점</button>
  <div id="map1"></div>
</div>
