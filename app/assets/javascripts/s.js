$(document).ready(function() {
  $("#location-search").geocomplete({
    details: "#location-search",
    country: "US",
    types: ['(regions)'],
  }).bind("geocode:result", function(event, result){
    $('#search').submit();
  });

  $('[data-toggle=offcanvas]').click(function() {
    $('.row-offcanvas').toggleClass('active');
  });

  $('#pickup, #dropoff').on('input', function(){
    $('#search').submit();
  });

  $('#guests').on('change', function(){
    $('#search').submit();
  })

  $('#search input[type=checkbox]').on('change', function(){
    $('#search').submit();
  })

  $('#min-price, #max-price').on('change', function(){
    $('#search').submit();
  })

});
