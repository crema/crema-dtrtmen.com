class ReviewsNewState
  on_enter: (old_state_name, args) ->
    if $("#require-login").length > 0
      app.login.required()
      return

    $no_pending_reviews = $("#no-pending-reviews")
    if $no_pending_reviews.length > 0
      if $no_pending_reviews.data("alert")
        alert("작성할 리뷰가 없습니다.")
      app.window.close_popup_once("system", "no_pending_reviews")
      return

    if @_is_fullscreen_popup()
      $fullscreen_popup = $(".fullscreen_popup")
      fullscreen_popup_content = new NewReviewPopupContent($fullscreen_popup)
      fullscreen_popup_content.recalc_layout()
      app.window.post "onload"
    else
      $(window).load ->
        $review_container = $("#review-container")
        app.window.post "init_popup", {
          width: $review_container.innerWidth(),
          height: $review_container.innerHeight(),
          direction: lib.data.get("review-popup-direction"),
          offset_x: lib.data.get("review-popup-offset-x"),
          offset_y: lib.data.get("review-popup-offset-y")
        }

    @bind_scroll(args.elements.find("#lista"))

    $form = args.elements.find("form#new_review")
    $review_option_fields = $form.find(".review-option-fields")
    if $review_option_fields.length > 0
      $form.find("textarea").one "focus", ->
        $review_option_fields.css(marginTop: -($review_option_fields.height() + 15), opacity: 0, display: "block")
        if Modernizr.cssanimations
          setTimeout (->
            $review_option_fields.addClass("anim")
            $review_option_fields.css(marginTop: 0)
            setTimeout (->
              $review_option_fields.css(opacity: 1)
              ), 200
            ), 0
        else
          setTimeout (->
            $review_option_fields.animate {marginTop: 0}, 200, lib.animation.ease_out
            setTimeout (->
              $review_option_fields.animate {opacity: 1}, 200, lib.animation.ease_out
              ), 200
            ), 0
        lib.animation.animate($form.addClass("show-nonmember-review"))

    if $("form").data("already-posted") == true
      if !confirm("이미 리뷰를 작성한 상품입니다. 리뷰를 한개 더 작성하시겠습니까?")
        app.window.close_popup_once("user", "already_posted")
        return

  _is_fullscreen_popup: ->
    lib.data.get("review-popup-fullscreen")

  bind_scroll: ($list) ->
    $list.als
      visible_items: 2
      scrolling_items: 2
      orientation: "vertical"
      circular: "no"
      autoscroll: "no"

app.reviews_new_state = new ReviewsNewState
