/*
 *
 * login-register modal
 * Autor: Creative Tim
 * Web-autor: creative.tim
 * Web script: http://creative-tim.com
 *
 */
function showRegisterForm(){
  $('.loginBox').fadeOut('fast',function(){
      $('.registerBox').fadeIn('fast');
      $('.login-footer').fadeOut('fast',function(){
          $('.register-footer').fadeIn('fast');
      });
      $('.modal-title').html('Sign up with');
  });
  $('.error').removeClass('alert alert-danger').html('');
}

function showLoginForm(){
  $('#loginModal .registerBox').fadeOut('fast',function(){
    $('.loginBox').fadeIn('fast');
    $('.register-footer').fadeOut('fast',function(){
        $('.login-footer').fadeIn('fast');
    });

    $('.modal-title').html('Login with');
  });
   $('.error').removeClass('alert alert-danger').html('');
}

function openLoginModal(){
  showLoginForm();
  setTimeout(function(){
    $('#loginModal').modal('show');
  }, 230);
}

function openRegisterModal(){
  showRegisterForm();
  setTimeout(function(){
    $('#loginModal').modal('show');
  }, 230);

}

function error(){
  $('.error').addClass('alert alert-danger').html("Invalid email/password");
  $('input[type="password"]').val('');
}

$(function(){

  $('.loginBox form').on('ajax:complete', function(){
   // shakeModal();
  })
  $('.login-link').on('click', function(){
      openLoginModal();
  });

  $('.register-link').on('click', function(){
      openRegisterModal();
  });

  $(document).on('submit', function(e) {
    $(this).find('.btn').attr('disabled', true);
  });


  $(document).on('submit', '#login_form', function(e) {
  }).on('ajax:success', '#login_form', function(e, data, status, xhr) {
    console.log(data);
    console.log(e);
    console.log(xhr);
    window.location.href = data;
  }).on('ajax:error', '#login_form', function(e, data, status, xhr) {
    error();
  });

  //app/assets/javascripts/application.js
  $(document).on('submit', '#signup_form', function(e){
  }).on('ajax:success', '#signup_form', function(e, data, status, xhr) {
      window.location.href = data;
  }).on('ajax:error', '#signup_form', function(e, data, status, xhr) {
     $(this).html(data.responseText);
     console.log('error');
  });
});