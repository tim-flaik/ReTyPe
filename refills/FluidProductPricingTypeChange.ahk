/**
 * File containing Refill class to facilitate updating multiple pricing rows on a product header
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
objRetype.refill( new FluidProductPricingTypeChange() )


/**
 * Refill to change pricing type for example fomr Price By Date to Price By season.
 *
 * @category	Automation
 * @package		ReTyPe
 * @author		Tim Esnouf tim.esnouf@flaik.com
 * @copyright	2022 Tim Esnouf
 */
class FluidProductPricingTypeChange extends Fluid {


	strHotkey		:= "^!b"
	strMenuPath		:= "/Admin/Product"
	strMenuText		:= "Pricing Type Update"
	intMenuIcon		:= 147


	/**
	 * Setup controls, window group, etc
	 */
	__New() {
		global objRetype
		base.__New()

		strGroup 	:= this.id
		strRTP		:= % objRetype.objRTP.classNN()
		GroupAdd, %strGroup%, Add ahk_class %strRTP%, Product Headers
		; GroupAdd, %strGroup%, Update ahk_class %strRTP%, Sales Report Group
	}


	/**
	 * Where the magic happens
	 */
	pour() {
		global objRetype
		static intIterate := 1

		; Activate RTP (after toolbar has been clicked)
		objRetype.objRTP.Activate()
   ; @todo Check needs to be removed once I've managed to wall-in shortcuts in to the RTP only window
		; Run if it's ready!
		strGroup := this.__Class
		IfWinActive, ahk_group %strGroup%
		MsgBox %strGroup%
		{
			; Did you execute from an RTP window?
			if ( objRetype.objRTP.isActive() ) {
				idWinRTP	:= WinActive("A")

				; Are we in the pricing tab of a product header?
				if ( Window.CheckVisibleTextContains( "Product Headers" ) ) {
					; prompt for iteration ContinueSingleOnly(
						intHeaders := InputBox.Show( "How many headers do you want to update?", 5 )
						intType := inputBox.Show( " 1 = Date, 2, Date Location, 3=Season , 4= Season Location" , 1)
						intCurrentLoop := 0 ; ensure that the loop value is reset to 0 as I'm still reaquanting myself with the antiquated RTP|One and AHK
						intCurrentLoop := 1
						Loop %intHeaders%
						{
							;; Open Product Header and wait a little
							SendInput {AppsKey}u
							WinWait, General, , 5
							SendInput {Tab 12}
							;; Reset Price By Type to Null
							SendInput {Up 4}
							SendInput {Down %intType%}

							;; Get tot the OK button and press it.
							SendInput {Tab 33}{Enter}

							intCurrentLoop += 1 ;; add one to the loop

							SendInput {down %intCurrentLoop%}
						}
				}
				MsgBox "Finished updating price types"
			}
		}
	}
}