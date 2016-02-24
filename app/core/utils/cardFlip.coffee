# /** 
#  * Flip the Card
#  * E as Event 
#  * component as jquery selector
#  * pageX and pageY for moving point
#  */
cardFlip = (selector)->
    # Global PageX & PageY for recording
    PageX = PageY = 0;
    winHeight = window.innerHeight;

    metrics =
        deltaX: 0
        deltaY: 0
        deltaScale: 0
        deltaDX: 0

    # Call at Touch Move
    # e as event
    cardFlipMove = (e)->
        metrics.deltaX = PageX - e.touches[0].pageX;
        metrics.deltaY = PageY - e.touches[0].pageY;
        metrics.deltaScale = metrics.deltaY / (winHeight*0.6) 
        metrics.deltaDX = metrics.deltaScale * 180;

        # Adjust Card Lighting on the fly
        if metrics.deltaDX > 0
            $("#{selector} .card.bottom").css
                'transform':"rotateX(#{metrics.deltaDX}deg)"
                '-webkit-filter':"brightness(#{1 - metrics.deltaScale})"
                'filter':"brightness(#{1 - metrics.deltaScale})"
                # '-webkit-filter':"contrast(#{1 - metrics.deltaScale})"
                # 'filter':"contrast(#{1 - metrics.deltaScale})"
        else
            $("#{selector} .card.top").css
                'transform':"rotateX(#{metrics.deltaDX}deg)"
                '-webkit-filter':"brightness(#{1 + metrics.deltaScale})"
                'filter':"brightness(#{1 + metrics.deltaScale})"
                # '-webkit-filter':"contrast(#{1 + metrics.deltaScale})"
                # 'filter':"contrast(#{1 + metrics.deltaScale})"

        # Debug
        console.log(metrics.deltaX);
        console.log(metrics.deltaDX);
        console.log(Math.sin(Math.PI)*metrics.deltaDX);

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
        console.info metrics.deltaDX
        if metrics.deltaDX > 0
            $("#{selector} .card.bottom").animate {rotateX: '0deg'}, 500, 'ease-out', ->
                $("#{selector} .card.bottom").css('-webkit-filter', 'brightness(1)')
                $("#{selector} .card.bottom").removeClass('restore-progress')
            $("#{selector} .card.bottom").addClass('restore-progress')
        else
            $("#{selector} .card.top").animate {rotateX: '0deg'}, 500, 'ease-out', ->
                $("#{selector} .card.top").css('-webkit-filter', 'brightness(1)')
                $("#{selector} .card.top").removeClass('restore-progress')
            $("#{selector} .card.top").addClass('restore-progress')

    # Bind Card Flip to Deck
    $(selector).bind('touchstart', cardFlipStart)
    $(selector).bind('touchend', cardFlipEnd)
    $(selector).bind('touchmove', cardFlipMove)

module.exports = cardFlip