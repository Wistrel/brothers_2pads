; ===================================
; = Brothers: A Tale of Two Joypads = 
; ===================================
;
; Description:
; A simple little AHK Script to sort out the lack of 2 Joypad
; support in "Brothers: A Tale of Two Sons". To use, you will
; either need AutoHotKey installed (in which case, double click
; the .ahk file once you have saved everything or, if you trust
; me not to steal your secrets, just run the executable.
;
; Instructions:
; To use, run this program then run Brothers. Once you are
; in and have actually started a game press the SELECT button
; on whichever Joypad isn't working. With any luck you now
; have left side control for each of the two brothers, one
; on each Joypad.
;
; Known issues: 
; Unfortunately only running is supported (not walking) on the 
; extra pad. Getting walking working too would involve the
; installation of a lot more kack I'm afraid and a lot more work
; for me to reliably program. It isn't worth it either. First
; time I played the game with a friend, we had no issues both 
; working from a blutooth keyboard each. Running is fine :)


; --- CONSTS ---
AXIS_MAX 	:= 50


; load config
CONFIGFILE	= %A_ScriptDir%\brothers_2pads.ini

IniRead, North,			%CONFIGFILE%, Key Map, 			North
IniRead, East,			%CONFIGFILE%, Key Map, 			East
IniRead, South,			%CONFIGFILE%, Key Map, 			South
IniRead, West,			%CONFIGFILE%, Key Map, 			West
IniRead, Action,		%CONFIGFILE%, Key Map, 			Action
IniRead, ViewLeft,		%CONFIGFILE%, Key Map, 			ViewLeft
IniRead, ViewRight,		%CONFIGFILE%, Key Map, 			ViewRight
IniRead, JoyPad, 		%CONFIGFILE%, Joystick Config, 		JoyPadAddress
IniRead, DEADZONE,		%CONFIGFILE%, Options, 			DeadZone
IniRead, Instructions, 		%CONFIGFILE%, Options, 			ShowInstructions


; set up tray icon
#SingleInstance
Menu, TRAY, Icon, brothers_2pads.ico
Menu, TRAY, Tip, Brothers: A Tale of Two Joypads
TrayTip Brothers: A Tale of Two Joypads, Press CTRL+ESC to exit, 2, 0x11

SetFormat, float, 3.3  ; Omit decimal point from axis position percentages.

; show instructions
if Instructions
{
	MsgBox, 0x40, Brothers: A Tale of Two Joypads, Instructions:`n`nRun this program then run Brothers. Once you are in,` and have actually started a game`, press the SELECT button on whichever Joypad isn't working.`n`nWith any luck you will then have left side control for each of the two brothers`, one on each Joypad.`n`nWhen you have finished playing`, press CTRL+ESC to exit.`n`nAny issues`, try the configuration file as the first port of call. This message will self destruct.
	IniWrite, 0, %CONFIGFILE%, Options, ShowInstructions
}


; --- Main Loop ---
Loop	
{
	; --- Handle View "Axis" ---
	{
		; get button states
		GetKeyState, lookLeft, %JoyPad%joy5
		GetKeyState, lookRight, %JoyPad%joy6

		; save previous key state
		KeyToHoldDownPrev_V = %KeyToHoldDown_V%  ; Prev now holds the key that was down before (if any).

		; determine if we need new key presses
		if (lookLeft == "D" && lookRight == "U")
			KeyToHoldDown_V = %ViewLeft%
		else if (lookRight == "D" && lookLeft == "U")
			KeyToHoldDown_V = %ViewRight%
		else
			KeyToHoldDown_V =

		; check for change of state
		if KeyToHoldDown_V <> %KeyToHoldDownPrev_V%
		{
			; action key releases, if needed
			if KeyToHoldDownPrev_V   ; There is a previous key to release.
				Send, {%KeyToHoldDownPrev_V% up}  ; Release it.
			; action key presses, if needed
			if KeyToHoldDown_V   ; There is a key to press down.
				Send, {%KeyToHoldDown_V% down}  ; Press it down.
		}
	}
	; --- end Handle View "Axis" ---
	
	
	; --- Handle X Axis ---
	{
		; get axis state
		GetKeyState, joyx, %JoyPad%JoyX
		
		; save previous key state
		KeyToHoldDownPrev_X = %KeyToHoldDown_X%  ; Prev now holds the key that was down before (if any).

		; determine if we need new key presses
		if (joyx < AXIS_MAX - DEADZONE)
			KeyToHoldDown_X = %West%
		else if (joyx > AXIS_MAX + DEADZONE)
			KeyToHoldDown_X = %East%
		else
			KeyToHoldDown_X =

		; check for change of state
		if KeyToHoldDown_X <> %KeyToHoldDownPrev_X%
		{
			; action key releases, if needed
			if KeyToHoldDownPrev_X   ; There is a previous key to release.
				Send, {%KeyToHoldDownPrev_X% up}  ; Release it.
			; action key presses, if needed
			if KeyToHoldDown_X   ; There is a key to press down.
				Send, {%KeyToHoldDown_X% down}  ; Press it down.
		}
	}
	; --- end Handle X Axis ---
	
	
	; --- Handle Y Axis ---
	{
		; get axis state
		GetKeyState, joyy, %JoyPad%JoyY
		
		; save previous key state
		KeyToHoldDownPrev_Y = %KeyToHoldDown_Y%  ; Prev now holds the key that was down before (if any).

		; determine if we need new key presses
		if (joyy < AXIS_MAX - DEADZONE)
			KeyToHoldDown_Y = %North%
		else if (joyy > AXIS_MAX + DEADZONE)
			KeyToHoldDown_Y = %South%
		else
			KeyToHoldDown_Y =

		; check for change of state
		if KeyToHoldDown_Y <> %KeyToHoldDownPrev_Y%
		{
			; action key releases, if needed
			if KeyToHoldDownPrev_Y   ; There is a previous key to release.
				Send, {%KeyToHoldDownPrev_Y% up}  ; Release it.
			; action key presses, if needed
			if KeyToHoldDown_Y   ; There is a key to press down.
				Send, {%KeyToHoldDown_Y% down}  ; Press it down.
		}
	}
	; --- end Handle Y Axis ---
	
	
	; --- Handle Action Axis ---
	{
		; get axis state
		GetKeyState, joyz, %JoyPad%JoyZ

		; save previous key state
		KeyToHoldDownPrev_A = %KeyToHoldDown_A%  ; Prev now holds the key that was down before (if any).

		; determine if we need new key press
		if (joyz > AXIS_MAX + DEADZONE)
			KeyToHoldDown_A = %Action%
		else
			KeyToHoldDown_A =

		; check for change of state
		if KeyToHoldDown_A <> %KeyToHoldDownPrev_A%
		{
			; action key releases, if needed
			if KeyToHoldDownPrev_A   ; There is a previous key to release.
				Send, {%KeyToHoldDownPrev_A% up}  ; Release it.
			; action key presses, if needed
			if KeyToHoldDown_A   ; There is a key to press down.
				Send, {%KeyToHoldDown_A% down}  ; Press it down.
		}
	}
	; --- end Handle Action Axis ---
	
	; Update speed (25, 40fps is laggy, 20, 50 fps is poooooosssssibly laggy, 15, 66 fps is fine)
	Sleep, 15 	
}	
; --- end main loop ---

return

; --- Handle Switching Joypads ---

switchJoyPad(selectedJoyPad)
{	
	global CONFIGFILE, JoyPad
	
	
	; change pad
	JoyPad := selectedJoyPad
	
	; update config file (for next time)
	IniWrite, %JoyPad%, %CONFIGFILE%, Joystick Config, JoyPadAddress
	
	; report change
	TrayTip Brothers: A Tale of Two Joypads, Switched to Joypad %JoyPad%, 2, 0x11
	SoundPlay, *64
}

; map SELECT button on each pad to the switchJoyPad function
;	this is ok because the game doesn't use SELECT :)
1joy7::
	switchJoyPad(1)
return

2joy7::
	switchJoyPad(2)
return

3joy7::
	switchJoyPad(3)
return

4joy7::
	switchJoyPad(4)
return

5joy7::
	switchJoyPad(5)
return

6joy7::
	switchJoyPad(6)
return

7joy7::
	switchJoyPad(7)
return

8joy7::
	switchJoyPad(8)
return

9joy7::
	switchJoyPad(9)
return

10joy7::
	switchJoyPad(10)
return

; --- end Handle Switching Pads ---


; EXIT STRATEGY!!!!
^Escape:: 
	TrayTip Brothers: A Tale of Two Joypads, Exiting..., 2, 0x11
	Sleep 7000
	ExitApp	
return
