// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery.ui.all
//= require twitter/bootstrap
//= require_tree .

$(document).ready(function(){
  $('.datepicker1').datepicker({
    altFormat: 'yy, mm, dd',
    dateFormat: 'dd-mm-yy',
    altField: "#patent_created_at"
  });
  $('.datepicker2').datepicker({
    altFormat: 'yy, mm, dd',
    dateFormat: 'dd-mm-yy',
    altField: "#patent_updated_at"
  });
  $('.datepicker1').keyup(function(){
    if($(this).val().length == 0){
      $('#patent_created_at').val('');
    }
  });
  $('.datepicker2').keyup(function(){
    if($(this).val().length == 0){
      $('#patent_updated_at').val('');
    }
  });
  
});
