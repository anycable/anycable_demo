$ ->
  basketForm = $("#basket_form")
  addBusketBtn = $("#add_basket_btn")
  basketsList = $("#baskets_list")

  addBusketBtn.on 'click', (e) ->
    e.preventDefault()
    basketForm.show()
    basketForm.find(".cancel-btn").one 'click', ->
      basketForm.hide()
    false

  basketForm.on 'ajax:success', (e, data, status, xhr) ->
    App.utils.successMessage(data?.message)
    basketsList.append App.utils.render('basket', data.basket)
    basketForm.hide()

  basketForm.on 'ajax:error', App.utils.ajaxErrorHandler

  basketsList.on 'ajax:success', '.delete-basket-link', (e, data) ->
    App.utils.successMessage(data?.message)
    $(e.target).closest('.basket')?.remove()

  basketsList.on 'ajax:error', '.delete-basket-link', App.utils.ajaxErrorHandler