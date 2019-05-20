//= require jquery
//= require jquery_ujs
//= require underscore/underscore
//= require vue/dist/vue
//= require toastr/toastr
//= require sortable/Sortable
//= require page/page
//= require autoNumeric/autoNumeric
//= require nested_form_fields

//= require core
//= require_directory .
//= require_tree ./parts
//= require_tree ./directives
//= require_tree ./mixins
//= require_tree ./components
//= require_tree ./filters

$(function() {
  $('.home__img_box__google').css('background-image', "url(" + $('.home__img_box__google').data('image') + ")");

  $(document).on('.home__img_box__google', 'focus', function() {
    this.css('background-image', "url(" + this.data('image-focus') + ")");
  })

  $(document).on('.home__img_box__google', 'blur', function() {
    this.css('background-image', "url(" + this.data('image') + ")");
  })

  $(document).on('.home__img_box__google', 'disabled', function() {
    this.css('background-image',  "url(" + this.data('image-disabled') + ")");
  })

  $(document).on('.home__img_box__google', 'enabled', function() {
    this.css('background-image',  "url(" + this.data('image') + ")");
  })

  $(document).on('.home__img_box__google', 'active', function() {
    this.css('background-image',  "url(" + this.data('image-active') + ")");
  })
})
