$('.sub-comment__reply-field').on( 'keyup', 'textarea', function (){
    $(this).height( 0 );
    $(this).height( this.scrollHeight );
});
$('.sub-comment__reply-field').find( 'textarea' ).keyup();