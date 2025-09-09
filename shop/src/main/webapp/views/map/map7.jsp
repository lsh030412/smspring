<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
  #map {
    width: 100%;
    height: 400px;
    border: 2px solid red;
    border-radius: 8px;
  }
  /* 오버레이 전용 스타일 */
  .overlaybox {
    position: relative;
    width: 200px;
    border: 1px solid #ccc;
    background: #fff;
    border-radius: 6px;
    font-size: 13px;
    line-height: 1.4;
    box-shadow: 0 2px 5px rgba(0,0,0,0.2);
  }
  .overlaybox .boxtitle {
    background: #333;
    color: #fff;
    font-weight: bold;
    text-align: center;
    padding: 6px;
    border-radius: 6px 6px 0 0;
  }
  .overlaybox .first {
    display: flex;
    align-items: center;
    padding: 8px;
    background: #f7f7f7;
    border-bottom: 1px solid #eee;
  }
  .overlaybox .triangle {
    width: 24px; height: 24px;
    border-radius: 50%;
    background: crimson;
    color: #fff;
    display: flex; align-items: center; justify-content: center;
    font-weight: bold;
    margin-right: 8px;
  }
  .overlaybox ul {
    margin: 0; padding: 0; list-style: none;
  }
  .overlaybox ul li {
    display: flex;
    justify-content: space-between;
    padding: 6px 8px;
    border-bottom: 1px solid #eee;
  }
  .overlaybox ul li:last-child {
    border-bottom: none;
  }
  .overlaybox .number {
    font-weight: bold;
    margin-right: 6px;
  }
  .overlaybox .arrow.up::after {
    content: "▲"; color: green; margin-left: 4px;
  }
  .overlaybox .arrow.down::after {
    content: "▼"; color: red; margin-left: 4px;
  }
</style>

<script>
  let map = {
    kMap: null,

    init: function () {
      const mapContainer = document.getElementById('map');
      const mapOption = {
        center: new kakao.maps.LatLng(37.502, 127.026581),
        level: 4
      };
      this.kMap = new kakao.maps.Map(mapContainer, mapOption);

      // 오버레이 콘텐츠 (HTML 문자열)
      const content =
              '<div class="overlaybox">' +
              '  <div class="boxtitle">금주 영화순위</div>' +
              '  <div class="first">' +
              '    <div class="triangle text">1</div>' +
              '    <div class="movietitle text">드래곤 길들이기2</div>' +
              '  </div>' +
              '  <ul>' +
              '    <li class="up">' +
              '      <span class="number">2</span>' +
              '      <span class="title">명량</span>' +
              '      <span class="arrow up"></span>' +
              '      <span class="count">2</span>' +
              '    </li>' +
              '    <li>' +
              '      <span class="number">3</span>' +
              '      <span class="title">해적(바다로 간 산적)</span>' +
              '      <span class="arrow up"></span>' +
              '      <span class="count">6</span>' +
              '    </li>' +
              '    <li>' +
              '      <span class="number">4</span>' +
              '      <span class="title">해무</span>' +
              '      <span class="arrow up"></span>' +
              '      <span class="count">3</span>' +
              '    </li>' +
              '    <li>' +
              '      <span class="number">5</span>' +
              '      <span class="title">안녕, 헤이즐</span>' +
              '      <span class="arrow down"></span>' +
              '      <span class="count">1</span>' +
              '    </li>' +
              '  </ul>' +
              '</div>';

      // 오버레이 위치
      const position = new kakao.maps.LatLng(37.49887, 127.026581);

      // 커스텀 오버레이 생성
      const customOverlay = new kakao.maps.CustomOverlay({
        position: position,
        content: content,
        xAnchor: 0.3,
        yAnchor: 0.91
      });

      // 지도에 표시
      customOverlay.setMap(this.kMap);
    }
  };

  document.addEventListener("DOMContentLoaded", function () {
    map.init();
  });
</script>

<div class="col-sm-10">
  <h2>Map7 : 커스텀 오버레이</h2>
  <div id="map"></div>
</div>