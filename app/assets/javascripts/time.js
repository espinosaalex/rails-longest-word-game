
document.addEventListener("turbolinks:load", function(){
  if ($('form').length === 0) return;

  var start = Date.now();

  $('form').on('submit', function(){
    var end = Date.now();
    var time = end - start;
    $('#time').val(time);
  })
})
