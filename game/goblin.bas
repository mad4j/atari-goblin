    bank 1
    temp1 = temp1

    set kernel DPC+
    set tv ntsc
    set kernel_options collision(playfield,player1)

    const font = 1

    dim sc1 = score
    dim sc2 = score+1
    dim sc3 = score+2

    dim facesCounter = c

    dim eatSound = m
    const EAT_SOUND_LENGTH = 10
    const EAT_SOUND_FREQUENCY = 25
    const EAT_SOUND_VOLUME = 8

    const GOBLIN_MIN_X   = 16
    const GOBLIN_MAX_X   = 136
    const GOBLIN_MIN_Y   = 0
    const GOBLIN_MAX_Y   = 160
    const GOBLIN_DELTA_X = 8
    const GOBLIN_DELTA_Y = 16
    
    const GOBLIN_TOP_BOUNDARY    = 255-24+GOBLIN_MIN_Y
    const GOBLIN_BOTTOM_BOUNDARY = GOBLIN_MAX_Y
    const GOBLIN_LEFT_BOUNDARY   = GOBLIN_MIN_X
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

   bkcolors:
    $00
end

    scorecolors:
    $3E
    $3C
    $3A
    $38
    $36
    $36
    $34
    $32
end

    
_Player0Setup

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

    bits0_DebounceJoy0{0} = 0

    frames = 0
    speed = 50

    facesCounter = 0
_GameLoop

   if !eatSound then goto _SkipEatSound
   AUDV0 = EAT_SOUND_VOLUME
   AUDC0 = 4
   AUDF0 = EAT_SOUND_FREQUENCY
   eatSound = eatSound - 1
   if !eatSound then AUDV0 = 0
_SkipEatSound

    if facesCounter > 0 then goto _SkipPlayFieldSetup 
        gosub _PlayFieldSetup bank3
        gosub _OtherPlayersSetup bank3
_SkipPlayFieldSetup

    ; check joystick movement
    if !joy0left && !joy0right then goto _SkipHMove 

    if bits0_DebounceJoy0{0} then goto _SkipDebounceReset

    bits0_DebounceJoy0{0} = 1
    if joy0left then player0x=player0x-GOBLIN_DELTA_X
    if joy0right then player0x=player0x+GOBLIN_DELTA_X

    if player0x < GOBLIN_LEFT_BOUNDARY then player0x=GOBLIN_MAX_X : goto _SkipWrapCheck
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

    gosub _CheckPlayersCollision bank3

    goto _GameLoop

/*
 * START OF BANK 3
 */
    bank 3
    temp1 = temp1

_CheckPlayersCollision

    if !collision(player1,player0) then goto _SkipCollisionDetection

    if player0y <> player1y then goto _SkipPlayer1Reset
    player1:
end
    player1x=0
    goto _UpdateCollisionCheck
_SkipPlayer1Reset

    if player0y <> player2y then goto _SkipPlayer2Reset 
    player2:
end
    player2x=0
    goto _UpdateCollisionCheck
_SkipPlayer2Reset

    if player0y <> player3y then goto _SkipPlayer3Reset
    player3:
end
    player3x=0
    goto _UpdateCollisionCheck
_SkipPlayer3Reset

    if player0y <> player4y then goto _SkipPlayer4Reset
    player4:
end
    player4x=0
    goto _UpdateCollisionCheck
_SkipPlayer4Reset    

    if player0y <> player5y then goto _SkipPlayer5Reset
    player5:
end
    player5x=0
    goto _UpdateCollisionCheck
_SkipPlayer5Reset

    if player0y <> player6y then goto _SkipPlayer6Reset
    player6:
end
    player6x=0
    goto _UpdateCollisionCheck
_SkipPlayer6Reset

    if player0y <> player7y then goto _SkipPlayer7Reset
    player7:
end
    player7x=0
    goto _UpdateCollisionCheck
_SkipPlayer7Reset

    if player0y <> player8y then goto _SkipPlayer8Reset
    player8:
end
    player8x=0
    goto _UpdateCollisionCheck
_SkipPlayer8Reset

    if player0y <> player9y then goto _SkipPlayer9Reset
    player9:
end
    player9x=0
    goto _UpdateCollisionCheck
_SkipPlayer9Reset

_UpdateCollisionCheck
    score = score+1
    facesCounter = facesCounter-1
    eatSound = EAT_SOUND_LENGTH

_SkipCollisionDetection
    return otherbank


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

    player0x = (GOBLIN_MAX_X/2)+4
    player0y = GOBLIN_MAX_Y
    missile1x = player0x
    missile1y = player0y

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
    
    facesCounter = 9

    return otherbank

_PlayFieldSetup
    pfclear
    for i = 0 to 18 step 2
        for c = 1 to 3 
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
    return otherbank
