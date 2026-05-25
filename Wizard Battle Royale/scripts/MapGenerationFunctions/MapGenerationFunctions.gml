enum RoomSide {
    RIGHT = 0,
    TOP = 1,
    LEFT = 2,
    BOTTOM = 3
}

function OppositeSide(_side) {
    switch(_side) {
        case RoomSide.RIGHT: return RoomSide.LEFT;
        case RoomSide.LEFT: return RoomSide.RIGHT;
        case RoomSide.TOP: return RoomSide.BOTTOM;
        case RoomSide.BOTTOM: return RoomSide.TOP;
    }
}

function PrecalculateRoomData(_roomArray) {
    var _entrancesMap = ds_map_create();
    
    for (var i = 0; i < array_length(_roomArray); i++) {
        var _rm = _roomArray[i];
        var _info = room_get_info(_rm, true, true, false, false, false); 
        var _doors = [];
        var _instances = _info.instances;
        
        var _roomX = _info.views[7].xview;
        var _roomY = _info.views[7].yview;
        var _roomW = _info.views[7].wview;
        var _roomH = _info.views[7].hview;
        
        show_debug_message("SCANARE: " + room_get_name(_rm));
        show_debug_message("View 7: X=" + string(_roomX) + " Y=" + string(_roomY) + " W=" + string(_roomW) + " H=" + string(_roomH));
        
        var _count = 0;
        for (var j = 0; j < array_length(_instances); j++) {
            var _inst = _instances[j];
            
            if (_inst.object_index == "oRoomEntrance") {
                _count++;
                var _w = _inst.xscale; 
                var _h = _inst.yscale;
                var _side = undefined;
                var _margin = 64; 
                
                var local_x = _inst.x - _roomX;
                var local_y = _inst.y - _roomY;
                
                if (local_y == 0) {
                    _side = RoomSide.TOP;
                } else if (local_y == _roomH) {
                    _side = RoomSide.BOTTOM;
                } else if (local_x == 0) {
                    _side = RoomSide.LEFT;
                } else if (local_x == _roomW) {
                    _side = RoomSide.RIGHT;
                }

                var _sideName = (_side == undefined) ? "UNDEFINED" : 
                                (_side == RoomSide.LEFT ? "LEFT" : 
                                (_side == RoomSide.RIGHT ? "RIGHT" : 
                                (_side == RoomSide.TOP ? "TOP" : "BOTTOM")));
                
                show_debug_message("   [" + string(_count) + "] Usa la: (" + string(_inst.x) + ", " + string(_inst.y) + ") | SIDE: " + _sideName);
    
                array_push(_doors, {
                    x: _inst.x,
                    y: _inst.y,
                    width: _w,
                    height: _h,
                    side: _side
                });
            }
        }
        
        if (_count == 0) {
            show_debug_message(" Camera nu are iesiri.");
        }
        
        _entrancesMap[? _rm] = {
            doors: _doors,
            view_x: _roomX,
            view_y: _roomY,
            view_w: _roomW,
            view_h: _roomH
        };
    }
    
    return _entrancesMap;
}


function CheckRoomCollision(_mapArray, _realX, _realY, _w, _h) {
    var _pad = 0; 
    for (var i = 0; i < array_length(_mapArray); i++) {
        var _other = _mapArray[i];
        
        if (_realX + _pad < _other.real_x + _other.width - _pad && 
            _realX + _w - _pad > _other.real_x + _pad && 
            _realY + _pad < _other.real_y + _other.height - _pad && 
            _realY + _h - _pad > _other.real_y + _pad) {
            return true;
        }
    }
    return false;
}

function GenerateRadialMap(_maxRooms, _entrancesMap) {
    var _mapArray = [];
    var _openDoors = [];   
    var _sealedDoors = []; 

    var _startRooms = [rmArenaLarge0, rmArenaLarge1];
    var _oneEnded = [rmLootSmall0, rmLootSmall4, rmLootSmall5,
                    rmLootSmall6,
                    rmCorridorSmall12, rmCorridorSmall13, rmCorridorSmall15, rmCorridorSmall16, rmCorridorSmall17,
                    rmLootMedium8];
    
    var _expansionRooms = [
        rmLootSmall1, rmLootSmall2, rmLootSmall3, rmLootSmall7, rmLootSmall8, rmLootSmall9,
        rmLootMedium0, rmLootMedium1, rmLootMedium2, rmLootMedium3, rmLootMedium4, rmLootMedium5,
        rmLootMedium6,rmLootMedium7, rmLootMedium9, rmLootMedium10, rmLootMedium11,
        rmCorridorSmall0, rmCorridorSmall1, rmCorridorSmall2, rmCorridorSmall3,
        rmCorridorSmall4, rmCorridorSmall5, rmCorridorSmall6, rmCorridorSmall7,
        rmCorridorSmall8, rmCorridorSmall9, rmCorridorSmall10, rmCorridorSmall11, rmCorridorSmall14, rmCorridorSmall18,
        rmCorridorSmall19, rmCorridorSmall20, rmCorridorSmall21, rmCorridorSmall22, 
        rmCorridorMedium0, rmCorridorMedium1, rmCorridorMedium2,
        rmCorridorMedium3, rmCorridorMedium4, rmCorridorMedium5,rmCorridorMedium6, rmCorridorMedium7, rmCorridorMedium8,
        rmArenaMedium0, rmArenaMedium1, rmArenaMedium2, rmArenaMedium3, rmArenaMedium4
    ];
    
    var _wallsHorizontal = [rmWallHorizontal];
    var _wallsVertical   = [rmWallVertical];

    // nodul de start
    var _startRoomID = _startRooms[irandom(array_length(_startRooms) - 1)];
    var _startData = _entrancesMap[? _startRoomID];
    
    var _startNode = {
        room_index: room_get_name(_startRoomID),
        world_x: 0, 
        world_y: 0, 
        real_x: _startData.view_x,
        real_y: _startData.view_y,
        width: _startData.view_w,
        height: _startData.view_h
    };
    
    array_push(_mapArray, _startNode);

    for (var i = 0; i < array_length(_startData.doors); i++) {
        var _door = _startData.doors[i];
        array_push(_openDoors, {
            world_x: _startNode.world_x + _door.x,
            world_y: _startNode.world_y + _door.y,
            side: _door.side,
            parent: _startNode
        });
    }

    // expansiune
    var _failsafe_loop = 0;

    while (array_length(_openDoors) > 0 && _failsafe_loop < 2000) {
        _failsafe_loop++;
        
        var _targetDoor = array_shift(_openDoors);
        var _reqSide = OppositeSide(_targetDoor.side);
        
        var _currentPool = [];
        
        if (array_length(_mapArray) >= _maxRooms) {
            _currentPool = array_shuffle(_oneEnded);
        } else {
            _currentPool = array_shuffle(_expansionRooms);
        }

        var _placedSuccessfully = false;

        for (var c = 0; c < array_length(_currentPool); c++) {
            var _candRoomID = _currentPool[c];
            var _candData = _entrancesMap[? _candRoomID];
            var _candDoors = _candData.doors;
            
            for (var dIn = 0; dIn < array_length(_candDoors); dIn++) {
                var _candIn = _candDoors[dIn];
                
                if (_candIn.side == _reqSide) {
                    
                    var _tx = _targetDoor.world_x - _candIn.x;
                    var _ty = _targetDoor.world_y - _candIn.y;
                    
                    var _realX = _tx + _candData.view_x;
                    var _realY = _ty + _candData.view_y;
                    
                    if (!CheckRoomCollision(_mapArray, _realX, _realY, _candData.view_w, _candData.view_h)) {
                        
                        var _newNode = {
                            room_index: room_get_name(_candRoomID),
                            world_x: _tx,
                            world_y: _ty,
                            real_x: _realX,
                            real_y: _realY,
                            width: _candData.view_w,
                            height: _candData.view_h
                        };
                        array_push(_mapArray, _newNode);
                        
                        for (var dOut = 0; dOut < array_length(_candDoors); dOut++) {
                            if (dOut == dIn) continue; 
                            
                            var _candOut = _candDoors[dOut];
                            array_push(_openDoors, {
                                world_x: _tx + _candOut.x,
                                world_y: _ty + _candOut.y,
                                side: _candOut.side,
                                parent: _newNode
                            });
                        }
                        
                        _placedSuccessfully = true;
                        break;
                    }
                }
            }
            if (_placedSuccessfully) break; 
        }

        if (!_placedSuccessfully) {
            array_push(_sealedDoors, _targetDoor);
        }
    }

    // incercam sa adaugam one ended
    for (var s = 0; s < array_length(_sealedDoors); s++) {
        var _targetDoor = _sealedDoors[s];
        var _reqSide = OppositeSide(_targetDoor.side);
        var _capPlaced = false;

        var _capPool = array_shuffle(_oneEnded);

        for (var c = 0; c < array_length(_capPool); c++) {
            var _candRoomID = _capPool[c];
            var _candData = _entrancesMap[? _candRoomID];
            var _candDoors = _candData.doors;

            for (var dIn = 0; dIn < array_length(_candDoors); dIn++) {
                var _candIn = _candDoors[dIn];

                if (_candIn.side == _reqSide) {
                    var _tx = _targetDoor.world_x - _candIn.x;
                    var _ty = _targetDoor.world_y - _candIn.y;
                    
                    var _realX = _tx + _candData.view_x;
                    var _realY = _ty + _candData.view_y;

                    if (!CheckRoomCollision(_mapArray, _realX, _realY, _candData.view_w, _candData.view_h)) {
                        
                        var _newNode = {
                            room_index: room_get_name(_candRoomID),
                            world_x: _tx,
                            world_y: _ty,
                            real_x: _realX,
                            real_y: _realY,
                            width: _candData.view_w,
                            height: _candData.view_h
                        };
                        array_push(_mapArray, _newNode);
                        
                        _capPlaced = true;
                        break;
                    }
                }
            }
            if (_capPlaced) break;
        }

        // adaugare ziduri
        if (!_capPlaced) {
            var _wallRoomID;
            
            if (_reqSide == RoomSide.TOP || _reqSide == RoomSide.BOTTOM) {
                _wallRoomID = _wallsHorizontal[irandom(array_length(_wallsHorizontal) - 1)];
            } else {
                _wallRoomID = _wallsVertical[irandom(array_length(_wallsVertical) - 1)];
            }

            var _wallData = _entrancesMap[? _wallRoomID];
            var _w  = _wallData.view_w; 
            var _h  = _wallData.view_h;

            // offset pentru zid
            var _offsetX = 0;
            var _offsetY = 0;


            if (_reqSide == RoomSide.RIGHT) {
                _offsetX = -_w; 
            }

            else if (_reqSide == RoomSide.BOTTOM) {
                _offsetY = -_h; 
            }

            var _finalX = _targetDoor.world_x + _offsetX;
            var _finalY = _targetDoor.world_y + _offsetY;

            var _rx = _finalX + _wallData.view_x;
            var _ry = _finalY + _wallData.view_y;

            var _wallNode = {
                room_index: room_get_name(_wallRoomID),
                world_x: _finalX,
                world_y: _finalY,
                real_x: _rx,
                real_y: _ry,
                width: _w,
                height: _h
            };
            
            array_push(_mapArray, _wallNode);
        }
    }

    return {
        rooms: _mapArray,
        sealed_doors: []
    };
}

function GenerateBestRadialMap(_maxRooms, _entrancesMap, _tries = 10) {
    var _bestResult = undefined;
    var _bestScore = 999999999;

    for (var i = 0; i < _tries; i++) {

        var _currentResult = GenerateRadialMap(_maxRooms, _entrancesMap);
        var _mapArray = _currentResult.rooms;
        

        if (array_length(_mapArray) == 0) continue;


        var _minX = 9999999;
        var _maxX = -9999999;
        var _minY = 9999999;
        var _maxY = -9999999;

        for (var j = 0; j < array_length(_mapArray); j++) {
            var _node = _mapArray[j];
            
            if (_node.world_x < _minX) _minX = _node.world_x;
            if (_node.world_x + _node.width > _maxX) _maxX = _node.world_x + _node.width;
            
            if (_node.world_y < _minY) _minY = _node.world_y;
            if (_node.world_y + _node.height > _maxY) _maxY = _node.world_y + _node.height;
        }

        var _totalWidth = _maxX - _minX;
        var _totalHeight = _maxY - _minY;

        var _score = _totalWidth + _totalHeight;

        if (_score < _bestScore) {
            _bestScore = _score;
            _bestResult = _currentResult;
        }
    }

    return _bestResult;
}