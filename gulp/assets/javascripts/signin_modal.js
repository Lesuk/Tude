jQuery(document).ready(function($){
  var $form_modal = $('.container__signin-modal'),
      $form_login = $form_modal.find('#user-form__signin-block'),
      $form_signup = $form_modal.find('#user-form__signup-block'),
      $form_modal_tab = $('.user-form__switcher'),
      $tab_login = $form_modal_tab.children('li').eq(0).children('a'),
      $tab_signup = $form_modal_tab.children('li').eq(1).children('a'),
      $btn_login = $('.btn-signin'),
      $btn_signup = $('.btn-register');

  $btn_login.on('click', function(event){
    $form_modal.addClass('is-visible');
    login_selected();
  });
  
  $btn_signup.on('click', function(event){
    $form_modal.addClass('is-visible');
    signup_selected();
  });

  $('.container__signin-modal').on('click', function(event){
    if( $(event.target).is($form_modal) || $(event.target).is('.user-form__close') ){
      $form_modal.removeClass('is-visible');
    }
  });

  // switch from a tab to another
  $form_modal_tab.on('click', function(event){
    event.preventDefault();
    ( $(event.target).is($tab_login) ) ? login_selected() : signup_selected();
  });

  function login_selected(){
    $form_login.addClass('is-selected');
    $form_signup.removeClass('is-selected');
    $tab_login.addClass('is-active');
    $tab_signup.removeClass('is-active');
  }
  function signup_selected(){
    $form_login.removeClass('is-selected');
    $form_signup.addClass('is-selected');
    $tab_login.removeClass('is-active');
    $tab_signup.addClass('is-active');
  }
});