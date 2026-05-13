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

function GenerateGridMap(_cols, _rows) {
    var roomEntrances = ds_map_create();

    roomEntrances[? rmLootSmall0] = [{x: 80, y: 480, side: RoomSide.BOTTOM}];
    roomEntrances[? rmLootSmall4] = [{x: 400, y: 0, side: RoomSide.TOP}];
    roomEntrances[? rmLootSmall5] = [{x: 480, y: 80, side: RoomSide.RIGHT}];
    roomEntrances[? rmLootSmall6] = [{x: 0, y: 400, side: RoomSide.LEFT}];

    roomEntrances[? rmLootSmall1] = [{x: 0, y: 400, side: RoomSide.LEFT},
                                     {x: 480, y: 80, side: RoomSide.RIGHT}];

    roomEntrances[? rmLootSmall2] = [{x: 0, y: 400, side: RoomSide.LEFT},
                                     {x: 480, y: 400, side: RoomSide.RIGHT}];

    roomEntrances[? rmLootSmall3] = [{x: 80, y: 480, side: RoomSide.BOTTOM},
                                     {x: 400, y: 0, side: RoomSide.TOP}];
    
    
    roomEntrances[? rmLootMedium0] = [{x: 80, y: 960, side: RoomSide.BOTTOM},
                                     {x: 960, y: 720, side: RoomSide.RIGHT}];

    roomEntrances[? rmLootMedium1] = [{x: 0, y: 720, side: RoomSide.LEFT},
                                     {x: 960, y: 720, side: RoomSide.RIGHT}];

    roomEntrances[? rmLootMedium2] = [{x: 0, y: 112, side: RoomSide.LEFT},
                                     {x: 960, y: 112, side: RoomSide.RIGHT}];

    roomEntrances[? rmLootMedium3] = [{x: 0, y: 176, side: RoomSide.LEFT},
                                     {x: 960, y: 848, side: RoomSide.RIGHT}];
    
    
    roomEntrances[? rmCorridorSmall0] = [{x: 0, y: 272, side: RoomSide.LEFT},
                                         {x: 480, y: 272, side: RoomSide.RIGHT}];

    roomEntrances[? rmCorridorSmall1] = [{x: 0, y: 272, side: RoomSide.LEFT},
                                         {x: 400, y: 480, side: RoomSide.BOTTOM}];

    roomEntrances[? rmCorridorSmall2] = [{x: 80, y: 0, side: RoomSide.TOP},
                                         {x: 0, y: 400, side: RoomSide.LEFT}];

    roomEntrances[? rmCorridorSmall3] = [{x: 80, y: 480, side: RoomSide.BOTTOM}, 
                                         {x: 400, y: 0, side: RoomSide.TOP}];

    roomEntrances[? rmCorridorSmall4] = [{x: 240, y: 0, side: RoomSide.TOP}, 
                                         {x: 240, y: 480, side: RoomSide.BOTTOM}];

    roomEntrances[? rmCorridorSmall5] = [{x: 240, y: 0, side: RoomSide.TOP},
                                         {x: 240, y: 480, side: RoomSide.BOTTOM}];

    roomEntrances[? rmCorridorSmall6] = [{x: 80, y: 0, side: RoomSide.TOP}, 
                                         {x: 80, y: 480, side: RoomSide.BOTTOM}];
    
    roomEntrances[? rmCorridorSmall7] = [{x: 80, y: 0, side: RoomSide.TOP},
                                         {x: 0, y: 400, side: RoomSide.LEFT}];
    
    roomEntrances[? rmCorridorSmall8] = [{x: 80, y: 0, side: RoomSide.TOP},
                                         {x: 480, y: 400, side: RoomSide.RIGHT}];

    
    roomEntrances[? rmCorridorMedium0] = [{x: 0, y: 496, side: RoomSide.LEFT}, 
                                         {x: 960, y: 496, side: RoomSide.RIGHT}];
    
    roomEntrances[? rmCorridorMedium1] = [{x: 0, y: 272, side: RoomSide.LEFT}, 
                                         {x: 960, y: 880, side: RoomSide.RIGHT}];
    
    roomEntrances[? rmCorridorMedium2] = [{x: 240, y: 0, side: RoomSide.TOP}, 
                                         {x: 240, y: 960, side: RoomSide.BOTTOM}];
    
    roomEntrances[? rmCorridorMedium2] = [{x: 240, y: 0, side: RoomSide.TOP}, 
                                         {x: 240, y: 960, side: RoomSide.BOTTOM}];
    
    roomEntrances[? rmCorridorMedium3] = [{x: 240, y: 0, side: RoomSide.TOP}, 
                                         {x: 0, y: 752, side: RoomSide.LEFT}];
    
    roomEntrances[? rmCorridorMedium4] = [{x: 240, y: 0, side: RoomSide.TOP}, 
                                         {x: 960, y: 752, side: RoomSide.RIGHT}];

    
    
    roomEntrances[? rmArenaMedium0] = [{x: 0, y: 848, side: RoomSide.LEFT}, 
                                        {x: 960, y: 848, side: RoomSide.RIGHT}];
    
    roomEntrances[? rmArenaMedium1] = [{x: 0, y: 112, side: RoomSide.LEFT}, 
                                       {x: 960, y: 112, side: RoomSide.RIGHT}];
    
    roomEntrances[? rmArenaMedium2] = [ {x: 112, y: 0, side: RoomSide.TOP},
                                        {x: 848, y: 0, side: RoomSide.TOP}];
    
    roomEntrances[? rmArenaMedium3] = [{x: 0, y: 368, side: RoomSide.LEFT},
                                       {x: 960, y: 368, side: RoomSide.RIGHT}];
    
    roomEntrances[? rmArenaLarge0] = [{x: 0, y: 368, side: RoomSide.LEFT},
                                       {x: 1440, y: 368, side: RoomSide.RIGHT}];
    
    
    var oneEnded = [rmLootSmall0, rmLootSmall4, rmLootSmall5, rmLootSmall6];
    
    var deathmatch = [rmArenaLarge0];
    
    var corridorRooms = [
        rmCorridorSmall0, rmCorridorSmall1, rmCorridorSmall2, rmCorridorSmall3,
        rmCorridorSmall4, rmCorridorSmall5, rmCorridorSmall6, rmCorridorSmall7,
        rmCorridorSmall8, rmCorridorMedium0, rmCorridorMedium1, rmCorridorMedium2,
        rmCorridorMedium3, rmCorridorMedium4
    ];
    
    var allRooms = [
        rmLootSmall0, rmLootSmall1, rmLootSmall2, rmLootSmall3,
        rmLootSmall4, rmLootSmall5, rmLootSmall6,
        
        rmLootMedium0, rmLootMedium1, rmLootMedium2, rmLootMedium3,

        rmCorridorSmall0, rmCorridorSmall1, rmCorridorSmall2, rmCorridorSmall3,
        rmCorridorSmall4, rmCorridorSmall5, rmCorridorSmall6, rmCorridorSmall7,
        rmCorridorSmall8,
        
        rmCorridorMedium0, rmCorridorMedium1, rmCorridorMedium2, rmCorridorMedium3,
        rmCorridorMedium4,

        rmArenaMedium0, rmArenaMedium1, rmArenaMedium2, rmArenaMedium3
    ];
    
    var _mapArray = []; // stiva
    // la fiecare capat de rand am mai adaugat o camera (TOP-BOTTOM) pentru spatiere
    var _totalRoomsNeeded = (_cols * _rows) + (_rows - 1);

    var _curX = 0;
    var _curY = 0;
    var _reqSide = undefined;
    var _hDir = RoomSide.RIGHT;
    var _hSteps = 0;
    var _vSteps = 0;

    // ce candidati am incercat deja pentru un index
    var _triedCandidates = array_create(_totalRoomsNeeded, undefined);

    var i = 0;
    var _maxAttempts = 2000; // depinde de marimea de generat deci probabil de modificat
    var _attempts = 0;

    while (i < _totalRoomsNeeded && _attempts < _maxAttempts) {
        _attempts++;

        // directie dorita
        var _targetExitSide = undefined;
        if (i < _totalRoomsNeeded - 1) {
            
            if (_vSteps > 0) {
                _targetExitSide = RoomSide.BOTTOM;
            } else if (_hSteps < _cols - 1) {
                _targetExitSide = _hDir;
            } else {
                _targetExitSide = RoomSide.BOTTOM;
            }
        }

        // generare lista candidati
        if (_triedCandidates[i] == undefined) {
            var _cands = [];
            
            var _middleIndex = floor(_totalRoomsNeeded / 2);

            var _currentPool = allRooms;
            
            var _lastRoomID = -1;
            if (array_length(_mapArray) > 0) {
                _lastRoomID = _mapArray[array_length(_mapArray) - 1].room_index;
            }
            
            if (i == 0 || i == _totalRoomsNeeded - 1) {
                _currentPool = oneEnded;
            } 
            else if (i == _middleIndex) {
                _currentPool = deathmatch;
            }

            for (var r = 0; r < array_length(_currentPool); r++) {
                var _roomID = _currentPool[r];
                
                // nu punem acelasi tip de camera una langa alta
                if (i != 0 && i != _middleIndex && i != _totalRoomsNeeded - 1) {
                    if (_roomID == _lastRoomID) {
                        continue;
                    }
                }
                
                var _points = roomEntrances[? _roomID];
                
                

                for (var pIn = 0; pIn < array_length(_points); pIn++) {
                    // verificam daca ne duce in directia buna
                    if (_reqSide == undefined || _points[pIn].side == _reqSide) {
                        
                        // ultima camera
                        if (i == _totalRoomsNeeded - 1) {
                            array_push(_cands, { room: _roomID, in_idx: pIn, out_idx: pIn });
                        } 
                        
                        else if (_targetExitSide != undefined) {
                            for (var pOut = 0; pOut < array_length(_points); pOut++) {
                                
                                if (pIn == pOut && array_length(_points) > 1) continue;

                                if (_points[pOut].side == _targetExitSide) {
                                    array_push(_cands, { room: _roomID, in_idx: pIn, out_idx: pOut });
                                }
                            }
                        }
                        else {
                             array_push(_cands, { room: _roomID, in_idx: pIn, out_idx: pIn });
                        }
                    }
                }
            }
            
            // sortare cu probabilitate (te poti juca cu valorile)
            
            for (var s = 0; s < array_length(_cands); s++) {
                var _cand = _cands[s];
                var _weight = random(100);

                var _isCorridor = false;
                var _isLoot     = false;
                
                var _name = room_get_name(_cand.room);
                if (string_pos("Corridor", _name) != 0) {
                    _isCorridor = true;
                }
                if (string_pos("Loot", _name) != 0) {
                    _isLoot = true;
                }

                if (_isCorridor) {
                    _weight += 20; 
                } else if (_isLoot) {
                    _weight += 10; 
                }

                _cand.priority = _weight;
            }

            // sortam crescator ca prioritate (pop o sa le ia pe cele cu prioritatea mai mare)
            array_sort(_cands, function(elm1, elm2) {
                return elm1.priority - elm2.priority;
            });

            _triedCandidates[i] = _cands;
        }

        // alegere camera candidat
        var _success = false;
        var _list = _triedCandidates[i];

        while (array_length(_list) > 0) {
            var _cand = array_pop(_list);
            
            // verificare necesară si aici
            var _lastRoomID = -1;
            if (array_length(_mapArray) > 0) {
                _lastRoomID = _mapArray[array_length(_mapArray) - 1].room_index;
            }
            
            if (_lastRoomID != -1) {
 
                if (_lastRoomID == _cand.room) {
                    continue;
                }
            }
            
            var _points = roomEntrances[? _cand.room];
            var _pIn = _points[_cand.in_idx];
            var cam = room_get_camera(_cand.room, 7);
            var _w = camera_get_view_width(cam);
            var _h = camera_get_view_height(cam);
            var _pos_x = camera_get_view_x(cam);
            var _pos_y = camera_get_view_y(cam);
            var _tx = _curX - _pIn.x;
            var _ty = _curY - _pIn.y;
            
            var _realTx = _tx + _pos_x;
            var _realTy = _ty + _pos_y;

            // verificare coliziune
            var _collided = false;
            for (var m = 0; m < array_length(_mapArray); m++) {
                var _other = _mapArray[m];
                
                var _otherRealX = _other.world_x + _other.camera_pos_x;
                var _otherRealY = _other.world_y + _other.camera_pos_y;
                
                if (_realTx < _otherRealX + _other.width - 16 && 
                    _realTx + _w > _otherRealX + 16 &&
                    _realTy < _otherRealY + _other.height - 16 && 
                    _realTy + _h > _otherRealY + 16) {
                    _collided = true; break;
                }
            }

            if (!_collided) {
                
                var _pOut = _points[_cand.out_idx];
            
                var _node = {
                    room_index: room_get_name(_cand.room),
                    world_x: _tx, world_y: _ty,
                    width: _w, height: _h,
                    camera_pos_x: _pos_x, camera_pos_y: _pos_y,
                    in_x: _tx + _pIn.x, in_y: _ty + _pIn.y,
                    out_x: _tx + _pOut.x, out_y: _ty + _pOut.y,
                    // salavare variabile de stare
                    saved_hSteps: _hSteps,
                    saved_vSteps: _vSteps,
                    saved_hDir: _hDir,
                    saved_curX: _curX,
                    saved_curY: _curY,
                    saved_reqSide: _reqSide
                };
                
                array_push(_mapArray, _node);

                // actualizare stare pentru urmatorul pas
                if (_vSteps > 0) {
                    _vSteps--;
                } else if (_hSteps < _cols - 1) {
                    _hSteps++;
                } else { 
                    _vSteps = 1; _hSteps = 0; 
                    _hDir = (_hDir == RoomSide.RIGHT) ? RoomSide.LEFT : RoomSide.RIGHT;
                }

                _reqSide = OppositeSide(_pOut.side);
                _curX = _node.out_x;
                _curY = _node.out_y;
                
                i++;
                _success = true;
                break;
            }
        }

        // backtrack
        if (!_success) {
            _triedCandidates[i] = undefined;
            i--;

            if (i < 0) {
                break;
            }

            var _prevNode = _mapArray[i];
            _hSteps = _prevNode.saved_hSteps;
            _vSteps = _prevNode.saved_vSteps;
            _hDir = _prevNode.saved_hDir;
            _curX = _prevNode.saved_curX;
            _curY = _prevNode.saved_curY;
            _reqSide = _prevNode.saved_reqSide;

            array_delete(_mapArray, i, 1);
        }
    }

    ds_map_destroy(roomEntrances);
    return _mapArray;
}

// algem cel mai compact grid dintr-un numar de generari
function GenerateBestGridMap(_cols, _rows, _tries = 10)
{
    var _bestMap = undefined;
    var _bestScore = 999999999;
    
    var _requiredCount = (_cols * _rows) + (_rows - 1);

    for (var i = 0; i < _tries; i++) {
        var _map = GenerateGridMap(_cols, _rows);

        if (_map == undefined || array_length(_map) < _requiredCount) {
            continue; // nu e harta completa
        }

        var _last = _map[array_length(_map) - 1];

        var _score = abs(_last.world_x) + abs(_last.world_y);

        if (_score < _bestScore) {
            _bestScore = _score;
            _bestMap = _map;
        }
    }

    return _bestMap;
}