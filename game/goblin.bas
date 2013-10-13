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

_PlayFieldSetup
    for i = 0 to 20 step 2
        for c = 1 to 4 
            x = rand & %00011110
            z = x+1
            pfhline x i z on
        next
    next

    DF0FRACINC = 32
    DF1FRACINC = 32
    DF2FRACINC = 32
    DF3FRACINC = 32
    DF4FRACINC = 0

    pfcolors:
    $C8
end

   bkcolors:
    $00
end
    
_Player0Setup
    player0x = GOBLIN_MIN_X
    player0y = GOBLIN_MAX_Y
    missile1x = player0x
    missile1y = player0y

    missile1height = 5

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


_OtherPlayersSetup
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


_Player1Setup
    player1x = (rand & %01111000) + 16
    player1y = 0
    drawscreen
    if collision(playfield,player1) then goto _Player1Setup

_Player2Setup
    player2x = (rand & %01111000) + 16
    player2y = GOBLIN_DELTA_Y*1
    drawscreen
    if collision(playfield,player1) then goto _Player2Setup

_Player3Setup
    player3x = (rand & %01111000) + 16
    player3y = GOBLIN_DELTA_Y*2
    drawscreen
    if collision(playfield,player1) then goto _Player3Setup

_Player4Setup    
    player4x = (rand & %01111000) + 16
    player4y = GOBLIN_DELTA_Y*3
    drawscreen
    if collision(playfield,player1) then goto _Player4Setup

_Player5Setup
    player5x = (rand & %01111000) + 16
    player5y = GOBLIN_DELTA_Y*4
    drawscreen
    if collision(player1, playfield) then goto _Player5Setup


_Player6Setup
    player6x = (rand & %01111000) + 16
    player6y = GOBLIN_DELTA_Y*5
    drawscreen
    if collision(player1, playfield) then goto _Player6Setup

_Player7Setup
    player7x = (rand & %01111000) + 16
    player7y = GOBLIN_DELTA_Y*6
    drawscreen
    if collision(player1, playfield) then goto _Player7Setup

_Player8Setup
    player8x = (rand & %01111000) + 16
    player8y = GOBLIN_DELTA_Y*7
    drawscreen
    if collision(player1, playfield) then goto _Player8Setup

_Player9Setup
    player9x = (rand & %01111000) + 16
    player9y = GOBLIN_DELTA_Y*8
    drawscreen
    if collision(player1, playfield) then goto _Player9Setup

    ;pfpixel 0 0 on
    ;pfpixel 1 1 on
    ;pfpixel 30 19 on
    ;pfpixel 31 20 on

    
_GameLoop

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

