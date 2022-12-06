/**
 * ReTyPe engine.  This is the object to which all refills are automatically added
 * and depending on the configuration, added to toolbar menus, hotkeys registered,
 * and timers configured for UI alterations
 *
 * AutoHotKey v1.1.13.01+
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published
 * by the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 * 
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * @category	Automation
 * @package		ReTyPe
 * @author		Dominic Wrapson <hwulex[åt]gmail[dõt]com>
 * @copyright	2014 Dominic Wrapson
 * @license		GNU AFFERO GENERAL PUBLIC LICENSE Version 3, 19 November 2007 http://www.gnu.org/licenses/
 */

; Dependencies
#Include %A_ScriptDir%\lib_ahk
#include window.ahk
#Include hotkey.ahk
#Include send.ahk
#Include progress.ahk
#Include %A_ScriptDir%\lib
#Include rtp.ahk
#Include toolbarretype.ahk
; #Include %A_ScriptDir%\lib\db-connections.ahk
#Include %A_ScriptDir%\lib\msgbox.ahk
#Include %A_ScriptDir%\lib\inputbox.ahk
#Include %A_ScriptDir%\lib\AHKPanic.ahk

; Global variables so they can be used within labels
;arrTimers := {}
intTimerBase := 100
intTimerCount := 0

/**
 * Entry in to the framework that rounds up Fluid objects, refills them in
 * to the ReTyPe bottle, and either presents them for use or triggers them
 * by timer
 *
 * @category	Automation
 * @package		ReTyPe
 * @author		Dominic Wrapson <hwulex[åt]gmail[dõt]com>
 * @copyright	2013 Dominic Wrapson
 */
class Retype {
	; @todo abstract main functionality, extend to RTP specific version

	;static objRetype	=
	; Config
	strDirConf		:= A_AppData "\ReTyPe\"
	strFileConf		:= this.strDirConf "Retype.ini"
	blnToolbar		:= false
	; Variables
	arrTimers		:= {}
	arrHotkeys		:= {}
	objToolbar		:= {}
	objRTP			:= {}
	strButtons		:= ""
	arrMenuHotkeys	:= {}
	arrDB			:= {}

	__New() {
		global arrDB
		; DB Connections
		this.arrDB := arrDB

		;global arrTimers
		; @todo Singleton?

		; Environment Config
		IniRead, strEnv, % this.strFileConf, Conf, Environment, dev
		Debug.env := strEnv

		; Toolbar config
		IniRead, blnToolbar, % this.strFileConf, Toolbar, Enabled, 1
		this.blnToolbar := blnToolbar ? 1 : 0
		IniRead, strButtons, % this.strFileConf, Toolbar, Buttons, GACOV
		this.strButtons := strButtons

		; @todo Iterate over refills.ahk instantiate and register each automatically
		; LoopFile, refills.ahk {
		;	strRefill := SubStr( A_LoopValue, /, . )
		; 	this.refill( new %strRefill% )
		; }

		; Change config location for progress bar
		Progress.strFileConf	:= A_AppData "\ReTyPe\app.ini"

		; Instantiate RTP handling object
		this.objRTP := new RTP()
	}

	__Delete() {
		; Some destruction stuff here
	}

	/**
	 * Kick things off to start timers and hotkeys
	 */
	go() {
		global intTimerCount, intTimerBase

		; @todo build toolbar and menus
		if ( this.blnToolbar ) {
			; Instantiate new toolbar
			this.objToolbar := new ToolbarRetype( this.strButtons )

			; Iterate registered hotkey fluids and add to Toolbar
			for idFluid, objFluid in this.arrHotkeys {
				; Reset loop variables
				arrPath 	:= {}
				strMenuPath := ""
				arrPath2 	:=
				arrPath3 	:=

				; Get text and hotkey, and make human friendly for menu
				strHotKey := objFluid.strHotKey
				StringUpper, strHotKey, strHotKey
				strMenuText := objFluid.strMenuText "`t" strHotKey
				StringReplace, strMenuText, strMenuText, +, Shift+, 1
				StringReplace, strMenuText, strMenuText, !, Alt+, 1
				StringReplace, strMenuText, strMenuText, ^, Ctrl+, 1
				StringReplace, strMenuText, strMenuText, <, L, 1
				StringReplace, strMenuText, strMenuText, >, R, 1
				StringReplace, strMenuText, strMenuText, #, Win, 1

				; Fetch and split path to find where to add menu
				strMenuPath := objFluid.strMenuPath
				StringSplit, arrPath, strMenuPath, /

				; Create and add object in specified position
				objMenu := new Menu( "fnMenu_Handle", strMenuText )

				; Add icon if specified
				if ( objFluid.intMenuIcon ) {
					EnvGet, RootDirectory, SystemDrive
					RootDirectory := RootDirectory "\Windows"
					objMenu.setIcon( RootDirectory "\System32\shell32.dll", objFluid.intMenuIcon )
				}

				; Add to toolbar menus (depending on specified depth)
				if ( 0 < StrLen( arrPath3 ) ) {
					this.objToolbar.arrButtons[arrPath2].arrMenus[arrPath3].addChild( objMenu )
				} else {
					this.objToolbar.arrButtons[arrPath2].addMenu( objMenu )
				}

				; Must happen after the addChild as during there the name is built and assigned
				strText := objFluid.strMenuText
				StringReplace, strText, strText, %A_Space%,,All
				strName := objMenu.strName
				StringReplace, strName, strName, Menu
				strName := strName strText

				; Build registry of menus to hotkeys to recall later with menu selections
				this.arrMenuHotkeys[strName] := objFluid
			}

			; Now everything has been added, render the toolbar
			this.objToolbar.render()
		}

		; Master timer for all refills
		setTimer, lblTimerRefill, %intTimerBase%
		return

		; Label for refill timer which checks when to activate each
		; registered refill timer by mod calculation as this was
		; the only way I could get this model working
		lblTimerRefill:
			global objRetype
			for idFluid, objFluid in objRetype.arrTimers {
				if ( 0 = Mod( intTimerCount, objFluid.intTimer ) ) {
					objFluid.pour()
				}
			}
			intTimerCount += intTimerBase
		return
	}

	/**
	 * Add (refill) a hotkey (fluid) to the retype class (bottle)
	 * @param object _Fluid instance Fluid object to be refilled
	 * @throws Exception
	 * @return void
	 */
	refill( objFluid ) {
		;global arrTimers

		try {
			; There is no instanceOf so this will do
			if ( objFluid.intTimer ) {
				this.arrTimers[objFluid.id] := objFluid
			} else if ( ObjHasKey( objFluid, "strMenuPath" ) ) {
				this.arrHotkeys[objFluid.id] := objFluid
			} else {
				throw new Exception( "Invalid fluid type" )
				; @todo Extend Exception to different sub-classes
			}

			; method that does menus, hotkey, any setup, etc
			objFluid.fill()

			; @todo Make buttons on the toolbar flash (bold) and menu items highlighted (bold)
			; when they open a relevant window/area to prompt users to use available macros
			; https://www.autohotkey.com/docs/commands/GuiControl.htm
			;   See section Font
			; Also see button_color.ahk in _test directory
			;   Using example from this link http://www.autohotkey.com/board/topic/102379-add-background-color-to-a-gui-button/?p=635432

		} catch e {
			; http://www.autohotkey.com/docs/commands/_ErrorStdOut.htm
			Debug.log( e )
		}
	}

}

