<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style>
  #container1{
    width:300px;
    border: 1px solid black;
  }
  #container2{
    width:300px;
    border: 1px solid red;
  }
  #container3{
    width:300px;
    border: 1px solid greenyellow;
  }
  #container4{
    width:300px;
    border: 1px solid darkgray;
  }
</style>
<script>
  chart2={
    init:function() {
      this.getdata1();
      this.getdata2();
      this.getdata3();
      this.getdata4();
    },
    getdata1:function() {
      $.ajax({
        url:'<c:url value="/chart2_1"/>',
        success:(data)=> {
          this.chart1(data);
        }
      });
    },
    getdata2:function() {
      $.ajax({
        url:'<c:url value="/chart2_2"/>',
        success:(data)=> {
          this.chart2(data);
        }
      });
    },
    getdata3:function() {
      $.ajax({
        url:'<c:url value="/chart2_3"/>',
        success:(data)=> {
          this.chart3(data);
        }
      });
    },
    getdata4:function() {
      $.ajax({
        url:'<c:url value="/chart2_4"/>',
        success:(data)=> {
          this.chart4(data);
        }
      });
    },
    chart1:function(data) {
      Highcharts.chart('container1', {
        chart: {
          type: 'pie',
          options3d: {
            enabled: true,
            alpha: 45
          }
        },
        title: {
          text: 'Beijing 2022 gold medals by country'
        },
        subtitle: {
          text: '3D donut in Highcharts'
        },
        plotOptions: {
          pie: {
            innerSize: 100,
            depth: 45
          }
        },
        series: [{
          name: 'Medals',
          data: data
        }]
      });
    },
    chart2:function(data) {
      Highcharts.chart('container2', {
        chart: {
          type: 'cylinder',
          options3d: {
            enabled: true,
            alpha: 15,
            beta: 15,
            depth: 50,
            viewDistance: 25
          }
        },
        title: {
          text: 'Number of confirmed COVID-19'
        },
        subtitle: {
          text: 'Source: ' +
                  '<a href="https://www.fhi.no/en/id/infectious-diseases/coronavirus/daily-reports/daily-reports-COVID19/"' +
                  'target="_blank">FHI</a>'
        },
        xAxis: {
          categories: data.cate,
          title: {
            text: 'Age groups'
          },
          labels: {
            skew3d: true
          }
        },
        yAxis: {
          title: {
            margin: 20,
            text: 'Reported cases'
          },
          labels: {
            skew3d: true
          }
        },
        tooltip: {
          headerFormat: '<b>Age: {category}</b><br>'
        },
        plotOptions: {
          series: {
            depth: 25,
            colorByPoint: true
          }
        },
        series: [{
          data: data.data,
          name: 'Cases',
          showInLegend: true
        }]
      });
    },
    chart3:function(txt) {
      const text = txt,
              lines = text.replace(/[():'?0-9]+/g, '').split(/[,\. ]+/g),
              data = lines.reduce((arr, word) => {
                let obj = Highcharts.find(arr, obj => obj.name === word);
                if (obj) {
                  obj.weight += 1;
                } else {
                  obj = {
                    name: word,
                    weight: 1
                  };
                  arr.push(obj);
                }
                return arr;
              }, []);

      Highcharts.chart('container3', {
        accessibility: {
          screenReaderSection: {
            beforeChartFormat: '<h5>{chartTitle}</h5>' +
                    '<div>{chartSubtitle}</div>' +
                    '<div>{chartLongdesc}</div>' +
                    '<div>{viewTableButton}</div>'
          }
        },
        chart: {
          zooming: {
            type: 'xy'
          },
          panning: {
            enabled: true,
            type: 'xy'
          },
          panKey: 'shift'
        },
        series: [{
          type: 'wordcloud',
          data,
          name: 'Occurrences'
        }],
        title: {
          text: 'Wordcloud of Alice\'s Adventures in Wonderland',
          align: 'left'
        },
        subtitle: {
          text: 'An excerpt from chapter 1: Down the Rabbit-Hole',
          align: 'left'
        },
        tooltip: {
          headerFormat: '<span style="font-size: 16px"><b>{point.name}</b>' +
                  '</span><br>'
        }
      });
    },
    chart4:function(data){
      Highcharts.chart('container4', {
        chart: {
          type: 'pie'
        },
        title: {
          text: 'Browser market shares. January, 2022'
        },
        subtitle: {
          text: 'Click the slices to view versions. Source: <a href="http://statcounter.com" target="_blank">statcounter.com</a>'
        },

        accessibility: {
          announceNewData: {
            enabled: true
          },
          point: {
            valueSuffix: '%'
          }
        },

        plotOptions: {
          pie: {
            borderRadius: 5,
            dataLabels: [{
              enabled: true,
              distance: 15,
              format: '{point.name}'
            }, {
              enabled: true,
              distance: '-30%',
              filter: {
                property: 'percentage',
                operator: '>',
                value: 5
              },
              format: '{point.y:.1f}%',
              style: {
                fontSize: '0.9em',
                textOutline: 'none'
              }
            }]
          }
        },

        tooltip: {
          headerFormat: '<span style="font-size:11px">{series.name}</span><br>',
          pointFormat: '<span style="color:{point.color}">{point.name}</span>: ' +
                  '<b>{point.y:.2f}%</b> of total<br/>'
        },

        series: [
          {
            name: 'Browsers',
            colorByPoint: true,
            data: data.data
          }
        ],
        drilldown: {
          series: [
            {
              name: '상의',
              id: '상의',
              data: [
                [
                  'v97.0',
                  36.89
                ],
                [
                  'v96.0',
                  18.16
                ],
                [
                  'v95.0',
                  0.54
                ],
                [
                  'v94.0',
                  0.7
                ],
                [
                  'v93.0',
                  0.8
                ],
                [
                  'v92.0',
                  0.41
                ],
                [
                  'v91.0',
                  0.31
                ],
                [
                  'v90.0',
                  0.13
                ],
                [
                  'v89.0',
                  0.14
                ],
                [
                  'v88.0',
                  0.1
                ],
                [
                  'v87.0',
                  0.35
                ],
                [
                  'v86.0',
                  0.17
                ],
                [
                  'v85.0',
                  0.18
                ],
                [
                  'v84.0',
                  0.17
                ],
                [
                  'v83.0',
                  0.21
                ],
                [
                  'v81.0',
                  0.1
                ],
                [
                  'v80.0',
                  0.16
                ],
                [
                  'v79.0',
                  0.43
                ],
                [
                  'v78.0',
                  0.11
                ],
                [
                  'v76.0',
                  0.16
                ],
                [
                  'v75.0',
                  0.15
                ],
                [
                  'v72.0',
                  0.14
                ],
                [
                  'v70.0',
                  0.11
                ],
                [
                  'v69.0',
                  0.13
                ],
                [
                  'v56.0',
                  0.12
                ],
                [
                  'v49.0',
                  0.17
                ]
              ]
            },
            {
              name: 'Safari',
              id: 'Safari',
              data: [
                [
                  'v15.3',
                  0.1
                ],
                [
                  'v15.2',
                  2.01
                ],
                [
                  'v15.1',
                  2.29
                ],
                [
                  'v15.0',
                  0.49
                ],
                [
                  'v14.1',
                  2.48
                ],
                [
                  'v14.0',
                  0.64
                ],
                [
                  'v13.1',
                  1.17
                ],
                [
                  'v13.0',
                  0.13
                ],
                [
                  'v12.1',
                  0.16
                ]
              ]
            },
            {
              name: 'Edge',
              id: 'Edge',
              data: [
                [
                  'v97',
                  6.62
                ],
                [
                  'v96',
                  2.55
                ],
                [
                  'v95',
                  0.15
                ]
              ]
            },
            {
              name: 'Firefox',
              id: 'Firefox',
              data: [
                [
                  'v96.0',
                  4.17
                ],
                [
                  'v95.0',
                  3.33
                ],
                [
                  'v94.0',
                  0.11
                ],
                [
                  'v91.0',
                  0.23
                ],
                [
                  'v78.0',
                  0.16
                ],
                [
                  'v52.0',
                  0.15
                ]
              ]
            }
          ]
        },

        navigation: {
          breadcrumbs: {
            buttonTheme: {
              style: {
                color: 'var(--highcharts-highlight-color-100)'
              }
            }
          }
        }
      });
    },

  }
  $(()=>{
    chart2.init();
  });
</script>
<div class="col-sm-10">
  <h2>Chart2</h2>
  <h5>Title description, Sep 2, 2017</h5>
  <div class="row">
    <div class="col-sm-6" id="container1"></div>
    <div class="col-sm-6" id="container2"></div>
  </div>
  <div class="row">
    <div class="col-sm-6" id="container3"></div>
    <div class="col-sm-6" id="container4"></div>
  </div>
</div>