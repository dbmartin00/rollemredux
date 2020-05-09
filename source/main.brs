sub Main()
    showChannelSGScreen()
end sub

sub showChannelSGScreen()
    screen = CreateObject("roScreen")
    port = CreateObject("roMessagePort")
    screen.SetMessagePort(port)

    width = screen.GetWidth()
    height = screen.GetHeight()
    white = &hDDDDDDFF
    dark_gray = &h919498FF
    green = &h00FF00FF
    black = &h000000FF
    blue = &h007C9C7F
        
    fontRegistry = CreateObject("roFontRegistry")
    font = fontRegistry.GetDefaultFont()
    instructionFont = fontRegistry.GetDefaultFont(90,true,false)
    
    number_width = width / 4  
    number_height = height / 2
     screen.finish()
    state = 2
    notFinished = true
    offset = 40
    print "Entering CHOOSE A DIE rendering loop"
    while notFinished
        screen.DrawRect(0, 0, width,height,white)  
        screen.DrawText("CHOOSE A DIE",width / 4 + 100, height / 4,blue, instructionFont)
        upper_x = 0
        upper_y = number_height - 25
        if state = 0
            upper_x = 0 + (number_width / 2) - offset
        else if state = 1
            upper_x = number_width + (number_width / 2) - offset
        else if state = 2
            upper_x = (number_width * 2) + (number_width / 2) - offset
        else if state = 3
            upper_x = (number_width * 3) + (number_width / 2) - offset
        else
            print "unexpected state: " + StrI(state)
        end if
        screen.DrawRect(upper_x, upper_y,100,100,dark_gray)
        screen.DrawText("2", 0 + (number_width / 2), number_height, black, font)
        screen.DrawText("6", number_width + (number_width / 2), number_height, black, font)
        screen.DrawText("8", (number_width * 2) + (number_width / 2), number_height, black, font)
        screen.DrawText("20", (number_width * 3) + (number_width / 2), number_height, black, font)   
        screen.finish()
        
        print "Entering CHOOSE A DIE input loop"
        msg = wait(0, port) ' wait for a message
        if type(msg) = "roUniversalControlEvent" then
            if(msg.isPress()) then
                print "key:" + StrI(msg.GetKey())
                if msg.getKey() = 4
                    if state > 0 
                        state = state - 1
                    endif
                else if msg.getKey() = 3
                    if state > 0
                        state = state - 1
                    endif
                else if msg.getKey() = 5
                    if state < 3
                        state = state + 1
                    endif
                else if msg.getKey() = 2
                    if state < 3
                        state = state + 1
                    endif
                else if msg.getKey() = 6
                    notFinished = false
                else if msg.getKey() = 0
                    return
                endif
            endif         
        endif
    end while
    
    count = 8
    if(state = 0)
        count = 2 
    else if (state = 1)
        count = 6
    else if (state = 2) 
        count = 8
    else if (state = 3)
        count = 20
    else
        print "unexpected state: " + StrI(state)
    endif
    
    print "4"
    
    screen = CreateObject("roScreen")
    m.port = CreateObject("roMessagePort")
    screen.setMessagePort(m.port)

    rolls = CreateObject("roAssociativeArray")    
    

    for i = 1 to count Step 1
        rolls[StrI(i)] = 0
    end for
    
    for j = 1 to 75000 Step 1
        roll = Rnd(count)
        rolls[StrI(roll)] = rolls[StrI(roll)] + 1
    end for

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
    blue = &h779DC2FF
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
    print "Just before screen.Finish()"
    screen.Finish()
    
    print "Entering exit loop"
    port = CreateObject("roMessagePort")
    screen.SetMessagePort(port)
    
    notFinished = true
    while notFinished        
        msg = wait(0, port)
        if type(msg) = "roUniversalControlEvent" then
            if(msg.isPress()) then
                print "key:" + StrI(msg.GetKey())
                notFinished = false
            endif         
        else
            print "finishing on msg: " + StrI(msg.GetKey())
            notFinished = false
        endif
    end while
end sub
