//Config
//========
#macro DISPLAY_WINDOW_CENTER_MAX_ATTEMPTS (game_get_speed(gamespeed_fps) * 1.0)
/*	Maximum number of attempts to center the application window to the current monitor.
 *	The display_window_center function runs once each game frame.
 */

#macro DISPLAY_FULLSCREEN_POST_DELAY_SECS 0.05
/*	A delay in seconds after fullscreen swap chain to apply borderless-fullscreen.
 *	Having a value too low will cause the application to be displayed on the primary monitor, if the intention was for it to display on a secondary monitor.
 */

#macro DISPLAY_CREATE_DEFAULT_CAMERA true
/*	When no camera is present within a room, PH
 *
 */


#macro DISPLAY_MIN_SCALE 1
/*	The minimun scale that the game's window can be.
 *	Used with the display scale and fullscreen functions.
 */