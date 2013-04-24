// window.series = {}
// 
// Highcharts.render = function(selector, type, series) {
//   var tooltips = series[0].tooltips
//   var plotOptions;
//   if (type == 'column') {
//     plotOptions = {
//       column: {
//         dataLabels: {
//           enabled: true,
//           formatter: function() {
//             if (this.y > 0) {
//               return this.y
//             } else {
//               return ''
//             }
//           }
//         }
//       }
//     }
//   } else if (type == 'pie') {
//     plotOptions = {
//       pie: {
//         allowPointSelect: true,
//         cursor: 'pointer',
//         dataLabels: {
//           enabled: true,
//           color: '#000000',
//           connectorColor: '#000000',
//           formatter: function() {
//             return '' + this.y + ' (' + this.percentage.toFixed(1) +'%)';
//           }
//         }
//       }
//     }
//   }
//   var rotation = 0;
//   var align = 'center';
//   _(series[0].categories).each(function(category){
//     if (category.length > 5) {
//       rotation = -25
//       align = 'right'
//     }
//   })
//   
//   new Highcharts.Chart({
//     chart: {
//       renderTo: selector,
//       type: type
//     },
//     title: { text: '' },
//     xAxis: {
//       categories: series[0].categories,
//       labels: {
//         rotation: rotation,
//         align: align,
//         style: {
//           fontSize: '11px',
//           fontFamily: 'Verdana, sans-serif'
//         }
//       }
//     },
//     yAxis: { title: { text: 'Количество' } },
//     plotOptions: plotOptions,
//     legend: false,
//     tooltip: {
//       formatter: function() {
//         return tooltips[this.point.x]
//       }
//     },
//     series: series
//   });
// };
// 
// 
// $(function(){
//   $('a.chartable[data-toggle="tab"]').on('shown', function(e){
//     var div = $(e.target.hash)
//     var id = div.data('chart-container')
//     if ($("#" + id).is(':empty')) {
//       Highcharts.render(id, div.data('chart-type'), window.series[id])
//     }
//   })
// })