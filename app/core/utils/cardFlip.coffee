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
        metrics.deltaX = PageX - e.touches[0].pageX;
        metrics.deltaY = PageY - e.touches[0].pageY;
        metrics.deltaScale = metrics.deltaY / (winHeight*0.6) 
        metrics.deltaDX = metrics.deltaScale * 180;
        metrics.AbsDeltaDX = Math.abs(metrics.deltaDX)
        brightness = Math.sin(2*Math.PI/360 * metrics.deltaDX) * 0.3

        # Adjust Card Lighting on the fly
        if metrics.deltaDX > 0
            if not $("#{selector} .card.bottom").hasClass 'current_card'
                $("#{selector} .card.bottom").addClass 'current_card'
            $("#{selector} .card.current_card").css
                'transform':"rotateX(#{metrics.deltaDX}deg)"
                '-webkit-filter':"brightness(#{1 - brightness})"
                'filter':"brightness(#{1 - brightness})"
        else
            console.log metrics.deltaDX
            if not $("#{selector} .card.top").hasClass 'current_card'
                $("#{selector} .card.top").addClass 'current_card'
            $("#{selector} .card.current_card").css
                'transform':"rotateX(#{180 + metrics.deltaDX}deg)"
                '-webkit-filter':"brightness(#{1 + brightness})"
                'filter':"brightness(#{1 + brightness})"

        if metrics.AbsDeltaDX >= 90
            if metrics.deltaDX >= 0
                if not $("#{selector} .curren_card").hasClass 'top'
                    $("#{selector} .current_card").addClass 'top'
                    $("#{selector} .current_card").removeClass 'bottom'
                console.info '1'
            else
                if not $("#{selector} .current_card").hasClass 'bottom'
                    $("#{selector} .current_card").addClass 'bottom'
                    $("#{selector} .current_card").removeClass 'top'
                console.info '2'
        else
            if metrics.deltaDX >= 0
                if not $("#{selector} .current_card").hasClass 'bottom'
                    $("#{selector} .current_card").addClass 'bottom'
                    $("#{selector} .current_card").removeClass 'top'
                console.info '3'
            else
                if not $("#{selector} .curren_card").hasClass 'top'
                    $("#{selector} .current_card").addClass 'top'
                    $("#{selector} .current_card").removeClass 'bottom'
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
                $("#{selector} .card.bottom").animate {rotateX: '0deg'}, 500, 'ease-out', ->
                    $("#{selector} .card.bottom").css('-webkit-filter', 'brightness(1)')
                    $("#{selector} .card.bottom").removeClass('restore-progress')
                $("#{selector} .card.bottom").addClass('restore-progress')
            else
                $("#{selector} .card.top").animate {rotateX: '180deg'}, 500, 'ease-out', ->
                    $("#{selector} .card.top").css('-webkit-filter', 'brightness(1)')
                    $("#{selector} .card.top").removeClass('restore-progress')
                $("#{selector} .card.top").addClass('restore-progress')
        else
            if metrics.deltaDX >= 0
                console.info 'over border'
                $("#{selector} .card.top").animate {rotateX: '180deg'}, 500, 'ease-out', ->
                    $("#{selector} .card.top").css('-webkit-filter', 'brightness(1)')
                    $("#{selector} .card.top").removeClass('restore-progress')
                $("#{selector} .card.top").addClass('restore-progress')
            else
                $("#{selector} .card.bottom").animate {rotateX: '0deg'}, 500, 'ease-out', ->
                    $("#{selector} .card.bottom").css('-webkit-filter', 'brightness(1)')
                    $("#{selector} .card.bottom").removeClass('restore-progress')
                $("#{selector} .card.bottom").addClass('restore-progress')
    # Bind Card Flip to Deck
    $(selector).bind('touchstart', cardFlipStart)
    $(selector).bind('touchend', cardFlipEnd)
    $(selector).bind('touchmove', cardFlipMove)

module.exports = cardFlip