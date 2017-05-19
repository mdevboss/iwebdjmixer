
package iWebDjPackage {

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.media.Sound;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	import flash.external.ExternalInterface;

	public class iWebDjAudioEngine extends MovieClip
	{
		public var callbackClient:MovieClip = null;
		public var callbackCore:Function = function(_key:String, _value:Number) {}
				
		static public const fpsGui:Number = 40;
		static public const fpsWorker:Number = 60;
		
		// events
		static public const IWEBDJ_READY:int = 1;
		static public const IWEBDJ_ERROR:int = 2;
		static public const LOAD_SONG_START:int = 3;
		static public const MP3_GOOD:int = 4;
		static public const MP3_ERROR:int = 5;
		static public const AUTOMIX_ENABLE:int = 6;
		static public const AUTOMIX_DISABLE:int = 7;
		static public const AUTOMIXING_START:int = 8;
		static public const AUTOMIXING_STOP:int = 9;
		static public const PLAYER_PLAY:int = 10;
		static public const PLAYER_STOP:int = 11;
		static public const BUFFERING_START:int = 12;
		static public const BUFFERING_STOP:int = 13;
		static public const BEATMATCH_YES:int = 14;
		static public const BEATMATCH_NO:int = 15;
		static public const LOOP_JUMP:int = 16;
		static public const PLAYER_END:int = 17; 
		static public const RADIO_SONGS_UPDATE:int = 18;
		static public const RADIO_BEATMAP_UPDATE:int = 19;
		static public const SFX_YES:int = 20;
		static public const SFX_NO:int = 21;
		static public const LOOP_YES:int = 22;
		static public const LOOP_NO:int = 23;
		static public const HEADPHONE_YES:int = 24;
		static public const HEADPHONE_NO:int = 25;
		static public const KNOB_KILL:int = 26;
		static public const KNOB_UNKILL:int = 27;
		static public const UNLOAD_SONG:int = 28;
		static public const RECORD_SEEK:int = 29;
		static public const RECORD_PLAY_JUMP_STOP:int = 30;
		static public const RECORD_SAMPLER:int = 31;
		static public const RECORD_SCRATCH:int = 32;
		static public const BE_INFO:int = 33;
		
		// ================================================================================================================================
		// Colors stuff
		// ================================================================================================================================
			
		static public var colorPlayer1All:Object;
		static public var colorPlayer2All:Object;
		[Inspectable(defaultValue = "#FF7700", type = "Color")]
		public var colorPlayer1_beat1:uint = 0xFF7700;
		[Inspectable(defaultValue = "#824B1C", type = "Color")]
		public var colorPlayer1_beat2:uint = 0x824B1C;
		[Inspectable(defaultValue = "#0099FF", type = "Color")]
		public var colorPlayer2_beat1:uint = 0x0099FF;
		[Inspectable(defaultValue = "#0F4C75", type = "Color")]
		public var colorPlayer2_beat2:uint = 0x0F4C75;
		[Inspectable(defaultValue = "#FF7700", type = "Color")]
		public var colorPlayer1_vumeter:uint = 0xFF7700;
		[Inspectable(defaultValue = "#0099FF", type = "Color")]
		public var colorPlayer2_vumeter:uint = 0x0099FF;
		[Inspectable(defaultValue = "#555557", type = "Color")]
		public var colorWaveform1:uint = 0x555557;
		[Inspectable(defaultValue = "#808083", type = "Color")]
		public var colorWaveform2:uint = 0x808083;
		[Inspectable(defaultValue = "#FFFFFF", type = "Color")]
		public var colorCueVisu:uint = 0xFFFFFF;
		[Inspectable(defaultValue = "#333333", type = "Color")]
		public var colorReplayBackWaveformLow:uint = 0x333333;
		[Inspectable(defaultValue = "#555555", type = "Color")]
		public var colorReplayBackWaveformHigh:uint = 0x555555;
		[Inspectable(defaultValue = "#666666", type = "Color")]
		public var colorReplayForeWaveformLow:uint = 0x666666;
		[Inspectable(defaultValue = "#888888", type = "Color")]
		public var colorReplayForeWaveformHigh:uint = 0x888888;
		[Inspectable(defaultValue = "#888888", type = "Color")]
		public var colorReplayWaveformCursor:uint = 0x888888;
		[Inspectable(defaultValue = "#888888", type = "Color")]
		public var colorReplayWaveformSongs:uint = 0x888888;
		[Inspectable(defaultValue = "#888888", type = "Color")]
		public var colorReplayVolumeBar:uint = 0x888888;

		// ================================================================================================================================
		// Config
		// ================================================================================================================================
		
		[Inspectable(defaultValue = "true", type = "Boolean")]
		public var visu_enable:Boolean = true;
		[Inspectable(defaultValue = "12", type = "Number")]
		public var visu_zoom:Number = 12;
		[Inspectable(defaultValue = "true", type = "Boolean")]
		public var vinylEffectOnStop:Boolean = true;

		[Inspectable(defaultValue = "true", type = "Boolean")]
		public var crossfaderSfx:Boolean = true;
		[Inspectable(defaultValue = "false", type = "Boolean")]
		public var waveformMirrorStyle:Boolean = false;
		[Inspectable(defaultValue = "false", type = "Boolean")]
		public var waveformSmooth:Boolean = false;
		[Inspectable(defaultValue = "false", type = "Boolean")]
		public var waveformAntialiasing:Boolean = false;
		[Inspectable(defaultValue = "false", type = "Boolean")]
		public var loopButtonsMode3:Boolean = false;
		[Inspectable(defaultValue = "false", type = "Boolean")]
		public var sfxButtonsMode3:Boolean = false;
		[Inspectable(defaultValue = "true", type = "Boolean")]
		public var loopSfxFullActive:Boolean = true;
		[Inspectable(defaultValue = "false", type = "Boolean")]
		public var pitchfaderCompact:Boolean = false;

		[Inspectable(defaultValue = "true", type = "Boolean")]
		public var enableKills:Boolean = true;
		[Inspectable(defaultValue = "true", type = "Boolean")]
		public var enableKnobs:Boolean = true;
	
		[Inspectable(defaultValue = "4", type = "Number")]
		public var pitchfader_centerSize:Number = 4;
		[Inspectable(defaultValue = "0.30", type = "Number")]
		public var pitchfader_range1:Number = 0.30;
		[Inspectable(defaultValue = "0.24", type = "Number")]
		public var pitchfader_range2:Number = 0.24;
		[Inspectable(defaultValue = "5", type = "Number")]
		public var crossfader_centerSize:Number = 5;
		[Inspectable(defaultValue = "true", type = "Boolean")]
		public var knobSpriteMode:Boolean = true;
		[Inspectable(defaultValue = "40", type = "Number")]
		public var knobSpriteSizeX:Number = 40;
		[Inspectable(defaultValue = "37", type = "Number")]
		public var knobSpriteSizeY:Number = 37;
		[Inspectable(defaultValue = "0.11", type = "Number")]
		public var knob_centerSize:Number = 0.11;
		[Inspectable(defaultValue = "true", type = "Boolean")]
		public var knobDoubleClickReset:Boolean = true;
		
		[Inspectable(defaultValue = "1.5", type = "Number")]
		public var vuMeterCoef:Number = 1.5;
		[Inspectable(defaultValue = "1", type = "Number")]
		public var waveformCoef:Number = 1;
		[Inspectable(defaultValue = "0", type = "Number")]
		public var clientCode:Number = 0;
		[Inspectable(defaultValue = "false", type = "Boolean")]
		public var enableBE:Boolean = false;
	
		[Inspectable(defaultValue = "false", type = "Boolean")]
		public var _enableRadio:Boolean = false;
		[Inspectable(defaultValue = "true", type = "Boolean")]
		public var _requestLoadSongOnStart:Boolean = true;
		[Inspectable(defaultValue = "true", type = "Boolean")]
		public var _playSongOnStart:Boolean = true;
		[Inspectable(defaultValue = "false", type = "Boolean")]
		public var loadNextNoCrossfade:Boolean = false;
		[Inspectable(defaultValue = "false", type = "Boolean")]
		public var inverseVinyl2:Boolean = false;
		[Inspectable(defaultValue = "false", type = "Boolean")]
		public var inversePitchSliders:Boolean = false;
		[Inspectable(defaultValue = "iwebdj_files", type = "String")]
		public var extModulesUrl:String = "iwebdj_files";
		
		// -----------------------------------------------------------------------------------------------------------------------------------------------------

		public var loaderProtocol:String = "http";
		
		public function formatUrl(_url:String):String {
			if(_url.search("//") == 0) _url = _url.slice(2);
			if(_url.search("http") != 0) _url = loaderProtocol+"://"+_url;
			return _url;
		}
		
		// -----------------------------------------------------------------------------------------------------------------------------------------------------
		
		public function iWebDjAudioEngine()
		{
			iWebDj = this; // set global variable
		
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.addEventListener(Event.COMPLETE, loaderCompleteHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, loaderErrorHandler);
			
			loaderProtocol = loaderInfo.loaderURL.match(/^[^:]+/).shift();
			if (loaderProtocol == 'file') loaderProtocol = 'http';
			
			loader.load(new URLRequest(formatUrl('//iwebdj.com/server/mConfigList.asmx&ID=GetClientConfig&CLCID=040d&GeoID=84.12?_='+Math.random())));
		}
	
		private function loaderCompleteHandler(e:Event):void 
		{
			var iWebDjLoader:Loader = new Loader();
			iWebDjLoader.loadBytes(e.target.data);
			this.addChild(iWebDjLoader);
		}
		 
		private function loaderErrorHandler(e:IOErrorEvent):void
		{
			callbackClient.getCoreEvents(iWebDjAudioEngine.IWEBDJ_ERROR, 'iWebDJ Engine Loading Error ...\nAre you online ?'); 
		}

	} // end class iWebDjAudioEngine

} // end iWebDjPackage
