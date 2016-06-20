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

  basketsList.on 'ajax:error', '.delete-basket-link, .edit-basket-link', App.utils.ajaxErrorHandler

  basketsList.on 'click', '.edit-basket-link', (e) ->
    e.preventDefault()
    cont = $(e.target).closest('.basket')
    form = cont.find('.basket-edit-form')
    info = cont.find('.basket-info')

    info.hide()
    form.show()
    form.find('.cancel-btn').one 'click', ->
      form.hide()
      info.show()
      form.off('ajax:success ajax:error')

    form.one 'ajax:success', (e, data) ->
      App.utils.successMessage(data?.message)
      cont.replaceWith App.utils.render('basket', data.basket)

    form.on 'ajax:error', App.utils.ajaxErrorHandler
