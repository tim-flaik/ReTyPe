/**
 * File containing Refill class to find a customer image
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
objRetype.refill( new FluidPanicEscapeGetOuttaHere() )

/**
 * Implement a oh dear we need to shut AHK down script.  Something has gone awry.
 *
 * @category	Automation
 * @package		ReTyPe
 * @author		Tim Esnouf
 * @copyright	2022 Tim Esnouf
 */
class FluidPanicEscapeGetOuttaHere extends Fluid {

	strHotkey		:= "^!q"
	strMenuPath		:= "/General"
	strMenuText		:= "Help Me"
	intMenuIcon		:= 265 ;272

	/**
	 * Setup controls, window group, etc
	 */
	__New() {
		base.__New()
	}

	/**
	 * Where the magic happens
	 */
	pour() {

		DetectHiddenWindows, On
		WinGet, IDList ,List, ahk_class AutoHotkey
		Loop %IDList%
		{
			ID:=IDList%A_Index%
			WinGetTitle, ATitle, ahk_id %ID%
			IfNotInString, ATitle, %A_ScriptFullPath%
				WinClose, ahk_id %ID% ;kill

		}
		ExitApp

	}

}