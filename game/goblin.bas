    
    bank 1
    temp1 = temp1

    set kernel DPC+
    set tv ntsc
    set kernel_options collision(playfield,player1)

    const GOBLIN_MIN_X   = 0
    const GOBLIN_MAX_X   = 160
    const GOBLIN_MIN_Y   = 0
    const GOBLIN_MAX_Y   = 160
    const GOBLIN_DELTA_X = 8
    const GOBLIN_DELTA_Y = 16
    
    const GOBLIN_TOP_BOUNDARY    = 255-24+GOBLIN_MIN_Y
    const GOBLIN_BOTTOM_BOUNDARY = GOBLIN_MAX_Y
    const GOBLIN_LEFT_BOUNDARY   = 255-24+GOBLIN_MIN_X
    const GOBLIN_RIGHT_BOUNDARY  = GOBLIN_MAX_X

    ; all-purpose bits for various jobs
    dim bits = z
    dim bits0_DebounceJoy0 = z

    dim frames = f
    dim speed = s

    goto _MAIN bank2


/*
 * START OF BANK 2
 */
    bank 2
    temp1 = temp1

_MAIN

    
   
_GameInit

    bits0_DebounceJoy0{0} = 0

    frames = 0
    speed = 50


    COLUM1 = $1E
    _NUSIZ1 = $30

    NUSIZ2 = _NUSIZ1
    NUSIZ3 = _NUSIZ1
    NUSIZ4 = _NUSIZ1
    NUSIZ5 = _NUSIZ1
    NUSIZ6 = _NUSIZ1
    NUSIZ7 = _NUSIZ1
    NUSIZ8 = _NUSIZ1
    NUSIZ9 = _NUSIZ1
   
    missile1height = 5


    player0x = GOBLIN_MIN_X
    player0y = GOBLIN_MAX_Y
    missile1x = player0x
    missile1y = player0y

    player1x = (rand & %01111000) + 16
    player1y = 0

    player2x = (rand & %01111000) + 16
    player2y = GOBLIN_DELTA_Y*1

    player3x = (rand & %01111000) + 16
    player3y = GOBLIN_DELTA_Y*2

    player4x = (rand & %01111000) + 16
    player4y = GOBLIN_DELTA_Y*3

    player5x = (rand & %01111000) + 16
    player5y = GOBLIN_DELTA_Y*4

    player6x = (rand & %01111000) + 16
    player6y = GOBLIN_DELTA_Y*5

    player7x = (rand & %01111000) + 16
    player7y = GOBLIN_DELTA_Y*6

    player8x = (rand & %01111000) + 16
    player8y = GOBLIN_DELTA_Y*7

    player9x = (rand & %01111000) + 16
    player9y = GOBLIN_DELTA_Y*8


    bkcolors:
    $00
end

    ;pfpixel 0 0 on
    ;pfpixel 1 1 on
    ;pfpixel 30 19 on
    ;pfpixel 31 20 on

    for i = 1 to 20
        x = rand & %00011110
        y = rand & %00001110
        z=x+1
        ;pfhline x y z on
        ;y=y+1
        pfhline x y z on
        ;pfpixel x y on
        ;x = x+1
        ;pfpixel x y on
        ;y= y+1
        ;pfpixel x y on
    next


_GameLoop

    player0:
    %00111100
    %01111110
    %11111111
    %10111101
    %10011001
    %10011001
    %11011011
    %11111111
    %10111101
    %10000001
    %11000011
    %11100111
    %01111110
    %00111100
end

    player0color:
    $36, $36, $36, $36, $36, $36, $36, $36
    $36, $36, $36, $36, $36, $36
end

    player1-9:
    %00111100
    %01111110
    %11011011
    %11011011
    %11111111
    %11100111
    %11000011
    %11011011
    %01111110
    %00111100
end

    player1-9color:
    $1E, $1E, $1E, $1E, $1E, $1E, $1E, $1E
    $1E, $1E, $1E
end

   
    DF0FRACINC = 32
    DF1FRACINC = 32
    DF2FRACINC = 32
    DF3FRACINC = 32
    DF4FRACINC = 0

    pfcolors:
    $C8
end
    

    ; check joystick movement
    if !joy0left && !joy0right then goto _SkipHMove 

    if bits0_DebounceJoy0{0} then goto _SkipDebounceReset

    bits0_DebounceJoy0{0} = 1
    if joy0left then player0x=player0x-GOBLIN_DELTA_X
    if joy0right then player0x=player0x+GOBLIN_DELTA_X

    if player0x > GOBLIN_LEFT_BOUNDARY then player0x=GOBLIN_MAX_X : goto _SkipWrapCheck
    if player0x > GOBLIN_RIGHT_BOUNDARY then player0x=GOBLIN_MIN_X 
_SkipWrapCheck

    goto _SkipDebounceReset

_SkipHMove
    bits0_DebounceJoy0{0} = 0
_SkipDebounceReset

    if frames < speed then goto _SkipMoveUp
    frames=0
    player0y = player0y-GOBLIN_DELTA_Y
    if player0y > GOBLIN_TOP_BOUNDARY then player0y = GOBLIN_MAX_Y
_SkipMoveUp

    ; missile1 tracks player0 position
    missile1x = player0x+1
    missile1y = player0y+4

    drawscreen
    frames = frames+1

    goto _GameLoop

