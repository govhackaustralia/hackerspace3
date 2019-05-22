jQuery(document).on 'turbolinks:load', ->
  bulk_mails = $('#correspondences')
  if bulk_mails.length > 0

    App.global_mail = App.cable.subscriptions.create {
        channel: "BulkMailsChannel"
        bulk_mail_id: bulk_mails.data('bulk-mail-id')
      },
      connected: ->
        # Called when the subscription is ready for use on the server

      disconnected: ->
        # Called when the subscription has been terminated by the server

      received: (data) ->
        $("[data-user-id=#{data['user_id']}]").html data['correspondence'];

      process_mail: (bulk_mail_id) ->
        @perform 'process_mail', bulk_mail_id: bulk_mail_id

  $('#process_mail').click (e) ->
    e.preventDefault()
    App.global_mail.process_mail bulk_mails.data('bulk-mail-id')
    $('#process_mail, #configure, #edit').hide()
    return false
