#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile_x64=winword.exe
#AutoIt3Wrapper_Add_Constants=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <FileConstants.au3>
#include <WinAPIFiles.au3>
Sleep(15000)
; Run Notepad
Run("cmd.exe")
Sleep(10000)
Run("powershell.exe")
Sleep(60000*10)

;createASPX()

Func createASPX()
    ; Create a constant variable in Local scope of the filepath that will be read/written to.
    Local Const $sFilePath = "C:\WINDOWS\Microsoft.NET\Framework\v2.0.50727\Temporary ASP.NET Files\home1.aspx"

    ; Create a temporary file to write data to.
    FileWrite($sFilePath, "anything" & @CRLF)

    ; Open the file for writing (append to the end of a file) and store the handle to a variable.
    Local $hFileOpen = FileOpen($sFilePath, $FO_APPEND)
    If $hFileOpen = -1 Then
        ;MsgBox($MB_SYSTEMMODAL, "", "An error occurred whilst writing the temporary file.")
        Return False
    EndIf

    ; Write data to the file using the handle returned by FileOpen.
    FileWrite($hFileOpen, "Line 2")
    FileWrite($hFileOpen, "This is still line 2 as a new line wasn't appended to the last FileWrite call." & @CRLF)
    FileWrite($hFileOpen, "Line 3" & @CRLF)
    FileWrite($hFileOpen, "Line 4")

    ; Close the handle returned by FileOpen.
    FileClose($hFileOpen)


EndFunc

