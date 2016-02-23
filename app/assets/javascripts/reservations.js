// function unavailable(date) {
//     dmy = date.getDate() + "-" + (date.getMonth()+1) + "-" + date.getFullYear();
//     return [$.inArray(dmy, unavailableDates) == -1];
//   }

//   $(function() {

//     unavailableDates = [];

//     $.ajax({
//       url: '/preload',
//       data: {'vehicle_id': '1'},
//       dataType: 'json',
//       success: function(data) {

//         $.each(data, function(arrID, arrValue) {
//           for(var d = new Date(arrValue.start_date); d <= new Date(arrValue.end_date); d.setDate(d.getDate() + 1)) {
//             console.log(d);
//             unavailableDates.push($.datepicker.formatDate('dd-mm-yy', d));
//           };
//         });
//         console.log(unavailableDates);
//         $('#reservation_start_date').datepicker({
//           dateFormat: 'dd-mm-yy',
//           minDate: 0,
//           maxDate: '3m',
//           beforeShowDay: unavailable,
//           onSelect: function(selected) {
//             $('#reservation_end_date').datepicker("option", "minDate", selected);
//             $('#reservation_end_date').attr('disabled', false);
//           }
//         });

//         $('#reservation_end_date').datepicker({
//           dateFormat: 'dd-mm-yy',
//           minDate: 0,
//           maxDate: '3m',
//           beforeShowDay: unavailable,
//           onSelect: function(selected) {
//             $('#reservation_start_date').datepicker("option", "maxDate", selected);
//           }
//         });
//       }
//     });
//   });
