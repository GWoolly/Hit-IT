/// @desc Draws a crosshair for debug purposes.
/// @param {real} x             X position.
/// @param {real} y             Y position.
/// @param {real} [radius]=2    The radius of the crosshair
function draw_crosshair(x, y, radius=2){
    
    draw_line(x - radius, y, x + radius, y);// H
    draw_line(x, y - radius, x, y + radius);// V
}