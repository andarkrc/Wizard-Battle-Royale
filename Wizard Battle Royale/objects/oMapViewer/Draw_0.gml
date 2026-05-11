var _offsetX = 300;
var _offsetY = 200;
var _scale = 0.05; // scalarea hartii

for (var i = 0; i < array_length(my_level_data); i++) {
    var _room = my_level_data[i];
    
    // afisare camere ce tine cont de offset camera pentru coridoare
    var _drawX1 = _offsetX + ((_room.camera_pos_x + _room.world_x) * _scale);
    var _drawY1 = _offsetY + ((_room.camera_pos_y + _room.world_y) * _scale);
    var _drawX2 = _drawX1 + (_room.width * _scale);
    var _drawY2 = _drawY1 + (_room.height * _scale);
    
    // contur camera
    draw_set_color(c_white);
    draw_set_alpha(0.3);
    draw_rectangle(_drawX1, _drawY1, _drawX2, _drawY2, false);
    draw_set_alpha(1.0);
    draw_rectangle(_drawX1, _drawY1, _drawX2, _drawY2, true);
    
    // ID
    draw_set_halign(fa_center);
    draw_set_color(c_yellow);
    var _midX = _drawX1 + (_drawX2 - _drawX1) / 2;
    var _midY = _drawY1 + (_drawY2 - _drawY1) / 2;
    
    draw_text_transformed(_midX, _midY - 10, "ID: " + string(i), 0.6, 0.6, 0);
    
    // numele camerei
    var _roomName = room_get_name(_room.room_index);
    draw_text_transformed(_midX, _midY + 5, _roomName, 0.6, 0.6, 0);
    
    // iesiri/intrari
    var _inX = _offsetX + (_room.in_x * _scale);
    var _inY = _offsetY + (_room.in_y * _scale);
    var _outX = _offsetX + (_room.out_x * _scale);
    var _outY = _offsetY + (_room.out_y * _scale);
    
    draw_set_color(c_green);
    draw_circle(_inX, _inY, 4, false);
    
    draw_set_color(c_red);
    draw_circle(_outX, _outY, 4, false);

    
}

draw_set_halign(fa_left);