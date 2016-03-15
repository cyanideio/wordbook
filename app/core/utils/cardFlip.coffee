

###*
* Flip the Card
* E as Event 
* component as jquery selector
* pageX and pageY for moving point
###
cardFlip = (selector)->
    # Global PageX & PageY for recording
    PageX = PageY = 0;
    winHeight = window.innerHeight;

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
        metrics.deltaScale = metrics.deltaY / (winHeight * 0.5) 
        metrics.deltaDX = metrics.deltaScale * 180;
        metrics.AbsDeltaDX = Math.abs(metrics.deltaDX)
        fact = Math.sin(2 * Math.PI / 360 * metrics.deltaDX)
        brightness = fact * 0.15
        shadow = Math.abs(fact * 50)

        ###*
        * Consts
        ###
        SHADOW_STR = "0 #{shadow}px #{shadow}px rgba(0, 0, 0, 0.3)"
        if metrics.deltaDX >= 0
            console.log 'down to up'
            MV_TARGET = $("#{selector} .card.bottom").first()
            TRANSFORM_STR = "rotateX(#{metrics.deltaDX}deg)"
            BRIGHTNESS_STR = "brightness(#{1 - brightness})"
        else
            console.log 'up to down'
            MV_TARGET = $("#{selector} .card.top").last()
            TRANSFORM_STR = "rotateX(#{180 + metrics.deltaDX}deg)"
            BRIGHTNESS_STR = "brightness(#{1 + brightness})"

        if (not MV_TARGET.hasClass 'current_card') and metrics.AbsDeltaDX < 90 and $('.current_card').length == 0
            MV_TARGET.addClass 'current_card'
        $("#{selector} .card.current_card").css
            'transform':TRANSFORM_STR
            '-webkit-filter':BRIGHTNESS_STR
            'box-shadow': SHADOW_STR

        CURRENT_CARD = $("#{selector} .card.current_card")
        if metrics.AbsDeltaDX >= 90
            CURRENT_CARD_ZINDEX = CURRENT_CARD.css('z-index')
            if metrics.deltaDX > 0
                if not CURRENT_CARD.hasClass 'top'
                    if (CURRENT_CARD.css('z-index') < 0)
                        CURRENT_CARD.css('z-index', CURRENT_CARD_ZINDEX * -1)
                    CURRENT_CARD.addClass 'top'
                    CURRENT_CARD.removeClass 'bottom'
                console.info '1'
            else
                if not CURRENT_CARD.hasClass 'bottom'
                    if (CURRENT_CARD.css('z-index') > 0)
                        CURRENT_CARD.css('z-index', CURRENT_CARD_ZINDEX * -1)
                    CURRENT_CARD.addClass 'bottom'
                    CURRENT_CARD.removeClass 'top'
                console.info '2'
        else
            if metrics.deltaDX >= 0
                if not CURRENT_CARD.hasClass 'bottom'
                    if (CURRENT_CARD.css('z-index') > 0)
                        CURRENT_CARD.css('z-index', CURRENT_CARD_ZINDEX * -1)
                    CURRENT_CARD.addClass 'bottom'
                    CURRENT_CARD.removeClass 'top'
                console.info '3'
            else
                if not CURRENT_CARD.hasClass 'top'
                    if (CURRENT_CARD.css('z-index') < 0)
                        CURRENT_CARD.css('z-index', CURRENT_CARD_ZINDEX * -1)
                    CURRENT_CARD.addClass 'top'
                    CURRENT_CARD.removeClass 'bottom'
                console.info '4'

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
        if metrics.AbsDeltaDX < 90
            console.info 'within border'
            if metrics.deltaDX > 0
                $("#{selector} .card.bottom").first().animate {rotateX: '0deg'}, 500, 'ease-out', ->
                    $("#{selector} .current_card").removeClass('current_card')
                    $("#{selector} .card.bottom").css
                        '-webkit-filter': 'brightness(1)'
                        'box-shadow': '0 2px 2px rgba(0, 0, 0, 0.3)'
                    $("#{selector} .card.bottom").removeClass('restore-progress')
                $("#{selector} .card.bottom").first().addClass('restore-progress')
            else
                $("#{selector} .card.top").last().animate {rotateX: '180deg'}, 500, 'ease-out', ->
                    $("#{selector} .current_card").removeClass('current_card')
                    $("#{selector} .card.top").css
                        '-webkit-filter': 'brightness(1)'
                        'box-shadow': '0 2px 2px rgba(0, 0, 0, 0.3)'
                    $("#{selector} .card.top").first().removeClass('restore-progress')
                $("#{selector} .card.top").last().addClass('restore-progress')
        else
            if metrics.deltaDX >= 0
                console.info 'over border'
                $("#{selector} .current_card").animate {rotateX: '180deg'}, 500, 'ease-out', ->
                    $("#{selector} .current_card").removeClass('current_card')
                    $("#{selector} .card.top").css
                        '-webkit-filter': 'brightness(1)'
                        'box-shadow': '0 2px 2px rgba(0, 0, 0, 0.3)'
                    $("#{selector} .card.top").removeClass('restore-progress')
                $("#{selector} .current_card").addClass('restore-progress')
            else
                $("#{selector} .card.bottom").first().animate {rotateX: '0deg'}, 500, 'ease-out', ->
                    $("#{selector} .current_card").removeClass('current_card')
                    $("#{selector} .card.bottom").first().css
                        '-webkit-filter': 'brightness(1)'
                        'box-shadow': '0 2px 2px rgba(0, 0, 0, 0.3)'
                    $("#{selector} .card.bottom").first().removeClass('restore-progress')
                $("#{selector} .card.bottom").first().addClass('restore-progress')

    # Bind Card Flip to Deck
    $(selector).bind('touchstart', cardFlipStart)
    $(selector).bind('touchend', cardFlipEnd)
    $(selector).bind('touchmove', cardFlipMove)

module.exports = cardFlip