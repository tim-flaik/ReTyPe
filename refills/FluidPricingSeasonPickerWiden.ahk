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
objRetype.refill( new FluidPricingSeasonPickerWiden() )


/**
 * Refill to moves the Deferral Calendar and Pricing Seaosn windows up and makes
 * the date portal of death larger.
 *
 * @category	Automation
 * @package		ReTyPe
 * @author		Tim Esnouf <tim.esnouf[åt]flaik[dõt]com>
 * @copyright	2022 Tim Esnouf
 */
class FluidPricingSeasonPickerWiden extends Fluid {

	intTimer := 100

	pour() {
		global objRetype

		; Create window group for places we want this hotkey active
		strGroup	:= this.__Class
		strRTP		:= % objRetype.objRTP.classNN()
		GroupAdd, %strGroup%, Add ahk_class %strRTP%, Dates
		GroupAdd, %strGroup%, Update ahk_class %strRTP%, Dates

		; Pricing Season window is active
		IfWinActive, ahk_group %strGroup%
		{
			WinGetPos, intX, intY, intW, intH, A
			if ( intW = 640 || intW = 688 )
			{
				
				; Pricing season is annoying Step 1 lets make it taller 
				WinMove, A, , , % intH-350 ,645 , 900 
				; WinMove, A, , % intX-100, , 1400
			}
		}

	}


}
