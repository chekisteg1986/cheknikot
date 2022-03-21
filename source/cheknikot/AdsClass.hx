package cheknikot;

#if mobile
import com.pozirk.ads.Admob;
import com.pozirk.ads.AdmobEvent;
#end

/**
 * ...
 * @author ...
 */
class AdsClass 
{
	#if mobile
	public static var _admob:Admob ;
	#end
	public static var show_ads_every:Float = 5 * 60;
	public static var current_ads_timer:Float = 0;
	public static function update(e:Float):Void
	{
		if(current_ads_timer>0)
			current_ads_timer -= e;
	}

	public static function check_for_show():Void
	{
		#if !mobile
			return;
		#end
		
		trace('checking ads',current_ads_timer);
		if (current_ads_timer > 0) return;
		current_ads_timer = show_ads_every;
		#if mobile
		if(_admob != null)
		_admob.cacheInterstitial("ca-app-pub-9911005035954121/3816880296");
		#end
	}
	
	public static function init():Void
	{
		current_ads_timer = show_ads_every;
		
		#if mobile
        //AdMob.enableTestingAds();
        //AdMob.initAndroid("ca-app-pub-9911005035954121/7768198946", "ca-app-pub-9911005035954121/7255152921", GravityMode.BOTTOM); // may also be GravityMode.TOP
        
        _admob = new Admob();
		
        _admob.addEventListener(AdmobEvent.INIT_OK, onAdmobInit);
        _admob.addEventListener(AdmobEvent.INTERSTITIAL_CACHE_OK, onAdmobCache);
		_admob.addEventListener(AdmobEvent.INTERSTITIAL_CACHE_FAIL, onAdmobCacheFail);
		
        _admob.init(); //you can only use Admob after successful initialization
        
        #end
	}
	
	 #if mobile    
	private static function onAdmobInit(ae:AdmobEvent):Void
        {
            //_admob.showAd("ca-app-pub-9911005035954121/7768198946", Admob.SIZE_LEADERBOARD, Admob.HALIGN_CENTER, Admob.VALIGN_TOP);
            
            //_admob.
            
            //_admob.cacheInterstitial("ca-app-pub-9911005035954121/7255152921");
        }
		
        private static function onAdmobCache(ae:AdmobEvent):Void
        {
			trace('AD cache completed');
			
			
			try
			{
				if(_admob != null)
				_admob.showInterstitial();
			}
			catch (s:String)
			{
				
			}
				
			
        }
		
		private static function onAdmobCacheFail(ae:AdmobEvent):Void
        {
			trace('AD cache Failed');
			//current_ads_timer = SettingsMenu.THIS.ads * 60*0;
            //_admob.showInterstitial();
				trace(ae._data);
			
        }
    #end
	
}