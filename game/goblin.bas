    
    bank 1
    temp1 = temp1

    set kernel DPC+

    const GOBLIN_MIN_X = 5
    const GOBLIN_MAX_X = 150
    const GOBLIN_MIN_Y = 0
    const GOBLIN_MAX_Y = 160
    const GOBLIN_DELTA_X = 8
    const GOBLIN_DELTA_Y = 14
    
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

    bank 2

_MAIN

    temp1=temp1
   
_GameInit

    bits0_DebounceJoy0{0} = 0

    frames = 0
    speed = 50

    player0x = GOBLIN_MIN_X
    player0y = GOBLIN_MAX_Y

    player1x = GOBLIN_MIN_X
    player1y = GOBLIN_MIN_Y

    player2x = 50
    player2y = 18

    player3x = 50
    player3y = 36

    player4x = 50
    player4y = 54

    player5x = 50
    player5y = 72

    bkcolors:
    $00
end

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
    $42
    $42
    $42
    $42
    $42
    $42
    $42
    $42
    $42
    $42
    $42
    $42
    $42
    $42
end

    player1-9:
    %00111100
    %01111110
    %11011011
    %11011011
    %11111111
    %11111111
    %11011011
    %11000011
    %11100111
    %01111110
    %00111100
end

;    player2-9:
;    %00111100
;    %01011010
;    %11011011
;    %11111111
;    %11011011
;    %11000011
;    %01100110
;    %00111100
;end

    player1-9color:
    $1E
    $1E
    $1E
    $1E
    $1E
    $1E
    $1E
    $1E
    $1E
    $1E
    $1E
end

    pfpixel 5 3 on

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

    drawscreen
    frames = frames+1

    goto _GameLoop
