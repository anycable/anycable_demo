$ ->
  basketForm = $("#basket_form")
  addBusketBtn = $("#add_basket_btn")
  basketsList = $("#baskets_list")

  basketsChannel = App.cable.subscriptions.create 'BasketsChannel', BasketsChannel

  basketsChannel.handle_message = (type, data) ->
    if type is 'destroy'
      $("#basket_#{data.id}").remove()
    else if type is 'create'
      addBasket(data)

  addBasket = (data) ->
    return if $("#basket_#{data.id}")[0]
    basketsList.empty() unless basketsList.find('.basket').length
    basketsList.append App.utils.render('basket', data)

  addBusketBtn.on 'click', (e) ->
    e.preventDefault()
    basketForm.show()
    basketForm.find(".cancel-btn").one 'click', ->
      basketForm.hide()
    false

  basketForm.on 'ajax:success', (e, data, status, xhr) ->
    App.utils.successMessage(data?.message)
    addBasket(data.basket)
    basketForm.hide()

  basketForm.on 'ajax:error', App.utils.ajaxErrorHandler

  basketsList.on 'ajax:success', '.delete-basket-link', (e, data) ->
    App.utils.successMessage(data?.message)
    $(e.target).closest('.basket')?.remove()

  basketsList.on 'ajax:error', '.delete-basket-link', App.utils.ajaxErrorHandler