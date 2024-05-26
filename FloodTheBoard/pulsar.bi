Sub FillCircle (cx As Integer, cy As Integer, r As Integer)
    Dim x As Integer, y As Integer, r2 As Integer, dx As Integer
    If r = 0 Then
        r = 1
    End If
    r2 = r * r
    For x = r To 0 Step -1
        y = Int(Sqr(r2 - x * x))
        dx = cx - x
        Line (dx - 1, cy - y)-(dx - 1, cy + y)
        dx = cx + x
        Line (dx, cy - y)-(dx, cy + y)
    Next
End Sub

Sub Triangle (x1 As Integer, y1 As Integer, x2 As Integer, y2 As Integer, x3 As Integer, y3 As Integer)
    Line (x1, y1)-(x2, y2)
    Line (x2, y2)-(x3, y3)
    Line (x3, y3)-(x1, y1)
End Sub

Sub FillTriangle (xa As Integer, ya As Integer, xb As Integer, yb As Integer, xc As Integer, yc As Integer)
    Dim y1 As Long, y2 As Long, y3 As Long, x1 As Long, x2 As Long, x3 As Long
    Dim dx12 As Long, dx13 As Long, dx23 As Long
    Dim dy12 As Long, dy13 As Long, dy23 As Long, dy As Long
    Dim a As Long, b As Long
    If ya = yb Then
        yb = yb + 1
    End If
    If ya = yc Then
        yc = yc + 1
    End If
    If yc = yb Then
        yb = yb + 1
    End If
    If (ya <> yb) And (ya <> yc) And (yc <> yb) Then
        If (ya > yb) And (ya > yc) Then
            y1 = ya: x1 = xa
            If yb > yc Then
                y2 = yb: x2 = xb
                y3 = yc: x3 = xc
            Else
                y2 = yc: x2 = xc
                y3 = yb: x3 = xb
            End If
        Else
            If (yb > ya) And (yb > yc) Then
                y1 = yb: x1 = xb
                If ya > yc Then
                    y2 = ya: x2 = xa
                    y3 = yc: x3 = xc
                Else
                    y2 = yc: x2 = xc
                    y3 = ya: x3 = xa
                End If
            Else
                If (yc > yb) And (yc > ya) Then
                    y1 = yc: x1 = xc
                    If yb >= ya Then
                        y2 = yb: x2 = xb
                        y3 = ya: x3 = xa
                    Else
                        y2 = ya: x2 = xa
                        y3 = yb: x3 = xb
                    End If
                End If
            End If
        End If
        dx12 = x2 - x1: dy12 = y2 - y1
        dx23 = x3 - x2: dy23 = y3 - y2
        dx13 = x3 - x1: dy13 = y3 - y1
        a = x2 - ((y2 - y3 + dy23) * dx23) / dy23
        b = x3 + (-dy23 * dx13) / (dy13)
        If (a < b) Then
            Line (a, y2)-(b, y2)
            For dy = 0 To -dy23 - 1
                a = x2 + ((dy23 + dy) * dx23) / dy23
                b = x3 + (dy * dx13) / (dy13)
                Line (a, dy + y3)-(b, dy + y3)
            Next
            For dy = -dy23 + 1 To -dy13
                a = x2 + ((dy23 + dy) * dx12) / dy12
                b = x3 + (dy * dx13) / (dy13)
                Line (a, dy + y3)-(b, dy + y3)

            Next
        Else
            Line (b, y2)-(a, y2)
            For dy = 0 To -dy23 - 1
                a = x2 + ((dy23 + dy) * dx23) / dy23
                b = x3 + (dy * dx13) / (dy13)
                Line (a, dy + y3)-(b, dy + y3)
            Next
            For dy = -dy23 + 1 To -dy13
                a = x2 + ((dy23 + dy) * dx12) / dy12
                b = x3 + (dy * dx13) / (dy13)
                Line (a, dy + y3)-(b, dy + y3)
            Next
        End If
    End If

End Sub

Sub FillEllipse (xc As Integer, yc As Integer, wwidth As Integer, hheight As Integer)
    Dim x As Integer, y As Integer

    For y = -hheight To hheight
        For x = -wwidth To wwidth
            If (x * x * hheight * hheight + y * y * wwidth * wwidth <= hheight * hheight * wwidth * wwidth) Then
                PSet (xc + x, yc + y)
            End If
        Next
    Next
End Sub

Sub Ellipse (CX As Long, CY As Long, XRadius As Long, YRadius As Long)
    Dim X As Long, Y As Long
    Dim XChange As Long, YChange As Long
    Dim EllipseError As Long
    Dim TwoASquare As Long, TwoBSquare As Long
    Dim StoppingX As Long, StoppingY As Long
    If XRadius = YRadius Then
        YRadius = YRadius + 1
    End If
    TwoASquare = 2 * XRadius * XRadius
    TwoBSquare = 2 * YRadius * YRadius
    X = XRadius
    Y = 0
    XChange = YRadius * YRadius * (1 - 2 * XRadius)
    YChange = XRadius * XRadius
    EllipseError = 0
    StoppingX = TwoBSquare * XRadius
    StoppingY = 0
    While (StoppingX >= StoppingY)
        PSet (CX + X, CY + Y)
        PSet (CX - X, CY + Y)
        PSet (CX - X, CY - Y)
        PSet (CX + X, CY - Y)
        Y = Y + 1
        StoppingY = StoppingY + TwoASquare
        EllipseError = EllipseError + YChange
        YChange = YChange + TwoASquare
        If ((2 * EllipseError + XChange) > 0) Then
            X = X - 1
            StoppingX = StoppingX - TwoBSquare
            EllipseError = EllipseError + XChange
            XChange = XChange + TwoBSquare
        End If
    Wend
    X = 0
    Y = YRadius
    XChange = YRadius * YRadius
    YChange = XRadius * XRadius * (1 - 2 * YRadius)
    EllipseError = 0
    StoppingX = 0
    StoppingY = TwoASquare * YRadius
    While (StoppingX <= StoppingY)
        PSet (CX + X, CY + Y)
        PSet (CX - X, CY + Y)
        PSet (CX - X, CY - Y)
        PSet (CX + X, CY - Y)
        X = X + 1
        StoppingX = StoppingX + TwoBSquare
        EllipseError = EllipseError + XChange
        XChange = XChange + TwoBSquare
        If ((2 * EllipseError + YChange) > 0) Then
            Y = Y - 1
            StoppingY = StoppingY - TwoASquare
            EllipseError = EllipseError + YChange
            YChange = YChange + TwoASquare
        End If
    Wend
End Sub

Sub RotoZoomImage (X As Integer, Y As Integer, Image As Long, startx As Integer, starty As Integer, xoffset As Integer, yoffset As Integer, Scale As Single, Rotation As Single)
        
    Dim px(3) As Single: Dim py(3) As Single
    W& = _Width(Image&): H& = _Height(Image&)
    px(0) = (-xoffset + startx) / 2: py(0) = (-yoffset + starty) / 2: px(1) = (-xoffset + startx) / 2: py(1) = (yoffset - starty) / 2
    px(2) = (xoffset - startx) / 2: py(2) = (yoffset - starty) / 2: px(3) = (xoffset - startx) / 2: py(3) = (-yoffset + starty) / 2
    sinr! = Sin(-Rotation / 57.2957795131): cosr! = Cos(-Rotation / 57.2957795131)
    For i& = 0 To 3
        x2& = Scale * (px(i&) * cosr! + sinr! * py(i&)) + X: y2& = Scale * (py(i&) * cosr! - px(i&) * sinr!) + Y
        px(i&) = x2&: py(i&) = y2&
    Next
    _MapTriangle (startx, starty)-(startx, yoffset - 1)-(xoffset - 1, yoffset - 1), Image& To(px(0), py(0))-(px(1), py(1))-(px(2), py(2))
    _MapTriangle (startx, starty)-(xoffset - 1, starty)-(xoffset - 1, yoffset - 1), Image& To(px(0), py(0))-(px(3), py(3))-(px(2), py(2))
   

End Sub

Function Boxcoll% (x1 As Integer, y1 As Integer, w1 As Integer, h1 As Integer, x2 As Integer, y2 As Integer, w2 As Integer, h2 As Integer)

    If x2 + w2 < x1 Then Boxcoll% = false
    If x2 > x1 + w1 Then Boxcoll% = false

    If y2 + h2 < y1 Then Boxcoll% = false
    If y2 > y1 + h1 Then Boxcoll% = false

    Boxcoll% = true
End Function

