/**
 * File containing Refill class to add text-searching for access codes to components
 * Class will add itself to the parent retype instance
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


; Trigger my damn self (in a horrible way due to AHK limitations)
objRetype.refill( new FluidAccessRuleLocationGroup() )


/**
 * Refill to add text-search box to components for access codes
 *
 * @category	Automation
 * @package		ReTyPe
 * @author		Dominic Wrapson <hwulex[åt]gmail[dõt]com>
 * @copyright	2014 Dominic Wrapson
 */
class FluidAccessRuleLocationGroup extends Fluid {

	static intTimer		:= 200

	/**
	 * Setup controls, window group, etc
	 */
	__New() {
		global objRetype
		base.__New()

		strGroup	:= this.id
		strRTP		:= % objRetype.objRTP.classNN()
		GroupAdd, %strGroup%, ahk_class %strRTP%, Access Location Group
	}

	/**
	 * Add text-searching for access codes to components
	 */
	pour() {
		Global

		; Get RTP window for later reference
		strRTP		:= % objRetype.objRTP.classNN()
		WinGet, idWinRTP, ID, ahk_class %strRTP%, Access Location Group

		; Build the GUI and do stuff
		strGroup := this.__Class
		IfWinActive, ahk_group %strGroup%
		{
			; WinActive check isn't good enough in this case, so need to make a visual search too
			 
			ImageSearch intActiveX, intActiveY, 175, 30, 265, 65, *50 %A_ScriptDir%\img\search_fluidaccessrulelocationgroup_general.png
			If ( !ErrorLevel ) {
				strControl := objRetype.objRTP.formatClassNN( "COMBOBOX", this.getConf( "ComboBox", 11 ) )
				WinGetPos, intWinX, intWinY,,,
				ControlGetPos, intCtlX, intCtlY,,, %strControl%,
				intGuiX := intWinX + intCtlX -43
				intGuiY := intWinY + intCtlY
; @todo check x/y values before proceeding in case config or combo not found and fails
				IfWinExist, AccessLocationCode ahk_class AutoHotkeyGUI
				{
					Gui, AccessLocationCode:Show, NA x%intGuiX% y%intGuiY%, AccessLocationCode
				} else {
					Gui, AccessLocationCode:Add, Edit, x0 y0 w40 gfnSearchAccessRuleLocationTextbox Limit5 Uppercase vFind
					Gui, AccessLocationCode:Margin, 0, 0
					Gui, AccessLocationCode:-SysMenu +ToolWindow -Caption -Border +AlwaysOnTop
					Gui, AccessLocationCode:Show, NA x%intGuiX% y%intGuiY%, AccessLocationCode
					WinGet, idWinRetype, ID, AccessLocationCode ahk_class AutoHotkeyGUI
				}
				WinActivate, ahk_group %strGroup%
			} else {
				Gui, AccessLocationCode:Destroy
			}
		}

		IfWinNotExist, ahk_group %strGroup%
		{
			Gui, AccessLocationCode:Hide
		}

		; Group the RTP and Retype windows together as it's the only way !WinActive will work
		GroupAdd, grpWinAccessLocationCode, ahk_id %idWinRTP%
		GroupAdd, grpWinAccessLocationCode, ahk_id %idWinRetype%
		If !WinActive("ahk_group grpWinAccessLocationCode")
		{
			; This code stops toolbar showing in other apps
			Gui, AccessLocationCode:Destroy
		}

		; GTFO before the label here below
		return

		/**
		 * Adds a border-less UI with a single button next to the disabled AccessLocationCode combobox
		 * Appears to "add" a button to the UI when in fact it floats above it but never steals focus
		 * Now that's MAGIC!
		 */
		fnSearchAccessRuleLocationTextbox:
			; Get RTP window for later reference
			strRTP		:= % objRetype.objRTP.classNN()
			WinGet, idWin, ID, ahk_class %strRTP%, Access Location Group
			; MsgBox, , Wino,  %idWin%, 

			GuiControlGet, strFind,, Find
			strControl := objRetype.objRTP.formatClassNN( "COMBOBOX", FluidAccessRuleLocationGroup.getConf( "ComboBox", 11 ) )
			Control, ChooseString, %strFind% , %strControl%, ahk_id %idWin%
			;WinActivate, Update ahk_id %idWin%

			;Gui, AccessLocationCode:Hide
		return
	}

}