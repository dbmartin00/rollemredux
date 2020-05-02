' ********** Copyright 2016 Roku Corp.  All Rights Reserved. ********** 

sub Main()
    showChannelSGScreen()
end sub

sub showChannelSGScreen()
    screen = CreateObject("roScreen")
    m.port = CreateObject("roMessagePort")
    screen.setMessagePort(m.port)

    rolls = CreateObject("roAssociativeArray")    
    
    count = 8
    for i = 1 to count Step 1
        rolls[StrI(i)] = 0
    end for
    
    for j = 1 to 25000 Step 1
        roll = Rnd(count)
        rolls[StrI(roll)] = rolls[StrI(roll)] + 1
    end for
 
'    msg = ""
'    winner = ""
'    winning_total = -1
'    for k = 1 to count Step 1
'        msg = msg + StrI(k) + " rolled " + StrI(rolls[StrI(k)]) + " times." + chr(10)
'        if(rolls[StrI(k)] > winning_total)
'            winner = StrI(k)
'            winning_total = rolls[StrI(k)] 
'        end if
'    end for

    minVal = 2000000000
    maxVal = -1
    min = 1
    max = 1
    for k = 1 to count step 1
        if(rolls[StrI(k)] > maxVal) then
            max = k
            maxVal = rolls[StrI(k)]
        end if
        if(rolls[StrI(k)] < minVal) then
            min = k
            minVal = rolls[StrI(k)]
        end if
    end for

    print "David can see this..."
    print "min -> max? " + StrI(minVal) + " -> " + StrI(maxVal)

    spread = maxVal - minVal
    
    width = screen.GetWidth()
    height = screen.GetHeight()
    
    padding = 100
    
    y_axis_height = height - padding - padding
    x_axis_width = width - padding - padding
    
    red =  &hFF0000FF
    blue = &h007C9C7F
    gray = &hCCCDCCFF
    black= &h000000FF
    blue = &h74AAD2FF
    white = &hD5D6D5FF
    dark_gray = &h919498FF
    
    fontRegistry = CreateObject("roFontRegistry")
    font = fontRegistry.GetDefaultFont()
    
    screen.DrawRect(0, 0, width, height, white)
    screen.DrawRect(padding - 25, padding - 25, x_axis_width + 50, y_axis_height + 50, dark_gray)
    screen.DrawRect(padding, padding, x_axis_width, y_axis_height, white)
    screen.DrawLine(padding -1,padding -1, padding + x_axis_width + 1, padding - 1, black)  
    screen.DrawLine( padding + x_axis_width + 1, padding - 1, padding + x_axis_width + 1, padding + y_axis_height + 1, black)  
    screen.DrawLine(padding + x_axis_width + 1, padding + y_axis_height + 1, padding - 1, padding + y_axis_height + 1, black)      
    screen.DrawLine(padding - 1, padding + y_axis_height + 1, padding - 1, padding - 1, black)  
            
    roll_width = x_axis_width / count    
    for i = 1 to count step 1
        
'        upper_x = (i-1) * roll_width + padding
'        upper_y = ((rolls[StrI(i)] - minVal) * (y_axis_height / spread)) + padding        
'        roll_height = (y_axis_height - upper_y) + padding
        
        upper_x = (i-1) * roll_width + padding
        upper_y = (y_axis_height + padding) - ((rolls[StrI(i)] - minVal) * (y_axis_height / spread)) + padding  
        if(upper_y > y_axis_height) then
            upper_y = padding + y_axis_height - 10      
        end if
        roll_height = (y_axis_height - upper_y) + padding
        
        print StrI(upper_x) + ", " + StrI(upper_y) + " (" + StrI(roll_width) + " x " + StrI(roll_height) + ")"
        screen.DrawRect(upper_x,upper_y, roll_width, roll_height, blue)
        screen.DrawLine(upper_x,upper_y,upper_x + roll_width,upper_y, black)
        screen.DrawLine(upper_x,upper_y,upper_x, y_axis_height + 100, black)
        screen.DrawLine(upper_x + roll_width, upper_y, upper_x + roll_width, y_axis_height + 100, black)
        
        text_y = upper_y + 25
        screen.DrawText(StrI(i) + " (" + StrI(rolls[StrI(i)]) + " )", upper_x + (roll_width / 2) - 100, text_y, black, font)
    end for
            
    screen.DrawText("The winner is " + StrI(max) + " with " + StrI(rolls[StrI(max)]) + " rolls!", (width / 2) - 500, 25, red, font)
    screen.Finish()
    
    while(true)
        msg = wait(0, m.port)
        msgType = type(msg)
        print msgType
        return
    end while
end sub
