function MapGenerationFunctions(){
    var roomEntrances = ds_map_create();
    roomEntrances[? rmLootSmall0] = [
        {x: 64, y:448, w:64, h: 0}  
    ];
    
    var cam = room_get_camera(rmLootSmall0, 7);
    var rmWidth = camera_get_view_width(cam);
    
    ds_map_destroy(roomEntrances);
}