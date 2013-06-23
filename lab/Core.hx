package lab;

import nmegl.NMEGL;

import lab.Audio;
import lab.Events;
import lab.Input;
import lab.Files;
import lab.Debug;
import lab.Time;
import lab.Renderer;

import haxe.Timer;

class Core {

		//core versioning
	public var version : String = '0.1';
		//the game object running the core
    public var host : Dynamic;  
        //the config passed to us on creation
	public var config : Dynamic;

        //the reference to the underlying NMEGL system
    public var nmegl : NMEGL;

//Sub Systems, mostly in order of importance
	public var debug    : Debug;
	public var file 	: Files;
	public var time 	: Time;
	public var events 	: Events;
	public var input 	: Input;
    public var audio    : Audio;
	public var renderer : Dynamic;

//flags
	
	   //if we have started a shutdown
    public var shutting_down : Bool = false;
    public var has_shutdown : Bool = false;

    	//constructor
    public function new( _nmegl:NMEGL, _host:Dynamic ) {
            
            //Keep a reference for use
        nmegl = _nmegl;
        host = _host;

    } //new
    
        //This gets called once the create_main_frame call inside new() 
        //comes back with our window

    private function ready() {
        
        _debug(':: haxelab :: Version ' + version);

          	//Create the subsystems

        startup();

        _debug(':: haxelab :: Ready.');
        _debug('');

        	//Call the main ready function 
        	//and send the ready event to the host
        if(host.ready != null) {
            host.ready();
        }

    } //on_main_frame_created

    public function startup() {
		//Create the subsystems

		_debug(':: haxelab :: Creating subsystems.');

			//Order is important here
		
		debug = new Debug( this );
		file = new Files( this );
		time = new Time( this );
		events = new Events( this );
		audio = new Audio( this );	
		input = new Input( this );

        if(nmegl.config.renderer == null) {
            renderer = new Renderer( this );
        } else {
            renderer = Type.createInstance(nmegl.config.renderer, [this]);
        }

			//Now make sure they start up

		debug.startup();
		file.startup();
		time.startup();
		events.startup();
		audio.startup();
		input.startup();
        
        if(renderer != null && renderer.startup != null) {
            renderer.startup();
        }

    }

    public function shutdown() {        

		_debug('');
		_debug(':: haxelab :: Shutting down...');

            //Make sure all systems know we are going down

        shutting_down = true;

            //shutdown the game class
        if(host.shutdown != null) {
            host.shutdown();
        }        

    		//Order is imporant here too

        if(renderer != null && renderer.shutdown != null) {
            renderer.shutdown();
        }

    	input.shutdown();
    	audio.shutdown();
    	events.shutdown();
    	time.shutdown();
    	file.shutdown();
    	debug.shutdown();

    		//Clear up for GC
    	input = null;
    	audio = null;
    	events = null;
    	time = null;
    	file = null;
    	debug = null;

            //Flag it
        has_shutdown = true;

        _debug(':: haxelab :: Goodbye.');
    }

    	//Called by NMEGL
    public function update() { 

        _debug('on_update ' + Timer.stamp(), true, true); 

        if(has_shutdown) return;

            //Update all the subsystems, again, order important

        time.process();     //Timers first
        input.process();    //Input second
        audio.process();    //Audio
        debug.process();    //debug late
        events.process();   //events last

            //Update the game class for them
        if(host.update != null) {
            host.update();
        }

    } //update

        //called by NMEGL
    public function render() {
        if(renderer != null && renderer.process != null) {
            renderer.process();   
        }
    }

//External overrides
    public function set_renderer( _renderer:Renderer ) {
        if(_renderer != null) {
            renderer = _renderer;
        }
    }

//Lib load wrapper
    public static function load( library:String, method:String, args:Int = 0 ) : Dynamic {
        return nmegl.utils.Libs.load( library, method, args );
    }

//Noisy stuff

   		//temporary debugging with verbosity options

	public var log : Bool = true;
    public var verbose : Bool = true;
    public var more_verbose : Bool = false;
    public function _debug(value:Dynamic, _verbose:Bool = false, _more_verbose:Bool = false) { 
        if(log) {            
            if(verbose && _verbose && !_more_verbose) {
                trace(value);
            } else 
            if(more_verbose && _more_verbose) {
                trace(value);
            } else {
                if(!_verbose && !_more_verbose) {
                    trace(value);
                }
            } //elses
        } //log
    } //_debug
}