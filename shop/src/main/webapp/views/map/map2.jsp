<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style>
  #map{
    width:auto;
    height:400px;
    border: 2px solid blue;
  }
  #content{
    margin-top: 83px;
    width:auto;
    height:400px;
    border: 2px solid red;
    overflow: auto;
  }
</style>
<script>
  let map2={
    // 각 버튼이 클릭되면 해당 지역으로 포커스됨--%>
    init:function(){
      // 버튼클릭 전 서울을 먼저 뿌린다--%>
      this.makeMap(37.565925, 126.976808, '서울시청', 's1.jpg', 100);
      // 100 : 남산 주변 맛집 요청할때 100번이라하면 남산 주변 맛집을 가져옴--%>

      // 37.538453, 127.053110
      $('#sbtn').click(()=>{
        this.makeMap(37.565925, 126.976808, '서울시청', 's1.jpg', 100);
      });
      // 35.170594, 129.175159
      $('#bbtn').click(()=>{
        this.makeMap(35.170594, 129.175159, '해운대', 's2.jpg', 200);
      });
      // 33.250645, 126.414800
      $('#jbtn').click(()=>{
        this.makeMap(33.250645, 126.414800, '중문', 's3.jpg', 300);
      });
    },
    makeMap:function(lat, lng, title, imgName, target){
      let mapContainer = document.getElementById('map');
      let mapOption = {
        center: new kakao.maps.LatLng(lat, lng),
        level: 7
      }
      let map = new kakao.maps.Map(mapContainer, mapOption);
      let mapTypeControl = new kakao.maps.MapTypeControl();
      map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);
      let zoomControl = new kakao.maps.ZoomControl();
      map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);

      // Marker 생성
      let markerPosition  = new kakao.maps.LatLng(lat, lng);
      let marker = new kakao.maps.Marker({
        position: markerPosition,
        map:map
      });

      // Infowindow
      let iwContent = '<p>'+title+'</p>';
      // 작은따옴표 안에 큰따옴표 들어간다--%>
      iwContent += '<img src="<c:url value="/img/'+imgName+'"/> " style="width:80px;">';
      let infowindow = new kakao.maps.InfoWindow({
        content : iwContent
      });

      // Event
      kakao.maps.event.addListener(marker, 'mouseover', function(){
        infowindow.open(map, marker);
      });
      kakao.maps.event.addListener(marker, 'mouseout', function(){
        infowindow.close();
      });
      kakao.maps.event.addListener(marker, 'click', function(){
        location.href='<c:url value="/cust/get"/> '
        //   지도가 먼저 그려진다음 마커가 형성된다--%>
      });


      // 지도와 더불어 데이터를 요청했음
      // this.makeMarkers(map, target);
      this.getData(map, target);
    },
    getData:function(map, target) {
      $.ajax({
        url:'/getmarkers',
        // object type으로 보냄
        data:{target:target},
        // 데이터면 결과가 내려온다
        success:(datas)=>{
          this.makeMarkers(map, datas);
        }
      });
    },
    makeMarkers:function(map, datas){
// marker의 이미지(기본적인 이미지는 하늘색)--%>
     let imgSrc1 = 'https://t1.daumcdn.net/localimg/localimages/07/2012/img/marker_p.png';
     let imgSrc2 = '<c:url value="/img/down.jpg"/>';

     let result = '';

   // 배열을 돌리면서 지도에 마커를 뿌린다--%>
      $(datas).each((index,item)=>{ // start for
        let imgSize = new kakao.maps.Size(30,30);
        let markerImg = new kakao.maps.MarkerImage(imgSrc2, imgSize);
        let markerPosition = new kakao.maps.LatLng(item.lat, item.lng);
        let marker = new kakao.maps.Marker({
          image: markerImg,
          map:map,
          position: markerPosition
        });

        let iwContent = '<p>'+item.title+'</p>';
        iwContent += '<img style="width:80px;" src="<c:url value="/img/'+item.img+'"/> ">';
        // 인포윈도우 설정
        let infowindow = new kakao.maps.InfoWindow({
          content : iwContent,
        });
        // 세개의 이벤트 추가
        kakao.maps.event.addListener(marker, 'mouseover', function() {
          infowindow.open(map, marker);
        });
        kakao.maps.event.addListener(marker, 'mouseout', function() {
          infowindow.close();
        });
        kakao.maps.event.addListener(marker, 'click', function() {
        // 127.0.0.1/map/go
          location.href = '<c:url value="/map/go?target='+item.target+'"/>';
        });

        result += '<p>';
        result += '<a href="<c:url value="/map/go?target='+item.target+'"/>">';
        result += '<img width="20px" src="<c:url value="/img/'+item.img+'"/> ">';
        result += item.target+' '+item.title;
        result += '</a>';
        result += '</p>';

      }); //end for

      $('#content').html(result);


    } // end makeMarkers
  }

  $(function(){
    map2.init();
  })
</script>
<div class="col-sm-10">
  <div class="row">
    <div class="col-sm-8">
      <h2>Map2</h2>
      <button id="sbtn" class="btn btn-primary">Seoul</button>
      <button id="bbtn" class="btn btn-primary">Busan</button>
      <button id="jbtn" class="btn btn-primary">Jeju</button>
      <div id="map"></div>
    </div>
    <div class="col-sm-4">
      <div id="content"></div>
    </div>
  </div>
<%--  지도 이동 : 각지점으로 이동하고 센터에다 마커를 붙임 향후에 지도 주변에 맛집, 숙박업소 등 꾸미는 것 할거임--%>


</div>