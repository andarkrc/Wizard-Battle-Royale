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


function CheckDoorOverlap(_mapArray, _entrancesMap, _targetDoor) {
    var _margin = 10; 
    var _targetX = _targetDoor.world_x;
    var _targetY = _targetDoor.world_y;
    var _parentRoom = _targetDoor.parent;

    for (var i = 0; i < array_length(_mapArray); i++) {
        var _node = _mapArray[i];
        

        if (_node == _parentRoom) continue; 

        var _roomAsset = asset_get_index(_node.room_index);
        var _roomData = _entrancesMap[? _roomAsset];
        
        if (_roomData == undefined) continue;
        
        var _doors = _roomData.doors;
        for (var d = 0; d < array_length(_doors); d++) {
            var _door = _doors[d];
            
            var _worldDoorX = _node.world_x + _door.x;
            var _worldDoorY = _node.world_y + _door.y;
            
            if (abs(_targetX - _worldDoorX) <= _margin && abs(_targetY - _worldDoorY) <= _margin) {
                return true; 
            }
        }
    }
    return false;
}

function GenerateRadialMap(_maxRooms, _entrancesMap) {
    var _mapArray = [];
    var _openDoors = [];   
    var _sealedDoors = []; 
    
    // coliziuni cu zona "interzisa" de sub un fall room
    var _virtualBlockers = []; 

    var _startRooms = [rmArenaLarge0, rmArenaLarge1];
    var _oneEnded = [rmLootSmall0, rmLootSmall4, rmLootSmall5, rmLootSmall10, rmLootSmall11, rmLootSmall12,
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
        rmCorridorMedium3, rmCorridorMedium4, rmCorridorMedium5,rmCorridorMedium6,
        rmCorridorMedium7, rmCorridorMedium8, rmCorridorMedium9, rmCorridorMedium10,
        rmCorridorMedium11, rmCorridorMedium12, rmCorridorMedium13, rmCorridorMedium14,
        
        rmArenaMedium0, rmArenaMedium1, rmArenaMedium2, rmArenaMedium3,
        rmArenaMedium4, rmArenaMedium5, rmArenaMedium6,
    ];
    
    var _wallsHorizontal = [rmWallHorizontalSimple, rmWallHorizontalDouble];
    var _wallsVertical   = [rmWallVerticalSimple, rmWallVerticalDouble];
    
    var _specialFallRooms = [rmFallMedium0, rmFallSmall0];
    var _placedFallRoom = false;

    var _startRoomID = _startRooms[irandom(array_length(_startRooms) - 1)];
    var _startData = _entrancesMap[? _startRoomID];
    
    if (_startData == undefined) {
        show_debug_message("EROARE FATALA: Camera de start " + room_get_name(_startRoomID) + " nu a fost precalculata!");
        return { rooms: [], sealed_doors: [] };
    }
    
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
            width: _door.width,
            height: _door.height,
            parent: _startNode
        });
    }

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
        
        if (!_placedFallRoom && array_length(_mapArray) >= _maxRooms div 2) {
            var _sfPool = array_shuffle(_specialFallRooms);
            for (var sp = array_length(_sfPool) - 1; sp >= 0; sp--) {
                array_insert(_currentPool, 0, _sfPool[sp]);
            }
        }

        var _placedSuccessfully = false;

        for (var c = 0; c < array_length(_currentPool); c++) {
            var _candRoomID = _currentPool[c];
            var _candData = _entrancesMap[? _candRoomID];
            
            if (_candData == undefined) continue; 
            
            var _candDoors = _candData.doors;
            
            for (var dIn = 0; dIn < array_length(_candDoors); dIn++) {
                var _candIn = _candDoors[dIn];
                
                if (_candIn.side == _reqSide) {
                    
                    var _tx = _targetDoor.world_x - _candIn.x;
                    var _ty = _targetDoor.world_y - _candIn.y;
                    
                    var _realX = _tx + _candData.view_x;
                    var _realY = _ty + _candData.view_y;
                    
                    var _isColliding = CheckRoomCollision(_mapArray, _realX, _realY, _candData.view_w, _candData.view_h);
                    
                    if (!_isColliding && array_length(_virtualBlockers) > 0) {
                        _isColliding = CheckRoomCollision(_virtualBlockers, _realX, _realY, _candData.view_w, _candData.view_h);
                    }
                    
                    if (!_isColliding) {
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
                        
                        if (!_placedFallRoom) {
                            for (var sp = 0; sp < array_length(_specialFallRooms); sp++) {
                                if (_candRoomID == _specialFallRooms[sp]) {
                                    _placedFallRoom = true;
                                    
                                    array_push(_virtualBlockers, {
                                        real_x: _realX,
                                        real_y: _realY + _candData.view_h,
                                        width: _candData.view_w,
                                        height: 999999 
                                    });
                                    break;
                                }
                            }
                        }

                        for (var dOut = 0; dOut < array_length(_candDoors); dOut++) {
                            if (dOut == dIn) continue; 
                            
                            var _candOut = _candDoors[dOut];
                            array_push(_openDoors, {
                                world_x: _tx + _candOut.x,
                                world_y: _ty + _candOut.y,
                                side: _candOut.side,
                                width: _candOut.width,
                                height: _candOut.height,
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

    // Camere one ended (capete)
    for (var s = 0; s < array_length(_sealedDoors); s++) {
        var _targetDoor = _sealedDoors[s];
        var _reqSide = OppositeSide(_targetDoor.side);
        var _capPlaced = false;

        var _capPool = array_shuffle(_oneEnded);

        for (var c = 0; c < array_length(_capPool); c++) {
            var _candRoomID = _capPool[c];
            var _candData = _entrancesMap[? _candRoomID];
            
            if (_candData == undefined) continue; 
            
            var _candDoors = _candData.doors;

            for (var dIn = 0; dIn < array_length(_candDoors); dIn++) {
                var _candIn = _candDoors[dIn];

                if (_candIn.side == _reqSide) {
                    var _tx = _targetDoor.world_x - _candIn.x;
                    var _ty = _targetDoor.world_y - _candIn.y;
                    
                    var _realX = _tx + _candData.view_x;
                    var _realY = _ty + _candData.view_y;

                    var _isCollidingCap = CheckRoomCollision(_mapArray, _realX, _realY, _candData.view_w, _candData.view_h);
                    
                    if (!_isCollidingCap && array_length(_virtualBlockers) > 0) {
                        _isCollidingCap = CheckRoomCollision(_virtualBlockers, _realX, _realY, _candData.view_w, _candData.view_h);
                    }

                    if (!_isCollidingCap) {
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
            var _wallPool = [];

            var _reqWidth = min(_targetDoor.width, _targetDoor.height); 
            
            if (_reqSide == RoomSide.TOP || _reqSide == RoomSide.BOTTOM) {
                _wallPool = _wallsHorizontal;
            } else {
                _wallPool = _wallsVertical;
            }

            var _chosenWallRoomID = undefined;
            var _chosenWallData = undefined;

            // cautam o usa de grosimea cautata
            for (var wp = 0; wp < array_length(_wallPool); wp++) {
                var _testWallID = _wallPool[wp];
                var _testWallData = _entrancesMap[? _testWallID];
                
                if (_testWallData == undefined) continue;
                
                var _wallDim = min(_testWallData.view_w, _testWallData.view_h);
                
                var _wallScale = _wallDim / 32;
                var _reqScale = _reqWidth;
                
                if (abs(_wallScale - _reqScale) < 0.1) {
                    _chosenWallRoomID = _testWallID;
                    _chosenWallData = _testWallData;
                    break; 
                }
            }
            
            if (_chosenWallData != undefined) {
                var _w  = _chosenWallData.view_w; 
                var _h  = _chosenWallData.view_h;

                var _offsetX = 0;
                var _offsetY = 0;

                if (_reqSide == RoomSide.LEFT) {
                    _offsetX = -_w; 
                } else if (_reqSide == RoomSide.TOP) {
                    _offsetY = -_h; 
                }

                var _finalX = _targetDoor.world_x + _offsetX;
                var _finalY = _targetDoor.world_y + _offsetY;

                // suprapunere cu usa altei camere care s a intamplat sa fie langa
                var _doorOverlap = CheckDoorOverlap(_mapArray, _entrancesMap, _targetDoor);
                
                if (!_doorOverlap) {
                    var _rx = _finalX + _chosenWallData.view_x;
                    var _ry = _finalY + _chosenWallData.view_y;

                    var _wallNode = {
                        room_index: room_get_name(_chosenWallRoomID),
                        world_x: _finalX,
                        world_y: _finalY,
                        real_x: _rx,
                        real_y: _ry,
                        width: _w,
                        height: _h
                    };
                    
                    array_push(_mapArray, _wallNode);
                } else {
                    show_debug_message("Zid ignorat: S-a detectat suprapunere la " + string(_targetDoor.world_x) + ", " + string(_targetDoor.world_y));
                }
            } else {
                show_debug_message("Nu s-a gasit un zid in array de dimensiunea: " + string(_reqWidth));
            }
        }
    }

    if (!_placedFallRoom) {
        return { rooms: [], sealed_doors: [] };
    }

    return {
        rooms: _mapArray,
        sealed_doors: []
    };
}

function GenerateBestRadialMap(_maxRooms, _entrancesMap, _tries = 50, _corridorPenalty = 2000, _entranceBonus = 500, _squarenessPenalty = 2) {
    var _bestResult = undefined;
    var _bestScore = 999999999;
    
    var _minArenaMedium = _maxRooms div 10; 
    var _fallRoomKeyword = "rmFall";

    for (var i = 0; i < _tries; i++) {

        var _currentResult = GenerateRadialMap(_maxRooms, _entrancesMap);
        var _mapArray = _currentResult.rooms;
        var _roomCount = array_length(_mapArray);
        
        if (_roomCount == 0) continue;

        var _arenaCount = 0;
        var _corridorCount = 0;
        var _totalDoors = 0;
        
        var _hasFallRoom = false;
        var _fallRoomBottomY = -9999999;
        
        for (var r = 0; r < _roomCount; r++) {
            var _node = _mapArray[r];
            
            if (string_pos("ArenaMedium", _node.room_index) > 0) {
                _arenaCount++;
            }
            
            if (string_pos("Corridor", _node.room_index) > 0) {
                _corridorCount++;
            }

            if (string_pos(_fallRoomKeyword, _node.room_index) > 0) {
                _hasFallRoom = true;
                var _bottomEdge = _node.world_y + _node.height;
                if (_bottomEdge > _fallRoomBottomY) {
                    _fallRoomBottomY = _bottomEdge;
                }
            }

            var _roomAsset = asset_get_index(_node.room_index);
            var _roomData = _entrancesMap[? _roomAsset];
            
            if (_roomData != undefined) {
                _totalDoors += array_length(_roomData.doors);
            }
        }

        if (_arenaCount < _minArenaMedium || !_hasFallRoom) {
            continue;
        }

        var _avgDoors = _totalDoors / _roomCount;

        var _minX = 9999999;
        var _maxX = -9999999;
        var _minY = 9999999;
        var _maxY = -9999999;

        for (var j = 0; j < _roomCount; j++) {
            var _node = _mapArray[j];
            
            if (_node.world_x < _minX) _minX = _node.world_x;
            if (_node.world_x + _node.width > _maxX) _maxX = _node.world_x + _node.width;
            
            if (_node.world_y < _minY) _minY = _node.world_y;
            if (_node.world_y + _node.height > _maxY) _maxY = _node.world_y + _node.height;
        }

        var _mapWidth = _maxX - _minX;
        var _mapHeight = _maxY - _minY;
        var _sizeScore = _mapWidth + _mapHeight;
        
        var _aspectDifference = abs(_mapWidth - _mapHeight);
        
        var _distFromBottom = _maxY - _fallRoomBottomY;
        var _bottomPlacementPenalty = _distFromBottom * 3; 

        var _totalScore = _sizeScore 
                        + (_aspectDifference * _squarenessPenalty) 
                        + (_corridorCount * _corridorPenalty) 
                        + _bottomPlacementPenalty
                        - (_avgDoors * _entranceBonus);

        if (_totalScore < _bestScore) {
            _bestScore = _totalScore;
            _bestResult = _currentResult;
        }
    }

    if (_bestResult == undefined) {
        show_debug_message("Nu s-a putut genera o harta cu " + string(_minArenaMedium) + " arene medii în " + string(_tries) + " incercari");
        return GenerateRadialMap(_maxRooms, _entrancesMap);
    }

    return _bestResult;
}