class @NewReviewPopupContent extends FullscreenPopupContent
  recalc_layout: ->
    direction = lib.data.get("review-popup-direction")
    offset_x = lib.data.get("review-popup-offset-x")
    offset_y = lib.data.get("review-popup-offset-y")

    css = {}
    switch direction
      when NineWayDirection.top_left, NineWayDirection.top_center, NineWayDirection.top_right
        css.marginTop = 0
      when NineWayDirection.middle_left, NineWayDirection.middle_center, NineWayDirection.middle_right
        css.marginTop = ($(window).height() - @content.height()) * 0.5
      when NineWayDirection.bottom_left, NineWayDirection.bottom_center, NineWayDirection.bottom_right
        css.marginTop = $(window).height() - @content.height()

    switch direction
      when NineWayDirection.top_left, NineWayDirection.middle_left, NineWayDirection.bottom_left
        css.marginLeft = 0
      when NineWayDirection.top_center, NineWayDirection.middle_center, NineWayDirection.bottom_center
        css.marginLeft = css.marginRight = "auto"
      when NineWayDirection.top_right, NineWayDirection.middle_right, NineWayDirection.bottom_right
        css.marginRight = 0

    css.left = offset_x
    css.top = offset_y

    @content.css(css)