/**
 * Here be object for facilitating message popup boxes
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

AHKPanic(Kill=0, Pause=0, Suspend=0, SelfToo=0)
{
    DetectHiddenWindows, On
    WinGet, IDList ,List, ahk_class AutoHotkey
    Loop %IDList%
    {
        ID:=IDList%A_Index%
        WinGetTitle, ATitle, ahk_id %ID%
        IfNotInString, ATitle, %A_ScriptFullPath%
        {
            If Suspend
                PostMessage, 0x111, 65305,,, ahk_id %ID% ; Suspend.
            If Pause
                PostMessage, 0x111, 65306,,, ahk_id %ID% ; Pause.
            If Kill
                WinClose, ahk_id %ID% ;kill
        }
    }
    If SelfToo
    {
        If Suspend
            Suspend, Toggle ; Suspend.
        If Pause
            Pause, Toggle, 1 ; Pause.
        If Kill
            ExitApp
    }
}