'$Include: 'pulsartop.bi'
'$NoPrefix removed here
$Embed:'./assets/pointer.png','pointer'
$Embed:'./assets/backgroundm3.png','background'
$Embed:'./assets/tiles.png','tiles'
$Embed:'./assets/lemon.ttf','thefont'
$Embed:'./assets/arrow.png','arrow'
$Embed:'./assets/icon.png','prgicon'
$Embed:'./assets/background.png','title'
$Embed:'./assets/trance-menu.ogg','musica'
$Embed:'./assets/select_006.ogg','selectsound'
$Embed:'./assets/confirmation_001.ogg','confirmsound'
$Embed:'./assets/Won!.mp3','winningsound'
$Embed:'./assets/game_over_1.mp3','gameoversound'
$ExeIcon:'./icon.ico'
Randomize Timer

_Title "Flood the Board - Press [F] to toggle fullscreen"

Dim Shared arrow&, tileset&, pointer&, background&, titlescreen&, bigfont&, smallfont&, middlefont&, mx%, my%, mb%, xoffset%, yoffset%, maxmoves%, columns%, rows%
Dim Shared success%, arrowx%, moves%, arcolor%, arrowspeed%, iconimage&
Dim Shared exitgame%, click%, music&, selectsnd&, sndconfirm&, sndwin&, sndgameover&
Dim Shared playonce%(1 To 5)

Const BROWNCHOICE = _RGB32(155, 105, 0)
Const BTNGRAY = _RGB32(190, 190, 190)
Const BTNWHITE = _RGB32(230, 230, 230)
Const ARWHITE = 0
Const ARBLUE = 1
Const ARPINK = 2
Const ARORANGE = 3
Const ARYELLOW = 4
Const ARGREEN = 5
Const ARGRAY = 6
Const NEWGAME = 1
Const ABOUT = 2
Const WINSCREEN = 3
Const EXITPRG = 4
Const GOBACK = 5

iconimage& = _LoadImage(_Embedded$("prgicon"), 32, "memory")
pointer& = _LoadImage(_Embedded$("pointer"), 33, "memory")
background& = _LoadImage(_Embedded$("background"), 32, "memory")
tileset& = _LoadImage(_Embedded$("tiles"), 33, "memory")
arrow& = _LoadImage(_Embedded$("arrow"), 33, "memory")
titlescreen& = _LoadImage(_Embedded$("title"), 32, "memory")
music& = _SndOpen(_Embedded$("musica"), "memory")
selectsnd& = _SndOpen(_Embedded$("selectsound"), "memory")
sndconfirm& = _SndOpen(_Embedded$("confirmsound"), "memory")
sndwin& = _SndOpen(_Embedded$("winningsound"), "memory")
sndgameover& = _SndOpen(_Embedded$("gameoversound"), "memory")
bigfont& = _LoadFont(_Embedded$("thefont"), 78, "memory")
smallfont& = _LoadFont(_Embedded$("thefont"), 24, "memory")
middlefont& = _LoadFont(_Embedded$("thefont"), 48, "memory")

Screen _NewImage(1366, 768, 32)
_ScreenMove 0 + _Width / 4, 0 + _Height / 4
_Icon iconimage&
_PrintMode _KeepBackground
_MouseHide
columns% = 14
rows% = 14
Dim Shared level(1 To columns%, 1 To rows%) As Integer

Do
    For x% = 1 To columns%
        For y% = 1 To rows%
            level(x%, y%) = Int(Rnd * 6) + 1
        Next
    Next
    success% = TRUE
    exitgame% = FALSE
    xoffset% = 200
    yoffset% = 100
    maxmoves% = 30
    moves% = 0
    arrowx% = 170
    arrowspeed% = 1
    frame% = 0
    click% = 0
    For i = 1 To 5
        playonce%(i) = 0
    Next
    _SndVol music&, 0.5
    _SndVol selectsnd&, 0.75
    _SndVol sndconfirm&, 1.0
    _SndVol sndwin&&, 1.0
    _SndVol sndgameover&&, 1.0
    _SndLoop music&
    showtitlescreen
    ' ------------- Main loop starts here ----------------------------------
    If _SndPlaying(music&) Then
        _SndPause music&
    End If
    Do
        _Limit 80
        Cls
        _PutImage (0, 0), background&
        Do While _MouseInput
            mx% = _MouseX: my% = _MouseY: mb% = _MouseButton(1)
        Loop
        colorchoice
        drawlevel
        drawarrow
        _PutImage (mx%, my%), pointer&
        frame% = frame% + 1
        If frame% = 30 Then frame% = 0
        If frame% Mod 2 = 0 Then
            arrowx% = arrowx% + arrowspeed%
            If arrowx% >= 190 Then arrowspeed% = -1
            If arrowx% <= 170 Then arrowspeed% = 1
        End If
        arcolor% = ARWHITE
        checkfunctionkey
        _Display
        If success% = TRUE Then
            showcongratulations
            exitgame% = TRUE
        End If
        If maxmoves% - moves% <= 0 Then
            showgameover
            exitgame% = TRUE
        End If
    Loop Until exitgame% = TRUE
Loop Until InKey$ = Chr$(27)
freetheram
System

' -------------------------- End of main game -------------------------------

Sub colorchoice
    If mousezone(895, 175, 895 + 90, 175 + 90) = TRUE And (level(1, 1) <> 1) Then
        Line (895, 175)-(895 + 90, 175 + 90), BROWNCHOICE, BF
        arcolor% = ARBLUE
        If mb% Then
            floodfill 1
            moves% = moves% + 1
        End If
    End If
    If mousezone(1095, 175, 1095 + 90, 175 + 90) = TRUE And (level(1, 1) <> 2) Then
        Line (1095, 175)-(1095 + 90, 175 + 90), BROWNCHOICE, BF
        arcolor% = ARPINK
        If mb% Then
            floodfill 2
            moves% = moves% + 1
        End If
    End If
    If mousezone(895, 325, 895 + 90, 325 + 90) = TRUE And (level(1, 1) <> 3) Then
        Line (895, 325)-(895 + 90, 325 + 90), BROWNCHOICE, BF
        arcolor% = ARORANGE
        If mb% Then
            floodfill 3
            moves% = moves% + 1
        End If
    End If
    If mousezone(1095, 325, 1095 + 90, 325 + 90) = TRUE And (level(1, 1) <> 4) Then
        Line (1095, 325)-(1095 + 90, 325 + 90), BROWNCHOICE, BF
        arcolor% = ARYELLOW
        If mb% Then
            floodfill 4
            moves% = moves% + 1
        End If
    End If
    If mousezone(895, 475, 895 + 90, 475 + 90) = TRUE And (level(1, 1) <> 5) Then
        Line (895, 475)-(895 + 90, 475 + 90), BROWNCHOICE, BF
        arcolor% = ARGREEN
        If mb% Then
            floodfill 5
            moves% = moves% + 1
        End If
    End If
    If mousezone(1095, 475, 1095 + 90, 475 + 90) = TRUE And (level(1, 1) <> 6) Then
        Line (1095, 475)-(1095 + 90, 475 + 90), BROWNCHOICE, BF
        arcolor% = ARGRAY
        If mb% Then
            floodfill 6
            moves% = moves% + 1
        End If
    End If
    RotoZoomImage 900 + 40, 180 + 40, tileset&, 0, 0, 40, 40, 2, 0
    RotoZoomImage 1100 + 40, 180 + 40, tileset&, 40, 0, 80, 40, 2, 0
    RotoZoomImage 900 + 40, 330 + 40, tileset&, 80, 0, 80 + 40, 40, 2, 0
    RotoZoomImage 1100 + 40, 330 + 40, tileset&, 120, 0, 120 + 40, 40, 2, 0
    RotoZoomImage 900 + 40, 480 + 40, tileset&, 160, 0, 160 + 40, 40, 2, 0
    RotoZoomImage 1100 + 40, 480 + 40, tileset&, 200, 0, 200 + 40, 40, 2, 0
    _Font middlefont&
    Color _RGB32(10, 15, 200)
    _PrintString (823, 63), "Moves left:" + Str$(maxmoves% - moves%)
    Color _RGB32(158, 158, 227)
    _PrintString (820, 60), "Moves left:" + Str$(maxmoves% - moves%)
End Sub

Sub showtitlescreen
    startgame% = FALSE
    Do
        _Limit 60
        Cls
        Do While _MouseInput
            mx% = _MouseX: my% = _MouseY: mb% = _MouseButton(1)
        Loop
        _PutImage (0, 0), titlescreen&
        Color _RGB32(10, 15, 200)
        _Font bigfont&
        _PrintString (345, 55), "Flood the Board"
        Color _RGB32(158, 158, 227)
        _PrintString (340, 50), "Flood the Board"
        _Font middlefont&
        If mousezone(510, 200, 870, 270) = TRUE Then
            If playonce%(NEWGAME) = 0 Then
                playonce%(NEWGAME) = 1
                _SndPlay selectsnd&
            End If
            Line (505, 195)-(875, 275), BROWNCHOICE, BF
            If mb% Then
                _SndPlay sndconfirm&
                startgame% = TRUE
            End If
        End If
        Line (510, 200)-(870, 235), BTNWHITE, BF
        Line (510, 235)-(870, 270), BTNGRAY, BF
        Color _RGB32(10, 15, 200)
        _PrintString (540, 215), "New Game"
        If mousezone(510, 200, 870, 270) = FALSE Then
            playonce%(NEWGAME) = 0
        End If
        If mousezone(510, 300, 870, 370) = TRUE Then
            If playonce%(ABOUT) = 0 Then
                playonce%(ABOUT) = 1
                _SndPlay selectsnd&
            End If
            Line (505, 295)-(875, 375), BROWNCHOICE, BF
            If mb% Then
                _SndPlay sndconfirm&
                showaboutscreen
            End If
        End If
        Line (510, 300)-(870, 335), BTNWHITE, BF
        Line (510, 335)-(870, 370), BTNGRAY, BF
        Color _RGB32(10, 15, 200)
        _PrintString (600, 315), "About"
        If mousezone(510, 300, 870, 370) = FALSE Then
            playonce%(ABOUT) = 0
        End If
        If mousezone(510, 400, 870, 470) = TRUE Then
            If playonce%(EXITPRG) = 0 Then
                playonce%(EXITPRG) = 1
                _SndPlay selectsnd&
            End If
            Line (505, 395)-(875, 475), BROWNCHOICE, BF
            If mb% Then
                freetheram
                System
            End If
        End If
        Line (510, 400)-(870, 435), BTNWHITE, BF
        Line (510, 435)-(870, 470), BTNGRAY, BF
        Color _RGB32(10, 15, 200)
        _PrintString (550, 415), "Exit Game"
        If mousezone(510, 400, 870, 470) = FALSE Then
            playonce%(EXITPRG) = 0
        End If
        _PutImage (mx%, my%), pointer&
        checkfunctionkey
        _Display
    Loop Until startgame% = TRUE
End Sub

Sub showgameover
    _SndPlay sndgameover&
    back% = FALSE
    Do
        _Limit 60
        Cls
        Do While _MouseInput
            mx% = _MouseX: my% = _MouseY: mb% = _MouseButton(1)
        Loop
        _PutImage (0, 0), titlescreen&
        _Font bigfont&
        Color _RGB32(15, 10, 200)
        _PrintString (435, 55), "Game Over"
        Color _RGB32(158, 158, 227)
        _PrintString (430, 50), "Game Over"
        _Font middlefont&
        Color _RGB32(BROWNCHOICE)
        _PrintString (373, 233), "Sorry, no moves left!"
        Color _RGB32(238, 238, 27)
        _PrintString (370, 230), "Sorry, no moves left!"
        If mousezone(510, 600, 870, 670) = TRUE Then
            If playonce%(GOBACK) = 0 Then
                playonce%(GOBACK) = 1
                _SndPlay selectsnd&
            End If
            Line (505, 595)-(875, 675), BROWNCHOICE, BF
            If mb% Then
                _SndPlay sndconfirm&
                back% = TRUE
            End If
        End If
        Line (510, 600)-(870, 635), BTNWHITE, BF
        Line (510, 635)-(870, 670), BTNGRAY, BF
        Color _RGB32(10, 15, 200)
        _PrintString (610, 615), "Back"
        If mousezone(510, 600, 870, 670) = FALSE Then
            playonce%(GOBACK) = 0
        End If
        _PutImage (mx%, my%), pointer&
        checkfunctionkey
        _Display
    Loop Until back% = TRUE
End Sub

Sub showcongratulations
    back% = FALSE
    _SndPlay sndwin&
    Do
        _Limit 60
        Cls
        Do While _MouseInput
            mx% = _MouseX: my% = _MouseY: mb% = _MouseButton(1)
        Loop
        _PutImage (0, 0), titlescreen&
        _Font bigfont&
        Color _RGB32(15, 10, 200)
        _PrintString (305, 55), "Congratulations!"
        Color _RGB32(158, 158, 227)
        _PrintString (300, 50), "Congratulations!"
        _Font middlefont&
        Color _RGB32(BROWNCHOICE)
        'MessageBox "Congratulations!", "You win with " + Str$(moves%) + " moves!"
        _PrintString (353, 233), "You win with " + Str$(moves%) + " moves!"
        Color _RGB32(238, 238, 27)
        _PrintString (350, 230), "You win with " + Str$(moves%) + " moves!"
        If mousezone(510, 600, 870, 670) = TRUE Then
            If playonce%(GOBACK) = 0 Then
                playonce%(GOBACK) = 1
                _SndPlay selectsnd&
            End If
            Line (505, 595)-(875, 675), BROWNCHOICE, BF
            If mb% Then
                _SndPlay sndconfirm&
                back% = TRUE
            End If
        End If
        Line (510, 600)-(870, 635), BTNWHITE, BF
        Line (510, 635)-(870, 670), BTNGRAY, BF
        Color _RGB32(10, 15, 200)
        _PrintString (610, 615), "Back"
        If mousezone(510, 600, 870, 670) = FALSE Then
            playonce%(GOBACK) = 0
        End If
        _PutImage (mx%, my%), pointer&
        checkfunctionkey
        _Display
    Loop Until back% = TRUE
End Sub

Sub showaboutscreen
    back% = FALSE
    Do
        _Limit 60
        Cls
        Do While _MouseInput
            mx% = _MouseX: my% = _MouseY: mb% = _MouseButton(1)
        Loop
        _PutImage (0, 0), titlescreen&
        _Font bigfont&
        Color _RGB32(15, 10, 200)
        _PrintString (555, 55), "About"
        Color _RGB32(158, 158, 227)
        _PrintString (550, 50), "About"
        _Font smallfont&
        Color _RGB32(238, 238, 27)
        _PrintString (50, 230), "Welcome to 'Flood the Board'"
        _PrintString (50, 260), "The goal of the game is simple:"
        _PrintString (50, 290), "Flood the entire board with a single color in the fewest number of moves possible."
        _PrintString (50, 330), "Start by selecting a color on the edge of the board, and watch as the color spreads,"
        _PrintString (50, 360), "changing adjacent tiles to match."
        _PrintString (50, 400), "Strategically plan your moves to conquer the board"
        _PrintString (50, 430), "and achieve the ultimate flood domination!"
        Color _RGB32(255, 50, 50)
        _PrintString (50, 490), "Made by Markus Mangold 2024 with QB64 Phoenix Edition"
        Color _RGB32(238, 238, 27)
        _PrintString (50, 550), "Press [F] to toggle fullscreen"

        _Font middlefont&
        If mousezone(510, 600, 870, 670) = TRUE Then
            If playonce%(GOBACK) = 0 Then
                playonce%(GOBACK) = 1
                _SndPlay selectsnd&
            End If
            Line (505, 595)-(875, 675), BROWNCHOICE, BF
            If mb% Then
                _SndPlay sndconfirm&
                back% = TRUE
            End If
        End If
        Line (510, 600)-(870, 635), BTNWHITE, BF
        Line (510, 635)-(870, 670), BTNGRAY, BF
        Color _RGB32(10, 15, 200)
        _PrintString (610, 615), "Back"
        If mousezone(510, 600, 870, 670) = FALSE Then
            playonce%(GOBACK) = 0
        End If
        _PutImage (mx%, my%), pointer&
        checkfunctionkey
        _Display
    Loop Until back% = TRUE
End Sub

Sub drawlevel
    success% = TRUE
    For x% = 1 To columns%
        For y% = 1 To rows%
            leveltile% = level(x%, y%)
            Select Case leveltile%
                Case 1: _PutImage ((x% - 1) * 40 + xoffset%, (y% - 1) * 40 + yoffset%), tileset&, , (0, 0)-(40, 40)
                Case 2: _PutImage ((x% - 1) * 40 + xoffset%, (y% - 1) * 40 + yoffset%), tileset&, , (40, 0)-(80, 40)
                Case 3: _PutImage ((x% - 1) * 40 + xoffset%, (y% - 1) * 40 + yoffset%), tileset&, , (80, 0)-(80 + 40, 40)
                Case 4: _PutImage ((x% - 1) * 40 + xoffset%, (y% - 1) * 40 + yoffset%), tileset&, , (120, 0)-(120 + 40, 40)
                Case 5: _PutImage ((x% - 1) * 40 + xoffset%, (y% - 1) * 40 + yoffset%), tileset&, , (160, 0)-(160 + 40, 40)
                Case 6: _PutImage ((x% - 1) * 40 + xoffset%, (y% - 1) * 40 + yoffset%), tileset&, , (200, 0)-(200 + 40, 40)
            End Select
            If level(x%, y%) <> level(1, 1) Then success% = FALSE
        Next
    Next
    Line (195, 95)-(195 + 565, 100), BROWNCHOICE, BF
    Line (195, 95)-(195 + 5, 100 + 565), BROWNCHOICE, BF
    Line (200 + 560, 95)-(200 + 565, 100 + 565), BROWNCHOICE, BF
    Line (200, 560 + 100)-(200 + 565, 100 + 565), BROWNCHOICE, BF
End Sub

Sub drawarrow
    Select Case arcolor%
        Case ARWHITE: _PutImage (arrowx% - 20, 95), arrow&, , (0, 0)-(39, 39)
        Case ARBLUE: _PutImage (arrowx% - 20, 95), arrow&, , (39, 0)-(79, 39)
        Case ARPINK: _PutImage (arrowx% - 20, 95), arrow&, , (79, 0)-(119, 39)
        Case ARORANGE: _PutImage (arrowx% - 20, 95), arrow&, , (119, 0)-(159, 39)
        Case ARYELLOW: _PutImage (arrowx% - 20, 95), arrow&, , (159, 0)-(199, 39)
        Case ARGREEN: _PutImage (arrowx% - 20, 95), arrow&, , (199, 0)-(239, 39)
        Case ARGRAY: _PutImage (arrowx% - 20, 95), arrow&, , (239, 0)-(279, 39)
    End Select
End Sub

Function mousezone% (x1 As Integer, y1 As Integer, x2 As Integer, y2 As Integer)
    If (mx% >= x1) And (mx% <= x2) And (my% >= y1) And (my% <= y2) Then
        mousezone% = TRUE
    Else
        mousezone% = FALSE
    End If
End Function

'thanks to bplus for the algorithm, from here: https://qb64.boards.net/thread/267/floodfill-recursive-algorithm
Sub floodfill (fill) ' needs max, min functions mod of my Paint3 sub
    Dim fillColor, W, H, parentF, tick, ystart, ystop, xstart, xstop, x, y
    fillColor = level(1, 1)
    W = columns%: H = rows%
    Dim temp(1 To W, 1 To H)
    temp(1, 1) = 1: parentF = 1
    'PSet (1, 1), fill
    level(1, 1) = fill
    While parentF = 1
        parentF = 0: tick = tick + 1
        ystart = max(1 - tick, 1): ystop = min(1 + tick, H)
        y = ystart
        While y <= ystop
            xstart = max(1 - tick, 1): xstop = min(1 + tick, W)
            x = xstart
            While x <= xstop
                If level(x, y) = fillColor And temp(x, y) = 0 Then
                    If temp(max(1, x - 1), y) Then
                        temp(x, y) = 1: parentF = 1: level(x, y) = fill
                    ElseIf temp(min(x + 1, W), y) Then
                        temp(x, y) = 1: parentF = 1: level(x, y) = fill
                    ElseIf temp(x, max(y - 1, 1)) Then
                        temp(x, y) = 1: parentF = 1: level(x, y) = fill
                    ElseIf temp(x, min(y + 1, H)) Then
                        temp(x, y) = 1: parentF = 1: level(x, y) = fill
                    End If
                End If
                x = x + 1
            Wend
            y = y + 1
        Wend
    Wend
End Sub

Function max (n1, n2)
    If n1 > n2 Then max = n1 Else max = n2
End Function
Function min (n1, n2)
    If n1 > n2 Then min = n2 Else min = n1
End Function

Sub checkfunctionkey
    If InKey$ = LCase$("f") Then
        If _FullScreen = 0 Then
            _FullScreen _Stretch , _Smooth
        Else
            _FullScreen _Off
        End If
    End If
End Sub

Sub freetheram
    _MouseShow
    _Font 16
    _FreeImage pointer&
    _FreeImage background&
    _FreeImage tileset&
    _FreeImage arrow&
    _FreeImage iconimage&
    _FreeImage titlescreen&

    _FreeFont bigfont&
    _FreeFont smallfont&
    _FreeFont middlefont&

    _SndClose music&
    _SndClose sndconfirm&
    _SndClose selectsnd&
    _SndClose sndwin&
    _SndClose sndgameover&
End Sub


'$Include: 'pulsar.bi'
