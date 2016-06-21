$ ->
  productForm = $("#product_form")
  addBusketBtn = $("#add_product_btn")
  productsList = $("#products_list")

  addBusketBtn.on 'click', (e) ->
    e.preventDefault()
    productForm.show()
    productForm.find(".cancel-btn").one 'click', ->
      productForm.hide()
    false

  productForm.on 'ajax:success', (e, data, status, xhr) ->
    App.utils.successMessage(data?.message)
    productsList.append App.utils.render('product', data.product)
    productForm.hide()

  productForm.on 'ajax:error', App.utils.ajaxErrorHandler

  productsList.on 'ajax:success', '.delete-product-link', (e, data) ->
    App.utils.successMessage(data?.message)
    $(e.target).closest('.collection-item')?.remove()

  productsList.on 'ajax:error', '.delete-product-link', App.utils.ajaxErrorHandler