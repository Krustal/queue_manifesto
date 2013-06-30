$(function(){
  function primary_element(fk){
    var type_class = ["record-type-", fk.data('fk_type')].join(''),
        pk_val = ["[data-pk='", fk.data('fk_points'), "']"].join(''),
        selector = ['tbody.', type_class, pk_val].join(''),
        elem = $(selector);
    return elem;
  }
  $('td.foreign-key').on({
    mouseenter: function(e){
      primary_element($(this)).addClass('highlighted');
    },
    mouseleave: function(e){
      primary_element($(this)).removeClass('highlighted');
    }
  });
});