$('.comments__box').on( 'keyup', 'textarea', function (){
    $(this).height( 0 );
    $(this).height( this.scrollHeight );
    if (this.scrollHeight >= 350){
      $(this).css("overflow-y", "auto");
    }
});
$('.comments__box').find( 'textarea' ).keyup();