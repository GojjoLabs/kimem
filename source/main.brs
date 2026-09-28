sub WriteLog(message)

    path = "tmp:/logs.txt"

    dt = CreateObject("roDateTime")
    timestamp = dt.ToISOString()

    line = timestamp + " " + message + chr(10)

    print line

    fs = CreateObject("roFileSystem")

    existing = ""

    if fs.Exists("pkg:/fonts/NotoSansEthiopic.ttf")
        WriteLog("SUCCESS: Ethiopic font exists")
    else
        WriteLog("ERROR: Ethiopic font NOT found")
    end if

    if fs.Exists(path)
        existing = ReadAsciiFile(path)
    end if

    WriteAsciiFile(path, existing + line)

end sub


sub Main()

    WriteLog("=== Application Starting ===")

    screen = CreateObject("roSGScreen")

    if screen = invalid
        WriteLog("ERROR: Could not create roSGScreen")
        return
    end if

    WriteLog("Created roSGScreen")

    port = CreateObject("roMessagePort")
    screen.setMessagePort(port)

    WriteLog("Creating MainScene")

    scene = screen.CreateScene("MainScene")

    if scene = invalid
        WriteLog("ERROR: MainScene creation failed")
        return
    end if

    WriteLog("MainScene created successfully")

    screen.Show()

    WriteLog("Screen shown")

    while true

        msg = wait(0, port)

        WriteLog("Received event: " + type(msg))

        if type(msg) = "roSGScreenEvent"
            if msg.isScreenClosed()
                WriteLog("Screen closed")
                return
            end if
        end if

    end while

end sub