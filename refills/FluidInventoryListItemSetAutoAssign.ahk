/**
 * File containing Refill class to widen a product window
 * Class will add itself to the parent retype instance
 *
 * AutoHotKey v1.1.13.01+
 *
 * LICENSE:
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.

 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.

 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * @category  	Automation
 * @package   	ReTyPe
 * @author    	Dominic Wrapson <hwulex[åt]gmail[dõt]com>
 * @copyright	Copyright (C) 2015 Dominic Wrapson
 * @license 	GNU AFFERO GENERAL PUBLIC LICENSE http://www.gnu.org/licenses/agpl-3.0.txt
 */

; Trigger my damn self (in a horrible way due to AHK limitations)
objRetype.refill( new FluidInventoryListItemSetAutoAssign() )

/**
 * Refill to widen the Inventory Pool viewer window
 *
 * @category	Automation
 * @package		ReTyPe
 * @author		Tim Esnouf <tim.esnouf[åt]flaik[dõt]com>
 * @copyright	2022 Tim Esnouf
 */
class FluidInventoryListItemSetAutoAssign extends Fluid {

	strHotkey		:= "^!Numpad4"
	strMenuPath		:= "/Admin/"
	strMenuText		:= "AutoAssign Inventory"
	intMenuIcon		:= 132

	; intTimer := 100
	/**
	 * Setup controls, window group, etc
	 */
	__New() {
		global objRetype
		base.__New()

		; strGroup 	:= this.id
		; strRTP		:= % objRetype.objRTP.classNN()
		; GroupAdd, %strGroup%, Add ahk_class %strRTP%, Inventory Pool Location
		; GroupAdd, %strGroup%, Update ahk_class %strRTP%, Inventory Pool Location
		; Create window group for places we want this hotkey active
		strGroup	:= this.__Class
		strRTP		:= % objRetype.objRTP.classNN()
		GroupAdd, %strGroup%, Add ahk_class %strRTP%, Inventory Pool Location
		GroupAdd, %strGroup%, Update ahk_class %strRTP%, Inventory Pool Location
	}
	pour() {
		global objRetype
		; Static variable that maintains its value between executions, so can be used as the new default value in the Iterate prompt
		static intIterate 		:= 1

		; Activate RTP (after toolbar has been clicked)
		objRetype.objRTP.Activate()

		; Create window group for places we want this hotkey active
		; strGroup	:= this.__Class
		; strRTP		:= % objRetype.objRTP.classNN()
		; GroupAdd, %strGroup%, Add ahk_class %strRTP%, Inventory Pool Location
		; GroupAdd, %strGroup%, Update ahk_class %strRTP%, Inventory Pool Location

		; Product window is active
		strGroup := this.__Class
		IfWinActive, ahk_group %strGroup%
		{
			; Did you execute from an RTP window?
			if ( objRetype.objRTP.isActive() ) {
				idWinRTP	:= WinActive("A")

				; Get the ID of the window we're in for later use
				idWin := WinExist("A")
				; Get dimensions for later image searches
				WinGetPos, , , intWw, intHw, ahk_id %idWin%

				; Check they user is only trying to delete list items
				ControlGetFocus, strControlFocus
				if ( !InStr( strControlFocus, "SysListView32" ) AND !InStr( strControlFocus, "Window.8" ) ) {
					MsgBox.stop( "Can only be used to delete items in list views" )
				}

				; Prompt for delete count
				intIterate := InputBox.Show( "Delete how many items?`n`nEnter ALL to delete all remaining entries`nEnter DOWN to delete everything beneath selected row", 1 )
				; Allows entry of ALL to delete all remining listview items
				if ( "ALL" = intIterate ) {
					; Get number of list items
					ControlGet, intItems, List, Count, %strControlFocus%, A
					; Set the iteration counter to the list count
					intIterate := intItems
					Sleep 100
				}
				if ( "DOWN" = intIterate ) {
					ControlGet, intItems, List, Count, %strControlFocus%, A
					ControlGet, intPos, List, Count Focused, %strControlFocus%, A
					intIterate := intItems - intPos + 1
					Sleep 100
					; listitems - listposn
				}
				; Input validation: we want a number please
				If intIterate not between 1 and 999
				{
					ControlFocus, %strControlFocus%, ahk_id %idWin%
					MsgBox.Stop( "You must enter a numerical value between 1 and 999.`n`nYou entered: " . intIterate )
				}
				; Confirmation message for massive delete requests
				if ( 10 < intIterate ) {
					MsgBox.YesNo( "You've asked to delete [" . intIterate . "] entries which seems like a lot. Continue?" )
					IfMsgBox, No
					{
						ControlFocus, %strControlFocus%, ahk_id %idWin%
						return
					}
				}

				Loop, %intIterate% {
					; Set focus to the listview again before we proceed
					; ControlFocus, %strControlFocus%, ahk_id %idWin%

					Send {Tab 2} Space

					;; Wait for the inventory window to open
					strWinInvAdd	= Update Inventory Pool Location

					WinWait , %strWinInvAdd%

					idWinUpdate		:= WinActive("A") ;

					WinActivate, ahk_id %idWinUpdate%

					idCheckBox := objRetype.objRTP.formatClassNN( "BUTTON", FluidInventoryListItemSetAutoAssign.getConf( "BUTTON", 11 ) )

					ControlFocus, %idCheckBox%, , , ,
					ControlGet, valCheckBox , Visible ,, %idCheckBox% , , , ,
					; ControlGetText, valCheckBox , %idCheckBox% , , , ,
					; MsgBox, , Control, %valCheckBox%,

					;;; @tim TODO : lets set this up to check and adjsut all the input pbxes to standard practice
					Control , Check ,, %idCheckBox% ;; this is working to toggle the checkbox on off!
					; Control , UnCheck ,, %idCheckBox%
					; ; WinGet, List, ControlList, A
					; if ( %valCheckBox% = 0) {
					; 	; Control , Check ,, %idCheckBox%
					; 	Send {Tab 6} Space
					; 	Send {Tab } Space
					; 	; MsgBox, , Control, %valCheckBox%,
					; } else {
					; 	Send {Tab 7} Space
					; 	; MsgBox, , Control, %valCheckBox%,
					; }

					Send {Tab 1} Space

					Sleep 50
					ControlFocus, %strControlFocus%, ahk_id %idWin%

					Sleep 50
					Send {Down }
					; Send ^{Tab 2}
					Sleep 50

				}
			}

		}

	}
}
