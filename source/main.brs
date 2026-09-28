'*************************************************************
' Roku SceneGraph Application
'*************************************************************

sub Main()

    print "Starting ቅመም Roku application"

    ' Create the SceneGraph screen
    screen = CreateObject("roSGScreen")

    ' Create message port
    m.port = CreateObject("roMessagePort")
    screen.setMessagePort(m.port)

    ' Load MainScene.xml
    scene = screen.CreateScene("MainScene")

    ' Show the application
    screen.show()

    ' Application event loop
    while true

        msg = wait(0, m.port)

        if type(msg) = "roSGScreenEvent"

            if msg.isScreenClosed()
                return
            end if

        end if

    end while

end sub