$ ->
  basketForm = $("#basket_form")
  addBusketBtn = $("#add_basket_btn")
  basketsList = $("#baskets_list")

  basketsChannel = App.cable.subscriptions.create 'BasketsChannel', BasketsChannel

  basketsChannel.handle_message = (type, data) ->
    switch type
      when 'destroy' then $("#basket_#{data.id}").remove()
      when 'create' then addBasket(data)
      when 'products-update' then updateProductCount(data)

  addBasket = (data) ->
    return if $("#basket_#{data.id}")[0]
    basketsList.empty() unless basketsList.find('.basket').length
    basketsList.append App.utils.render('basket', data)

  updateProductCount = (data) ->
    basket = basketsList.find("#basket_#{data.basket_id}")
    return unless basket
    badge = basket.find('.badge')
    badge.text data.count

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
