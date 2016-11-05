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

    dim crashSound = m
    const CRASH_SOUND_LENGTH = 8
    const CRASH_SOUND_FREQUENCY = 4
    const CRASH_SOUND_VOLUME = 6

    dim smileSound = m
    const SMILE_SOUND_LENGTH = 8
    const SMILE_SOUND_FREQUENCY = 4
    const SMILE_SOUND_VOLUME = 6

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

    dim gameState = x
    dim gameStage = y

    const GAME_STATE_PLAYING  = 2
    const GAME_STATE_GAMEOVER = 3

    goto _MAIN bank2


/*
 * START OF BANK 2
 */
    bank 2
    temp1 = temp1

_MAIN
       
_GameInit

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

    missile1height = 4

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

    ; playfield vertical resolution (per quarter)
    DF0FRACINC = 32
    DF1FRACINC = 32
    DF2FRACINC = 32
    DF3FRACINC = 32

    ; single color playfield
    DF4FRACINC = 0

    pfcolors:
    $C8
end

    ; single color background
    DF6FRACINC = 0

    bkcolors:
    $00
end

    if gameState = GAME_STATE_GAMEOVER then gosub _GameOverLoop bank3 : drawscreen: goto _GameLoop

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

    if !collision(player0, playfield) then goto _SkipPlayerCollision
        gameState=GAME_STATE_GAMEOVER
        gameStage=0
        gosub _GameOverLoop bank 3
_SkipPlayerCollision

    if !collision(player1,player0) then goto _SkipCollisionDetection

    if player0y <> player1y then goto _SkipPlayer1Reset
 ;     player1:
 ;end
    player1x=0 : player1y=200
    goto _UpdateCollisionCheck
_SkipPlayer1Reset

    if player0y <> player2y then goto _SkipPlayer2Reset 
    player2x=0 : player2y=200
    goto _UpdateCollisionCheck
_SkipPlayer2Reset

    if player0y <> player3y then goto _SkipPlayer3Reset
    player3x=0 : player3y=200
    goto _UpdateCollisionCheck
_SkipPlayer3Reset

    if player0y <> player4y then goto _SkipPlayer4Reset
    player4x=0 : player4y=200
    goto _UpdateCollisionCheck
_SkipPlayer4Reset    

    if player0y <> player5y then goto _SkipPlayer5Reset
    player5x=0 : player5y=200
    goto _UpdateCollisionCheck
_SkipPlayer5Reset

    if player0y <> player6y then goto _SkipPlayer6Reset
    player6x=0 : player6y=200
    goto _UpdateCollisionCheck
_SkipPlayer6Reset

    if player0y <> player7y then goto _SkipPlayer7Reset
    player7x=0 : player7y=200
    goto _UpdateCollisionCheck
_SkipPlayer7Reset

    if player0y <> player8y then goto _SkipPlayer8Reset
    player8x=0 : player8y=200
    goto _UpdateCollisionCheck
_SkipPlayer8Reset

    if player0y <> player9y then goto _SkipPlayer9Reset
    player9x=0 : player9y=200
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

    return otherbank

_GameOverLoop


_GameOverLoopStage0

    ; if stage 0 is active
    if gameStage > 0 then goto _SkipGameOverLoopStage0

    ; set goblin crash sprite
    player0:
    %00000000
    %00000000
    %00000000
    %00000000
    %00000000
    %00000000
    %00000000
    %00000000
    %00000000
    %00000000
    %00000000
    %00000000
    %01111110
    %00111100
end

    missile1x = 0
    missile1y = 200

    if crashSound>0 then goto _SkipCrashSoundSetup
    crashSound = CRASH_SOUND_LENGTH
_SkipCrashSoundSetup

    AUDV0 = CRASH_SOUND_VOLUME
    AUDC0 = 4
    AUDF0 = CRASH_SOUND_FREQUENCY
    crashSound = crashSound-1

    if crashSound>0 then return otherbank

    AUDV0 = 0
    gameStage = gameStage+1
    return otherbank
_SkipGameOverLoopStage0   

_GameOverLoopStage1
    if gameStage > 1 then goto _SkipGameOverLoopStage1

    if player1y=200 then goto _SkipNoFaceStage1

    player1:
    %00111100
    %01111110
    %11011011
    %11011011
    %11111111
    %10111101
    %11100111
    %01111110
    %00111100
end

    if smileSound>0 then goto _SkipSmileSoundSetup1
    smileSound = SMILE_SOUND_LENGTH
_SkipSmileSoundSetup1

    AUDV0 = SMILE_SOUND_VOLUME
    AUDC0 = 4
    AUDF0 = SMILE_SOUND_FREQUENCY
    smileSound = smileSound-1

    if smileSound>0 then return otherbank

_SkipNoFaceStage1
    AUDV0 = 0
    gameStage = gameStage+1
    return otherbank
_SkipGameOverLoopStage1

_GameOverLoopStage2
    if gameStage > 2 then goto _SkipGameOverLoopStage2

    if player2y=200 then goto _SkipNoFaceStage2

    player2:
    %00111100
    %01111110
    %11011011
    %11011011
    %11111111
    %10111101
    %11000011
    %11100111
    %01111110
    %00111100
end

    if smileSound>0 then goto _SkipSmileSoundSetup2
    smileSound = SMILE_SOUND_LENGTH
_SkipSmileSoundSetup2

    AUDV0 = SMILE_SOUND_VOLUME
    AUDC0 = 4
    AUDF0 = SMILE_SOUND_FREQUENCY
    smileSound = smileSound-1

    if smileSound>0 then return otherbank

_SkipNoFaceStage2
    AUDV0 = 0
    gameStage = gameStage+1
    return otherbank
_SkipGameOverLoopStage2

_GameOverLoopStage3
    if gameStage > 3 then goto _SkipGameOverLoopStage3
    player3:
    %00111100
    %01111110
    %11011011
    %11011011
    %11111111
    %10111101
    %11000011
    %11100111
    %01111110
    %00111100
end

    if player3y=200 then goto _SkipGameOverLoopStage3

    if smileSound>0 then goto _SkipSmileSoundSetup3
    smileSound = SMILE_SOUND_LENGTH
_SkipSmileSoundSetup3

    AUDV0 = SMILE_SOUND_VOLUME
    AUDC0 = 4
    AUDF0 = SMILE_SOUND_FREQUENCY
    smileSound = smileSound-1

    if smileSound>0 then return otherbank

    AUDV0 = 0
    gameStage = gameStage+1
    return otherbank
_SkipGameOverLoopStage3

_GameOverLoopStage4
    if gameStage > 4 then goto _SkipGameOverLoopStage4
    player4:
    %00111100
    %01111110
    %11011011
    %11011011
    %11111111
    %10111101
    %11000011
    %11100111
    %01111110
    %00111100
end

    if player4y=200 then goto _SkipGameOverLoopStage4

    if smileSound>0 then goto _SkipSmileSoundSetup4
    smileSound = SMILE_SOUND_LENGTH
_SkipSmileSoundSetup4

    AUDV0 = SMILE_SOUND_VOLUME
    AUDC0 = 4
    AUDF0 = SMILE_SOUND_FREQUENCY
    smileSound = smileSound-1

    if smileSound>0 then return otherbank

    AUDV0 = 0
    gameStage = gameStage+1
    return otherbank
_SkipGameOverLoopStage4

_GameOverLoopStage5
    if gameStage > 5 then goto _SkipGameOverLoopStage5
    player5:
    %00111100
    %01111110
    %11011011
    %11011011
    %11111111
    %10111101
    %11000011
    %11100111
    %01111110
    %00111100
end

   if player5y=200 then goto _SkipGameOverLoopStage5

    if smileSound>0 then goto _SkipSmileSoundSetup5
    smileSound = SMILE_SOUND_LENGTH
_SkipSmileSoundSetup5

    AUDV0 = SMILE_SOUND_VOLUME
    AUDC0 = 4
    AUDF0 = SMILE_SOUND_FREQUENCY
    smileSound = smileSound-1

    if smileSound>0 then return otherbank

    AUDV0 = 0
    gameStage = gameStage+1
    return otherbank
_SkipGameOverLoopStage5

_GameOverLoopStage6
    if gameStage > 6 then goto _SkipGameOverLoopStage6
    player6:
    %00111100
    %01111110
    %11011011
    %11011011
    %11111111
    %10111101
    %11000011
    %11100111
    %01111110
    %00111100
end

    if player6y=200 then goto _SkipGameOverLoopStage6

    if smileSound>0 then goto _SkipSmileSoundSetup6
    smileSound = SMILE_SOUND_LENGTH
_SkipSmileSoundSetup6

    AUDV0 = SMILE_SOUND_VOLUME
    AUDC0 = 4
    AUDF0 = SMILE_SOUND_FREQUENCY
    smileSound = smileSound-1

    if smileSound>0 then return otherbank

    AUDV0 = 0
    gameStage = gameStage+1
    return otherbank
_SkipGameOverLoopStage6

_GameOverLoopStage7
    if gameStage > 7 then goto _SkipGameOverLoopStage7
    player7:
    %00111100
    %01111110
    %11011011
    %11011011
    %11111111
    %10111101
    %11000011
    %11100111
    %01111110
    %00111100
end

    if player7y=200 then goto _SkipGameOverLoopStage7

    if smileSound>0 then goto _SkipSmileSoundSetup7
    smileSound = SMILE_SOUND_LENGTH
_SkipSmileSoundSetup7

    AUDV0 = SMILE_SOUND_VOLUME
    AUDC0 = 4
    AUDF0 = SMILE_SOUND_FREQUENCY
    smileSound = smileSound-1

    if smileSound>0 then return otherbank

    AUDV0 = 0
    gameStage = gameStage+1
    return otherbank
_SkipGameOverLoopStage7

_GameOverLoopStage8
    if gameStage > 8 then goto _SkipGameOverLoopStage8
    player8:
    %00111100
    %01111110
    %11011011
    %11011011
    %11111111
    %10111101
    %11000011
    %11100111
    %01111110
    %00111100
end

    if player8y=200 then goto _SkipGameOverLoopStage8

    if smileSound>0 then goto _SkipSmileSoundSetup8
    smileSound = SMILE_SOUND_LENGTH
_SkipSmileSoundSetup8

    AUDV0 = SMILE_SOUND_VOLUME
    AUDC0 = 4
    AUDF0 = SMILE_SOUND_FREQUENCY
    smileSound = smileSound-1

    if smileSound>0 then return otherbank

    AUDV0 = 0
    gameStage = gameStage+1
    return otherbank
_SkipGameOverLoopStage8

_GameOverLoopStage9
    if gameStage > 9 then goto _SkipGameOverLoopStage9
    player9:
    %00111100
    %01111110
    %11011011
    %11011011
    %11111111
    %10111101
    %11000011
    %11100111
    %01111110
    %00111100
end

    if player9y=200 then goto _SkipGameOverLoopStage9

    if smileSound>0 then goto _SkipSmileSoundSetup9
    smileSound = SMILE_SOUND_LENGTH
_SkipSmileSoundSetup9

    AUDV0 = SMILE_SOUND_VOLUME
    AUDC0 = 4
    AUDF0 = SMILE_SOUND_FREQUENCY
    smileSound = smileSound-1

    if smileSound>0 then return otherbank

    AUDV0 = 0
    gameStage = gameStage+1
    return otherbank
_SkipGameOverLoopStage9

    return otherbank
