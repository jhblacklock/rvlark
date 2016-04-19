$(window).ready(function(){
  $("#location").geocomplete({
    details: "#location-search",
    country: "US",
    types: ['(regions)'],
  });
});
