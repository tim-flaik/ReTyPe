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
objRetype.refill( new FluidDatePickerPortalBiggerer() )

/**
 * Refill to moves the Deferral Calendar and Pricing Seaosn windows up and makes
 * the date portal of death larger.
 *
 * @category	Automation
 * @package		ReTyPe
 * @author		Tim Esnouf <tim.esnouf[åt]flaik[dõt]com>
 * @copyright	2022 Tim Esnouf
 */
class FluidDatePickerPortalBiggerer extends Fluid {

	intTimer := 100

	pour() {
		global objRetype

		; Create window group for places we want this hotkey active
		strGroup	:= this.__Class
		strRTP		:= % objRetype.objRTP.classNN()
		GroupAdd, %strGroup%, Add ahk_class %strRTP%, Pricing Season Dates
		GroupAdd, %strGroup%, Update ahk_class %strRTP%, Pricing Season Dates

		; Pricing Season window is active
		IfWinActive, ahk_group %strGroup%
		{

			WinGetPos, intX, intY, intW, intH, A
			if ( intW = 640 || intW = 688 )
			{

				; Pricing season is annoying Step 1 lets make it taller
				WinMove, A, , , % intH-350 ,700 , 900
				; We want to make this window wider 350

				; Identify Dates list control list 11
				strListResult := objRetype.objRTP.formatClassNN( "SysListView32", this.getConf( "ListResult", 11 ) )
				;; Need to also move button 11 and 12

				ControlGetPos, intX, intY, intW, intH, %strListResult%,
				; MsgBox, , Position, %intX% %strListResult%,
				;; TE NOTE Can move the portal but unableot adjust height or width.  Even ints break the
				;; AHK flow  something is locking this in... leaving commented out for now
				; ControlMove, %strListResult% , % intX - 80  , ,  ,  , A

			}
		}

	}

}
