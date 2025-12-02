<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
  #container1{
    width: 300px;
    border: 2px solid red;
  }
  #container2{
    width: 300px;
    border: 2px solid blue;
  }

  /* 슬라이더 컨트롤 스타일 */
  #sliders {
    margin-top: 20px;
    padding: 15px;
    border: 1px solid #ddd;
    border-radius: 5px;
    background-color: #f9f9f9;
  }

  .slider-group {
    margin-bottom: 10px;
  }

  .slider-group label {
    display: inline-block;
    width: 80px;
    font-weight: bold;
  }

  .slider-group input[type="range"] {
    width: 200px;
    margin: 0 10px;
  }

  .slider-group span {
    display: inline-block;
    width: 40px;
    text-align: center;
    font-weight: bold;
    color: #007bff;
  }
</style>

<script>
  chart3={
    chart: null, // 차트 객체를 저장할 변수
    init:function(){
      this.getSumData();
      this.getAvgData();
    },
    getSumData:function(){
      $.ajax({
        url:'<c:url value="/chart3_category_Sum"/>',
        success:(data)=> {
          this.getChartSum(data);
        }
      });
    },
    getAvgData:function(){
      $.ajax({
        url:'<c:url value="/chart3_category_Avg"/>',
        success:(data)=> {
          this.getChartAvg(data);
        }
      });
    },
    getChartSum:function(data){
      this.chart = new Highcharts.Chart({
        chart: {
          renderTo: 'container1',
          type: 'column',
          options3d: {
            enabled: true,
            alpha: 15,
            beta: 15,
            depth: 50,
            viewDistance: 25
          }
        },
        xAxis: {
          categories: data.categories,  // 수정: data 대신 data.categories
          title: {
            text: '월'
          }
        },
        yAxis: {
          title: {
            text: '매출 합계 (원)'
          }
        },
        tooltip: {
          headerFormat: '<b>{point.key}</b><br>',
          pointFormat: '{series.name}: <b>{point.y:,.0f}원</b><br>'
        },
        title: {
          text: '카테고리별 월 매출 합계'
        },
        subtitle: {
          text: '3D Column Chart'
        },
        legend: {
          enabled: true  // 카테고리별이므로 범례 필요
        },
        plotOptions: {
          column: {
            depth: 25
          }
        },
        series: data.series  // 수정: data 대신 data.series
      });
      this.showValues();
      this.attachSliderEvents();
    }, // end getChartSum
    showValues:function(){
      document.getElementById('alpha-value').innerHTML = this.chart.options.chart.options3d.alpha;
      document.getElementById('beta-value').innerHTML = this.chart.options.chart.options3d.beta;
      document.getElementById('depth-value').innerHTML = this.chart.options.chart.options3d.depth;
    },
    attachSliderEvents:function(){
      // Activate the sliders
      document.querySelectorAll('#sliders input').forEach(input => input.addEventListener('input', e => {
        this.chart.options.chart.options3d[e.target.id] = parseFloat(e.target.value);
        this.showValues();
        this.chart.redraw(false);
      }));
    },
    getChartAvg:function(data){
      Highcharts.chart('container2', {
        title: {
          text: '카테고리별 월 매출 평균',
          align: 'left'
        },
        subtitle: {
          text: 'Multi-Line Chart',
          align: 'left'
        },
        yAxis: {
          title: {
            text: '평균 매출 (원)'
          }
        },
        xAxis: {
          categories: data.categories,  // 배열에서 직접 사용
          title: {
            text: '월'
          }
        },
        tooltip: {
          headerFormat: '<b>{point.key}</b><br>',
          pointFormat: '{series.name}: <b>{point.y:,.0f}원</b><br>'
        },
        legend: {
          layout: 'vertical',
          align: 'right',
          verticalAlign: 'middle'
        },
        plotOptions: {
          series: {
            label: {
              connectorAllowed: false
            }
          }
        },
        series: data.series  // 배열에서 직접 사용
      });
    }
  }
  $(()=>{
    chart3.init();
  });
</script>

<div class="col-sm-10">
  <h2>Chart3</h2>
  <div class="row">
    <div class="col-sm-6" id="container1"></div>
    <div class="col-sm-6" id="container2"></div>
  </div>

  <!-- 3D 차트 조작 슬라이더 추가 -->
  <div id="sliders">
    <h5>3D Chart Controls</h5>
    <div class="slider-group">
      <label for="alpha">Alpha:</label>
      <input id="alpha" type="range" min="0" max="45" value="15" step="1">
      <span id="alpha-value">15</span>
    </div>
    <div class="slider-group">
      <label for="beta">Beta:</label>
      <input id="beta" type="range" min="-45" max="45" value="15" step="1">
      <span id="beta-value">15</span>
    </div>
    <div class="slider-group">
      <label for="depth">Depth:</label>
      <input id="depth" type="range" min="20" max="100" value="50" step="1">
      <span id="depth-value">50</span>
    </div>
    <div style="margin-top: 10px; font-size: 12px; color: #666;">
      <strong>Alpha:</strong> 상하 회전각도 | <strong>Beta:</strong> 좌우 회전각도 | <strong>Depth:</strong> 3D 깊이
    </div>
  </div>
</div>
