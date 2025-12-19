let _rt = loadRuntime();

// module InterfaceInteraction
let _checkColor = function (color) {
    let isColor = true;

    if (typeof color === "string" && color.length === 6) {
        color = color.toUpperCase();

        for (let index = 0; index < 6; index++) {
            let charCode = color.charCodeAt(index);

            if (charCode < 48 || (charCode > 57 && charCode < 65) || charCode > 70) {
                isColor = false;
                break;
            }
        }
    } else {
        isColor = false;
    }

    return isColor;
};

let _getCallBackObj = function (res) {
    let callBackObj = {};

    if (typeof res.success === "function") {
        callBackObj.success = res.success;
    }
    if (typeof res.fail === "function") {
        callBackObj.fail = res.fail;
    }
    if (typeof res.complete === "function") {
        callBackObj.complete = res.complete;
    }

    return callBackObj;
};

_rt.showToast = function (res) {
    if (!res) {
        res = {};
    }

    let callBackObj = _getCallBackObj(res);
    _rt.callCustomCommand(callBackObj, "rt-show-toast", JSON.stringify({
        title: res.title || "",
        icon: res.icon || "success",
        image: res.image || null,
        duration: res.duration || 1500,
        mask: !!res.mask
    }));
};

_rt.hideToast = function (res) {
    if (!res) {
        res = {};
    }

    let callBackObj = _getCallBackObj(res);
    _rt.callCustomCommand(callBackObj, "rt-hide-toast");
};

_rt.showModal = function (res) {
    if (!res) {
        res = {};
    }

    if (!_checkColor(res.cancelColor)) {
        res.cancelColor = "000000";
    }
    if (!_checkColor(res.confirmColor)) {
        res.confirmColor = "576B95";
    }

    let callBackObj = _getCallBackObj(res);
    _rt.callCustomCommand(callBackObj, "rt-show-modal", JSON.stringify({
        title: res.title || "",
        content: res.content || "",
        showCancel: !!res.showCancel,
        cancelText: res.cancelText || "取消",
        cancelColor: res.cancelColor,
        confirmText: res.confirmText || "确定",
        confirmColor: res.confirmColor
    }));
},

_rt.showActionSheet = function (res) {
    if (!res) {
        res = {};
    }

    if (!_checkColor(res.itemColor)) {
        res.itemColor = "000000";
    }

    let callBackObj = _getCallBackObj(res);
    _rt.callCustomCommand(callBackObj, "rt-show-action-sheet", JSON.stringify({
        itemList: res.itemList || [],
        itemColor: res.itemColor
    }));
},

_rt.showLoading = function (res) {
    if (!res) {
        res = {};
    }

    let data = {};
    if (typeof res.success === "function") {
        data.success = res.success;
    }
    if (typeof res.fail === "function") {
        data.fail = res.fail;
    }
    if (typeof res.complete === "function") {
        data.complete = res.complete;
    }

    _rt.callCustomCommand(data, "rt-show-loading", JSON.stringify({
        title: res.title || "",
        mask: !!res.mask
    }));
},

_rt.hideLoading = function (res) {
    if (!res) {
        res = {};
    }

    let data = {};
    if (typeof res.success === "function") {
        data.success = res.success;
    }
    if (typeof res.fail === "function") {
        data.fail = res.fail;
    }
    if (typeof res.complete === "function") {
        data.complete = res.complete;
    }

    _rt.callCustomCommand(data, "rt-hide-loading");
}

if (!_rt.getUserInfo) {
    let _callback = function (cb, failArgs, successArgs, compArgs) {
        if (cb === undefined) {
            return;
        }
        if (failArgs !== undefined) {
            if (typeof cb.fail === "function") {
                cb.fail.apply(cb, failArgs);
            }
        } else {
            if (typeof cb.success == "function") {
                cb.success.apply(cb, successArgs);
            }
        }
        if (typeof cb.complete === "function") {
            cb.complete.apply(cb, compArgs);
        }
    };
    _rt.getUserInfo = function (cb) {
        _rt.authorize({
            scope: "scope.userInfo",
            success() {
                console.log("authorize user info success");
                _rt.callCustomCommand({
                    success: function (res) {
                        try {
                            let obj = JSON.parse(res);
                            _callback(cb, undefined, [obj]);
                        } catch (e) {
                            let errorMsg = "user info parse error";
                            _callback(cb, [errorMsg]);
                        }
                    },
                    fail: function (res) {
                        let errorMsg = "call 'getUserInfo' custom command fail";
                        _callback(cb, [errorMsg]);
                    },
                    undefined
                }, "getUserInfo");
            },
            fail() {
                let errorMsg = "without user info permission";
                _callback(cb, [errorMsg]);
            }
        });
    };
}

if (!_rt.saveImageToPhotosAlbum) {
    _rt.saveImageToPhotosAlbum = function (object) {
        let filePath = "";
        if (typeof object === "object") {
            if (typeof object.filePath === "string") {
                filePath = object.filePath;
            }
        } else {
            object = {};
        }
        _rt.callCustomCommand({
            success: object.success,
            fail: object.fail,
            complete: object.complete
        }, "rt-media-image-save-image-to-photos-album", filePath);
    };
}

if (!_rt.previewImage) {
    _rt.previewImage = function (object) {
        let current = "";
        let urls = [];
        if (typeof object === "object") {
            if (typeof object.current === "string") {
                current = object.current;
            }
            let array = object.urls;
            if (Array.isArray(array)) {
                let length = array.length;
                for (let index = 0; index < length; ++index) {
                    if (typeof array[index] === "string") {
                        urls.push(array[index]);
                    }
                }
            }
        } else {
            object = {};
        }
        _rt.callCustomCommand({
            success: object.success,
            fail: object.fail,
            complete: object.complete
        }, "rt-media-image-preview-image", current, urls);
    };
}

if (!_rt.chooseImage) {
    _rt.chooseImage = function (object) {
        let count = 9;
        let sizeType = ['original', 'compressed'];
        let sourceType = ['album', 'camera'];
        if (typeof object === "object") {
            if (typeof object.count === "number") {
                count = object.count;
            }
            if (Array.isArray(object.sizeType)) {
                let array = object.sizeType;
                let length = array.length;
                let original = false;
                let compressed = false;
                for (let index = 0; index < length; ++index) {
                    if (array[index] === "original") {
                        original = true;
                    } else if (array[index] === "compressed") {
                        original = true;
                    }
                }
                if (original) {
                    if (!compressed) {
                        sizeType = ["original"];
                    }
                } else if (compressed) {
                    sizeType = ["compressed"];
                }
            }
            if (Array.isArray(object.sourceType)) {
                let array = object.sourceType;
                let length = array.length;
                let album = false;
                let camera = false;
                for (let index = 0; index < length; ++index) {
                    if (array[index] === "album") {
                        album = true;
                    } else if (array[index] === "camera") {
                        camera = true;
                    }
                }
                if (album) {
                    if (!camera) {
                        sourceType = ["album"];
                    }
                } else if (camera) {
                    sourceType = ["camera"];
                }
            }
        } else {
            object = {};
        }
        _rt.callCustomCommand({
            success: function (choices) {
                let tempFilePaths = [];
                let tempFiles = [];
                let length = choices.length;
                for (let index = 0; index < length; index += 2) {
                    tempFilePaths[index / 2] = choices[index];
                    tempFiles[index / 2] = {
                        path: choices[index],
                        size: parseInt(choices[index + 1])
                    };
                }
                if (typeof object.success == "function") {
                    object.success({
                        tempFilePaths: tempFilePaths.slice(),
                        tempFiles: tempFiles.slice()
                    });
                }
                if (typeof object.complete == "function") {
                    object.complete({
                        tempFilePaths: tempFilePaths,
                        tempFiles: tempFiles
                    });
                }
            },
            fail: function (res) {
                if (typeof object.fail == "function") {
                    object.fail(res);
                }
                if (typeof object.complete == "function") {
                    object.complete(res);
                }
            },
        }, "rt-media-image-choose-image", count, sizeType, sourceType);
    };
}

if (!_rt.openSetting) {
    _rt.openSetting = function (object) {
        if (typeof object !== "object") {
            object = {};
        }
        _rt.callCustomCommand({
            success: function (res) {
                if (typeof object.success == "function") {
                    object.success(JSON.parse(res));
                }
                if (typeof object.complete == "function") {
                    object.complete(JSON.parse(res));
                }
            },
            fail: function (res) {
                if (typeof object.fail == "function") {
                    object.fail(res);
                }
                if (typeof object.complete == "function") {
                    object.complete(res);
                }
            },
        }, "rt-open-setting");
    };
}

if (!_rt.getSetting) {
    _rt.getSetting = function (object) {
        if (typeof object !== "object") {
            object = {};
        }
        _rt.callCustomCommand({
            success: function (res) {
                if (typeof object.success == "function") {
                    object.success(JSON.parse(res));
                }
                if (typeof object.complete == "function") {
                    object.complete(JSON.parse(res));
                }
            },
            fail: function (res) {
                if (typeof object.fail == "function") {
                    object.fail(res);
                }
                if (typeof object.complete == "function") {
                    object.complete(res);
                }
            },
        }, "rt-get-setting");
    };
}

let _menuButtonBoundingClientRect = {
    left: 0,
    right: 0,
    top: 0,
    bottom: 0,
    width: 0,
    height: 0
};
let _listeningMenuBoundingClientRect = function(first) {
    _rt.callCustomCommand({
        success: function (res) {
            // res[0] x, res[1] y, res[2] width, res[3] height
            _menuButtonBoundingClientRect.left = res[0];
            _menuButtonBoundingClientRect.top = res[1];
            _menuButtonBoundingClientRect.right = res[0] + res[2];
            _menuButtonBoundingClientRect.bottom = res[1] + res[3];
            _menuButtonBoundingClientRect.width = res[2];
            _menuButtonBoundingClientRect.height = res[3];
            setTimeout(function () {
                _listeningMenuBoundingClientRect(false);
            }, 200);
        },
        fail: function () {
            setTimeout(function () {
                _listeningMenuBoundingClientRect(first);
            }, 200);
        },
    }, "rt-get-menu-bounding-client-rect", first);
};
_listeningMenuBoundingClientRect(true);
_rt.getMenuButtonBoundingClientRect = function () {
    return Object.assign({}, _menuButtonBoundingClientRect);
};

const _videosWeakMap = new WeakMap();
if (_rt.createVideo !== undefined) {
    let createVideo = _rt.createVideo;
    delete _rt.createVideo;
    //参考wx小游戏平台createvideo的object参数属性
    //https://developers.weixin.qq.com/minigame/dev/api/media/video/wx.createVideo.html
    _rt.createVideo = function (obj) {
        let video = createVideo();
        if (typeof obj === "object") {
            _videosWeakMap.set(video, {
            _x: 0,
            _y: 0,
            _width: 0,
            _height: 0,
            _underGameView: false,
            _objectFit: "contain",
            _backgroundColor: "#000000"
            });
            if (typeof obj.x === "number") {
                video.x = Math.floor(obj.x);
            } else {
                video.x = 0;
                console.warn("create video with a invalid argument!use default value!");
            }
            if (typeof obj.y === "number") {
                video.y = Math.floor(obj.y);
            } else {
                video.y = 0;
                console.warn("create video with a invalid argument!use default value!");
            }
            if (typeof obj.width === "number") {
                video.width = Math.floor(obj.width);
            } else {
                video.width = 0;
                console.warn("create video with a invalid argument!use default value!");
            }
            if (typeof obj.height === "number") {
                video.height = Math.floor(obj.height);
            } else {
                video.height = 0;
                console.warn("create video with a invalid argument!use default value!");
            }
            if ((typeof obj.underGameView === "boolean" || obj.underGameView === null)) {
                video.underGameView = obj.underGameView;
            } else {
                video.underGameView = false;
                console.warn("create video with a invalid argument!use default value!");
            }
            if ((obj.objectFit === "fill" || obj.objectFit === "contain" || obj.objectFit === "cover")) {
                video.objectFit = obj.objectFit;
            } else {
                video.objectFit = "contain";
                console.warn("create video with a invalid argument!use default value!");
            }
            if (typeof obj.backgroundColor === "string" && obj.backgroundColor.length == 7) {
                video.backgroundColor = obj.backgroundColor;
            } else {
                video.backgroundColor = "#000000";
                console.warn("create video with a invalid argument!use default value!");
            }
            video.onResize(function () {
                switch (this.objectFit) {
                    case "fill":
                    case "contain":
                    case "cover":
                        break;
                    default:
                        console.warn("set property objectFit with a invalid value!");
                        return;
                }
                _rt.callCustomCommand({
                success: function (res) {},
                fail: function (res) {}
                }, "rt-set-media-view-objectfit", this.instanceID, this.videoWidth, this.videoHeight, this.objectFit, this.width, this.height);
            });
            return video;
        } else {
            console.error("create video with a invalid object!");
            return null;
        }
    };
}

Object.defineProperty(_rt.Video.prototype, "underGameView", {
    configurable: false,
    enumerable: true,
    set: function (val) {
        let privateThis = _videosWeakMap.get(this);
        if (privateThis) {
            if (typeof val === "boolean") {
                privateThis._underGameView = val;
                _rt.callCustomCommand({
                success: function (res) {},
                fail: function (res) {}
                }, "rt-set-media-view-under-game-view", this.instanceID, this.x, this.y, this.width, this.height, val);
            } else if (val == null) {
                privateThis._underGameView = val;
                _rt.callCustomCommand({
                success: function (res) {},
                fail: function (res) {}
                }, "rt-set-media-view-disable", this.instanceID);
            } else {
                console.warn("set property underGameView with a invalid value!");
                return null;
            }
            
        }
    },
    get: function () {
        let privateThis = _videosWeakMap.get(this);
        return privateThis ? privateThis._underGameView : false;
    }
});

Object.defineProperty(_rt.Video.prototype, "backgroundColor", {
    configurable: false,
    enumerable: true,
    set: function (val) {
        let privateThis = _videosWeakMap.get(this);
        if (privateThis) {
            if (typeof val === "string" && val.length == 7) {
                privateThis._backgroundColor = val;
                _rt.callCustomCommand({
                success: function (res) {},
                fail: function (res) {}
                }, "rt-set-media-view-background-color", this.instanceID, val);
            } else {
                console.warn("set property backgroundColor with a invalid value!");
                return null;
            }
        }
    },
    get: function () {
        let privateThis = _videosWeakMap.get(this);
        return privateThis ? privateThis._backgroundColor : false;
    }
});

Object.defineProperty(_rt.Video.prototype, "x", {
    configurable: false,
    enumerable: true,
    set: function (val) {
        if (typeof val === "number") {
            val = Math.floor(val);
            let privateThis = _videosWeakMap.get(this);
            if (privateThis) {
                privateThis._x = val;
                _rt.callCustomCommand({
                success: function (res) {},
                fail: function (res) {}
                }, "rt-set-media-view-posx", this.instanceID, val);
                
            }
        } else {
            console.warn("set video property with invalid value!");
        }
    },
    get: function () {
        let privateThis = _videosWeakMap.get(this);
        return privateThis ? privateThis._x : 0;
    }
});

Object.defineProperty(_rt.Video.prototype, "y", {
    configurable: false,
    enumerable: true,
    set: function (val) {
        if (typeof val === "number") {
            val = Math.floor(val);
            let privateThis = _videosWeakMap.get(this);
            if (privateThis) {
                privateThis._y = val;
                _rt.callCustomCommand({
                success: function (res) {},
                fail: function (res) {}
                }, "rt-set-media-view-posy", this.instanceID, val);
                
            }
        } else {
            console.warn("set video property with invalid value!");
        }
        
    },
    get: function () {
        let privateThis = _videosWeakMap.get(this);
        return privateThis ? privateThis._y : 0;
    }
});

Object.defineProperty(_rt.Video.prototype, "width", {
    configurable: false,
    enumerable: true,
    set: function (val) {
        if (typeof val === "number") {
            val = Math.floor(val);
            let privateThis = _videosWeakMap.get(this);
            if (privateThis) {
                privateThis._width = val;
                _rt.callCustomCommand({
                success: function (res) {},
                fail: function (res) {}
                }, "rt-set-media-view-width", this.instanceID, val);
                
            }
        } else {
            console.warn("set video property with invalid value!");
        }
    },
    get: function () {
        let privateThis = _videosWeakMap.get(this);
        return privateThis ? privateThis._width : 0;
    }
});

Object.defineProperty(_rt.Video.prototype, "height", {
    configurable: false,
    enumerable: true,
    set: function (val) {
        if (typeof val === "number") {
            val = Math.floor(val);
            let privateThis = _videosWeakMap.get(this);
            if (privateThis) {
                privateThis._height = val;
                _rt.callCustomCommand({
                success: function (res) {},
                fail: function (res) {}
                }, "rt-set-media-view-height", this.instanceID, val);
                
            }
        } else {
            console.warn("set video property with invalid value!");
        }
    },
    get: function () {
        let privateThis = _videosWeakMap.get(this);
        return privateThis ? privateThis._height : 0;
    }
});

Object.defineProperty(_rt.Video.prototype, "objectFit", {
    configurable: false,
    enumerable: true,
    set: function (val) {
        let privateThis = _videosWeakMap.get(this);
        if (privateThis) {
            switch (val) {
                case "fill":
                case "contain":
                case "cover":
                    break;
                default:
                    console.warn("set property objectFit with a invalid value!");
                    return;
            }
            privateThis._objectFit = val;
            _rt.callCustomCommand({
            success: function (res) {},
            fail: function (res) {}
            }, "rt-set-media-view-objectfit", this.instanceID, this.videoWidth, this.videoHeight, privateThis._objectFit, this.width, this.height);
            
        }
    },
    get: function () {
        let privateThis = _videosWeakMap.get(this);
        return privateThis ? privateThis._objectFit : "contain";
    }
});
