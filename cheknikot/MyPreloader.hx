package cheknikot;

import flixel.FlxG;
import flixel.system.FlxPreloader;
import flash.events.Event;

#if flash
import com.newgrounds.*;
import com.newgrounds.API;
import com.newgrounds.components.*;
#end
#if mobile
import flash.system.Capabilities;
#end
/**
 * ...
 * @author ...
 */
class MyPreloader extends FlxPreloader
{

	public function new(MinDisplayTime:Float=10, ?AllowedURLs:Array<String>) 
	{
		
		#if !flash
		MinDisplayTime = 0;
		#end
		#if debug
		MinDisplayTime = 0;
		#end
		
		super(MinDisplayTime, AllowedURLs);
		
		#if flash
		addEventListener(Event.ADDED_TO_STAGE, connect_to_api);	
		#end
	}
	
	#if flash
	public function connect_to_api(e:Event):Void
	{
		if ( GameParams.compile_for_newgrounds)
		{
			function onAPIConnected(event:APIEvent):Void
				{
					create_ad();
				}
				
			API.connect(root, "49040:a3ico678", "2MAvx5ZJsQNwLGCEgEeaQgWCkLjPBvKM");	
			API.addEventListener(APIEvent.API_CONNECTED, onAPIConnected);
		}
	}
	#end
	
	public function create_ad():Void
	{
		
		#if flash
			if (GameParams.compile_for_newgrounds)
			{
				
				if ( API.isNewgrounds)
					{
						if (stage != null)
						{
							var ad:FlashAd = new FlashAd();
							
							ad.x = (stage.stageWidth / 2) - (ad.width/2);
							ad.y = (stage.stageHeight / 2) - (ad.height/2);
							addChild(ad);
							
							minDisplayTime = 10;
						}
					}
			}
		#end
	}
	
	override function create():Void 
	{
		super.create();
		
		
		
		
		
		x = stage.stageWidth / 2 - this.width / 2;
		#if mobile
			x = Capabilities.screenResolutionX/2- this.width / 2;
			y = Capabilities.screenResolutionY/2- this.height / 2;
		
		#end
		
		FlxG.autoPause = false;
		
		
		//y = stage.stageHeight / 2 - this.height/2;
		//#end
		
		
	}
	
	
}