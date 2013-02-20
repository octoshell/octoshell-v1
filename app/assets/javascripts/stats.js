window.series = {}

Highcharts.render = function(selector, type, series) {
  var plotOptions;
  if (type == 'column') {
    plotOptions = {
      column: {
        dataLabels: {
          enabled: true,
          formatter: function() {
            if (this.y > 0) {
              return this.y
            } else {
              return ''
            }
          }
        }
      }
    }
  } else if (type == 'pie') {
    plotOptions = {
      pie: {
        allowPointSelect: true,
        cursor: 'pointer',
        dataLabels: {
          enabled: true,
          color: '#000000',
          connectorColor: '#000000',
          formatter: function() {
            return '' + this.y + ' (' + this.percentage.toFixed(1) +'%)';
          }
        }
      }
    }
  }
  var categories = [];
  for (i in series) {
    categories.push(series[i].name)
  };
  new Highcharts.Chart({
    chart: {
      renderTo: selector,
      type: type
    },
    title: { text: '' },
    xAxis: {
      categories: [''],
      labels: {
        style: {
          fontSize: '11px',
          fontFamily: 'Verdana, sans-serif'
        }
      }
    },
    yAxis: { title: { text: 'Количество' } },
    plotOptions: plotOptions,
    legend: false,
    series: series
  });
};
