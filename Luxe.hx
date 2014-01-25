package ;


import phoenix.BitmapFont;
import phoenix.geometry.Geometry;
import phoenix.Texture;
import phoenix.Shader;
import phoenix.Batcher;

import luxe.Rectangle;
import luxe.Vector;
import luxe.Screen;

class Luxe {

    public static var dt : Float = 0.016;
    public static var timescale : Float = 1;
    public static var fixed_timestep : Float = 0;//0.016666666667;
    public static var mouse : Vector;
    
    public static var core : luxe.Core;
    public static var debug : luxe.Debug;
    public static var draw : luxe.Draw;
    public static var audio : luxe.Audio;
    public static var timer : luxe.Timer;
    public static var events : luxe.Events;
    public static var input : luxe.Input;
    public static var scene : luxe.Scene;    
    public static var utils : luxe.utils.Utils;

#if haxebullet
    public static var physics : luxe.Physics;    
#end //haxebullet

    public static var camera : luxe.Camera;
    public static var renderer : phoenix.Renderer;
    public static var resources : phoenix.ResourceManager;    

    @:isVar public static var time(get, never) : Float;
    @:isVar public static var screen(get, never) : Screen;

    public static function get_screen() { return core.screen; }
    public static function get_time() : Float { return haxe.Timer.stamp(); }

    public static function shutdown() {
        core.lime.shutdown();
    }

        public static function showConsole(_show:Bool) {
            core.show_console( _show );
        }

        //todo , move into screen.cursor, Lab.screen.cursor.visible etc.
        public static function showCursor(_show:Bool) {
            core.lime.window.set_cursor_visible( _show );
        }
        public static function lockCursor(_lock:Bool) {
            core.lime.window.constrain_cursor_to_window_frame( _lock );
        }
        public static function cursorShown() {
            return core.lime.window.cursor_visible;
        }
        public static function cursorLocked() {
            return core.lime.window.cursor_locked;
        }
        public static function setCursorPosition(_x:Int,_y:Int) {
            core.lime.window.set_cursor_position_in_window( _x,_y );
        }

    public static function loadText(_id:String) : String {
        return lime.utils.Assets.getText(_id);
    }

    public static function loadData( _id:String ) : lime.utils.ByteArray {
        return lime.utils.Assets.getBytes(_id);
    }

    public static function loadTexture(_id:String, ?_onloaded:Texture->Void, ?_silent:Bool=false ) : Texture {
        return renderer.load_texture( _id, _onloaded, _silent );
    }
    
    public static function loadTextures(_ids:Array<String>, ?_onloaded:Array<Texture>->Void, ?_silent:Bool=false ) : Void {
        renderer.load_textures( _ids, _onloaded, _silent );
    }
    
    public static function loadFont( _id:String, ?_path:String, ?_onloaded:Void->Void ) : BitmapFont {
        return renderer.load_font(_id, _path, _onloaded);
    }

    public static function loadShader( ?_ps_id:String='default', ?_vs_id:String='default', ?_onloaded:Shader->Void ) : Shader {
        return renderer.load_shader(_ps_id, _vs_id, _onloaded);
    }

    public static function openURL( _url:String ) {
        core.lime.window.openURL( _url );
    } //openURL

    public static function fileDialogFolder(_title:String, _text:String) : String {
        return core.lime.window.fileDialogFolder(_title,_text);
    }
    public static function fileDialogOpen(_title:String, _text:String) : String {
        return core.lime.window.fileDialogOpen(_title,_text);
    }
    public static function fileDialogSave(_title:String, _text:String) : String {
        return core.lime.window.fileDialogSave(_title,_text);
    }

    public static function createBatcher( ?_name:String = 'batcher', ?_camera:luxe.Camera, ?_add:Bool=true ) {
        
        var _batcher = new Batcher( renderer, _name );
            _batcher.view = (_camera == null ? renderer.default_camera : _camera.view );
                //above the default layer
            _batcher.layer = 2;

            //the add it to the renderer
        if( _add ) {
            renderer.add_batch( _batcher );
        }

        return _batcher;

    } //createBatcher

    public static function addGeometry(_geom:Geometry) {
        renderer.default_batcher.add(_geom);
    } 
    
    public static function removeGeometry(_geom:Geometry) {
        renderer.default_batcher.remove(_geom);
    } 

    public static function addGroup( _group : Int , ?_pre_render : (phoenix.Batcher -> Void) , ?_post_render : (phoenix.Batcher -> Void) ) {
        return renderer.default_batcher.add_group( _group, _pre_render, _post_render );        
    } 
    

}

