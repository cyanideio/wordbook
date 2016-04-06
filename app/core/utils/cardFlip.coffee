###*
* Flip the Card
* E as Event 
* component as jquery selector
* pageX and pageY for moving point
###

cardFlip = (selector)->
    # Global PageX & PageY for recording
    ANIMATING = false
    PageX = PageY = 0;
    ANIMATE_TIME = 500
    FLIP_EFFECT = 'ease-out'
    OFFSET = 20
    SWIP_RATIO = 0.5
    winHeight = window.innerHeight;
    ORIGIN_STYLE = 
        '-webkit-filter': 'brightness(1)'
        'box-shadow': '0 1px 1px rgba(0, 0, 0, 0.1)'

    metrics =
        deltaX: 0
        deltaY: 0
        deltaScale: 0
        deltaDX: 0
        AbsDeltaDX: 0

    ###*
     * Call at Touch Move
     * @param  {e}
     * @return {nothing}
    ###
    cardFlipMove = (e)->
        ###*
         * metrics calc
         * @type {[type]}
        ###
        metrics.deltaX = PageX - e.touches[0].pageX;
        metrics.deltaY = PageY - e.touches[0].pageY;
        # console.log Math.abs(metrics.deltaY)
        # console.log Math.abs(metrics.deltaX)
        VMOVEMENT = (Math.abs(metrics.deltaY) > Math.abs(metrics.deltaX))
        # console.log metrics.deltaY
        # console.log metrics.deltaX
        metrics.deltaScale = metrics.deltaY / (winHeight * SWIP_RATIO) 
        metrics.deltaDX = metrics.deltaScale * 200
        metrics.AbsDeltaDX = Math.abs(metrics.deltaDX)
        fact = Math.sin(2 * Math.PI / 360 * metrics.deltaDX)
        brightness = fact * 0.15
        shadow = Math.abs(fact * 50)

        ###*
        * Consts
        ###
        SHADOW_STR = "0 #{shadow}px #{shadow}px rgba(0, 0, 0, 0.3)"
        # console.log ANIMATING
        if metrics.AbsDeltaDX <= 185 and metrics.AbsDeltaDX >= 0 and ANIMATING == false and VMOVEMENT
            if metrics.deltaDX >= 0 
                # console.log 'down to up'
                MV_TARGET = $("#{selector} .card.bottom").first()
                TRANSFORM_STR = "rotateX(#{metrics.deltaDX}deg)"
                BRIGHTNESS_STR = "brightness(#{1 - brightness})"
            else
                # console.log 'up to down'
                MV_TARGET = $("#{selector} .card.top").last()
                TRANSFORM_STR = "rotateX(#{180 + metrics.deltaDX}deg)"
                BRIGHTNESS_STR = "brightness(#{1 + brightness})"

            if (not MV_TARGET.hasClass 'current_card') and metrics.AbsDeltaDX < 90 and $('.current_card').length == 0
                MV_TARGET.addClass 'current_card'

            CURRENT_CARD = $("#{selector} .card.current_card")
            if metrics.AbsDeltaDX >= 90
                if metrics.deltaDX > 0
                    CURRENT_CARD_ZINDEX = CURRENT_CARD.attr('id')
                    if not CURRENT_CARD.hasClass 'top'
                        CURRENT_CARD.addClass 'top'
                        CURRENT_CARD.removeClass 'bottom'
                    # console.info '1'
                else
                    CURRENT_CARD_ZINDEX = CURRENT_CARD.attr('id') * -1
                    if not CURRENT_CARD.hasClass 'bottom'
                        CURRENT_CARD.addClass 'bottom'
                        CURRENT_CARD.removeClass 'top'
                    # console.info '2'
            else
                if metrics.deltaDX >= 0
                    CURRENT_CARD_ZINDEX = CURRENT_CARD.attr('id') * -1
                    if not CURRENT_CARD.hasClass 'bottom'
                        CURRENT_CARD.addClass 'bottom'
                        CURRENT_CARD.removeClass 'top'
                    # console.info '3'
                else
                    CURRENT_CARD_ZINDEX = CURRENT_CARD.attr('id')
                    if not CURRENT_CARD.hasClass 'top'
                        CURRENT_CARD.addClass 'top'
                        CURRENT_CARD.removeClass 'bottom'
                    # console.info '4'

            $("#{selector} .card.current_card").css
                'transform':TRANSFORM_STR
                '-webkit-filter':BRIGHTNESS_STR
                'box-shadow': SHADOW_STR
                'z-index': CURRENT_CARD_ZINDEX

    # Call at Touch Start
    # e as event
    cardFlipStart = (e)->
        PageX = e.touches[0].pageX;
        PageY = e.touches[0].pageY;
        console.log('touch started');

    # Call at Touch End
    # e as event
    cardFlipEnd = (e)->
        PageX = PageY = 0
        console.info 'touch ended'
        $('.card.top').slice($('.card.top').length-2).css
            display: 'inline-block'
        $('.card.top').slice(0,$('.card.top').length - 2).css
            display: 'none'
        $('.card.bottom').slice(0,2).css
            display: 'inline-block'
        $('.card.bottom').slice(2,$('.card.bottom').length).css
            display: 'none'
        if metrics.AbsDeltaDX != 0
            if metrics.AbsDeltaDX < 90
                if metrics.deltaDX > 0
                    ED_TARGET = $("#{selector} .card.bottom").first()
                    ROTATE_ORI = '0'
                else
                    ED_TARGET = $("#{selector} .card.top").last()
                    ROTATE_ORI = '180'
            else
                if metrics.deltaDX >= 0
                    ED_TARGET = $("#{selector} .card.top").last()
                    ROTATE_ORI = '180'
                else
                    ED_TARGET = $("#{selector} .card.bottom").first()
                    ROTATE_ORI = '0'
            ANIMATING = true
            ED_TARGET.animate {rotateX: "#{ROTATE_ORI}deg"}, ANIMATE_TIME, FLIP_EFFECT, ->
                $("#{selector} .current_card").removeClass('current_card')
                ED_TARGET.css ORIGIN_STYLE
                ED_TARGET.removeClass('restore-progress')
                ANIMATING = false
            ED_TARGET.addClass('restore-progress')

    # Bind Card Flip to Deck
    $(selector).bind('touchstart', cardFlipStart)
    $(selector).bind('touchend', cardFlipEnd)
    $(selector).bind('touchmove', cardFlipMove)

module.exports = cardFlip