window.Xiang =
  showTooltip: ->
    $('[rel=tooltip]').tooltip('show')
  hideTooltip: ->
    $('[rel=tooltip]').tooltip('hide')
  enableTooltip : ->
    $('[rel=tooltip]').tooltip()
  toggleUserTooltip: ->
    $('#user_tooltip').toggle()

  preview: ->
    content_box = $('.content')
    preview_box = content_box.find('#preview')
    textarea = content_box.find('textarea')
    textarea.hide()
    if preview_box.length == 0
      textarea.after $('<div/>', { id: 'preview' })
      preview_box = content_box.find('#preview')
    $("#preview").text "Loading..."
    $.post "/posts/preview",
      "content": textarea.val(),
      (data) ->
        preview_box.html data.content
        preview_box.show()
        Xiang.enableTooltip()
      "json"
  editing: ->
    content_box = $('.content')
    preview_box = content_box.find('#preview')
    textarea = content_box.find('textarea')
    preview_box.hide()
    textarea.show()

  initPreview: ->
    preview_btn = $('.js-preview')
    preview_btn.live 'click', ->
      if $('.content').find('#preview').is(':visible')
        Xiang.editing()
        preview_btn.html '预览'
      else
        Xiang.preview()
        preview_btn.html '编辑'
  initCreate: ->
    post_form = $('.new-post form')
    $('.js-publish').live 'click', ->
      post_form.submit()

  # 往编辑器里面插入图片代码
  appendImageFromUpload : (srcs) ->
    post_content_box = $('.js-post-content')
    caret_pos = post_content_box.caretPos()
    src_merged = ""
    for src in srcs
      src_merged = "![](#{src})\n"
    source = post_content_box.val()
    before_text = source.slice(0, caret_pos)
    post_content_box.val(before_text + src_merged + source.slice(caret_pos+1, source.count))
    post_content_box.caretPos(caret_pos+src_merged.length)
    post_content_box.focus()


  # 上传图片
  initUploader : () ->
    $(".js-images").live "click", () ->
      $(".js-upload-images").click()
      return false

    opts =
      url : "/photos"
      type : "POST"
      beforeSend : () ->
        $(".js-images").html('上传中...')
      success : (result, status, xhr) ->
        $(".js-images").html('相片')
        Xiang.appendImageFromUpload([result])

    $(".js-upload-images").fileUpload opts
    return false

  # 客户端草稿
  initClientSideDrafts : () ->
    $('.new-post form').sisyphus
      timeout : 2
    $('form .js-reset').click ->
       $('form')[0].reset()
      $.sisyphus().manuallyReleaseData()

  initDatepicker : ->
    datepickerOptions = 
      format: 'yyyy-mm-dd',
      weekStart: 1,
      todayBtn: true,
      todayHighlight: true,
      language: 'zh-CN'
    $('#datepicker').datepicker(datepickerOptions)

  initElastic: ->
    elasticOptions =
      node: $('#post_content')[0],
      horz: true
    new ElasticText(elasticOptions) 


$(document).ready ->
  Xiang.enableTooltip()
