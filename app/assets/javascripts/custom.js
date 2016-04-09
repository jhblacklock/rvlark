$(document).ready(function() {
  var freeDays = [];
  // TODO: Get this
  var vehicle_id = '1';

  function initCal() {
    $("#calendar").datepicker({
      numberOfMonths: 2,
      dateFormat: 'mm/dd/y',
      minDate: 0,
      beforeShowDay: highlightDays,
      onChangeMonthYear: fetchFreeDays,
      onSelect: function(date, inst) {
        inst.inline = false;
        $(".ui-datepicker-calendar .ui-datepicker-current-day").removeClass("ui-datepicker-current-day").children()
          .removeClass("ui-state-active");
        $(".ui-datepicker-calendar TBODY A").each(function() {
          if ($(this).text() == inst.selectedDay && $(this).parent().data('month') == inst.selectedMonth) {
            var state;
            if($(this).parent().hasClass("ui-state-disabled")){
              state = 'available';
              $(this).parent().removeClass("ui-state-disabled");
            } else {
              state = 'unavailable';
              $(this).parent().addClass("ui-state-disabled available");
            }
            $.post('/vehicles/' + vehicle_id + '/reservations',
              { state: state, date: date }, function(data) {
            });
          }
        });
      }
    });
  }

  function fetchFreeDays(year, month) {
      var date = '',
        day = '1',
        vehicle_id = '1';

      if (year != undefined && month != undefined) {
        var date = day + '/' + month.toString() + '/' + year.toString();
      }
      $.get('/vehicles/' + vehicle_id + '/reservations/available?date=' + date, function(data) {
        $.each(data, function(index, value) {
          freeDays.push(value);
        });
        initCal();
      });
    }

  function highlightDays(date) {
      for (var i = 0; i < freeDays.length; i++) {
        if (freeDays[i].on_date.toString() == date.strftime('%Y-%m-%d')) {
          if (freeDays[i].state == 'unavailable') {
            return [true, 'ui-state-disabled available', 'Date not available']; // [0] = true | false if this day is selectable, [1] = class to add, [2] = tooltip to display
          }
          if (freeDays[i].state == 'booked') {
            return [true, 'ui-state-disabled booked', 'Date not available']; // [0] = true | false if this day is selectable, [1] = class to add, [2] = tooltip to display
          }
        }
      }
      return [true, ''];
    }

  $('#front-calendar').DOPFrontendBookingCalendarPRO({
    'reinitialize': true,
    'loadURL': '/vehicles/1/reservations/available',
    'sendURL': '/vehicles/1/reservations/book'
  });

  fetchFreeDays();

  var $pswp = $('.pswp')[0];
  var image = [];
  $('.picture').each(function() {
    var $pic = $(this),
      getItems = function() {
        var items = [];
        $pic.find('a').each(function() {
          var $href = $(this).attr('href'),
            $size = $(this).data('size').split('x'),
            $width = $size[0],
            $height = $size[1];
          var item = {
            src: $href,
            w: $width,
            h: $height
          }
          items.push(item);
        });
        return items;
      }
    var items = getItems();
    $.each(items, function(index, value) {
      image[index] = new Image();
      image[index].src = value['src'];
    });
    $pic.on('click', 'figure', function(event) {
      event.preventDefault();
      var $index = $(this).index();
      var options = {
        index: $index,
        bgOpacity: 0.7,
        showHideOpacity: true
      }
      var lightBox = new PhotoSwipe($pswp, PhotoSwipeUI_Default, items, options);
      console.log(lightBox);
      lightBox.init();
    });
  });
});