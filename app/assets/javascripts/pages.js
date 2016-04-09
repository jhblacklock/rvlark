$(window).ready(function(){
  $("#location").geocomplete({
    details: "#location-search",
    country: "US",
    types: ['(regions)'],
  });
  // var nowTemp = new Date();
  // var now = new Date(nowTemp.getFullYear(), nowTemp.getMonth(), nowTemp.getDate(), 0, 0, 0, 0);
  // var checkin = $('#checkin, #pickup').datepicker({
  //   dateFormat: 'mm/dd/y',
  //   minDate: 0,
  //   onRender: function(date) {
  //     return date.valueOf() < now.valueOf() ? 'disabled' : '';
  //   }
  // }).on('changeDate', function(ev) {
  //   if (ev.date.valueOf() > checkout.date.valueOf()) {
  //     var newDate = new Date(ev.date)
  //     newDate.setDate(newDate.getDate() + 1);
  //     checkout.setValue(newDate);
  //   }
  //   checkin.hide();
  //   $('#checkout')[0].focus();
  // }).data('datepicker');
  // var checkout = $('#checkout, #dropoff').datepicker({
  //   dateFormat: 'mm/dd/y',
  //   minDate: 0,
  //   onRender: function(date) {
  //     return date.valueOf() <= checkin.date.valueOf() ? 'disabled' : '';
  //   }
  // }).on('changeDate', function(ev) {
  //   checkout.hide();
  // }).data('datepicker');
});
