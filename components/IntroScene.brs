' ********** Copyright 2016 Roku Corp.  All Rights Reserved. **********  

sub init()
    m.top.SetFocus(true)
    m.myLabel = m.top.findNode("myLabel")

    'Set the font size
    m.myLabel.font.size=92

    'Set the color to light blue
    m.myLabel.color="0x72D7EEFF"
    
End sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    result = false
    
    return result 
end function
