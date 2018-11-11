package game.utils 
{
	import flash.net.*;
	
	import com.aratush.ane.toast.DurationEnum;
	import com.aratush.ane.toast.GravityEnum;
	import com.aratush.ane.toast.ToastExtension;
	
	/**
	 * ...
	 * @author Monkgol
	 */	 
	public class Utils 
	{
		public static function showToast(text:String):void {
			if (ToastExtension.isSupported)
			{
				var toast:ToastExtension = new ToastExtension();
				toast.setText(text);
				toast.setDuration(DurationEnum.LENGTH_LONG);
				toast.setGravity(GravityEnum.CENTER, 0, 50);
				toast.show();
				// close the toast 
				// toast.cancel();
			}
		}
		
		// Расшарить в соц. сетях
		public static function shareTo(site:String, text:String, link:String, title:String = null, image:String = null):void
		{
			var siteURL:String;
			
			switch (site)
			{
				case "facebook":
					siteURL = "http://www.facebook.com/share.php?u=" + encodeURIComponent(link) + "&t=" + encodeURIComponent(text);
					break;
				case "twitter":
					siteURL = "http://twitter.com/share?text=" + encodeURIComponent(text) + "&url=" + encodeURIComponent(link);
					break;
				case "vkontakte":
					siteURL = "http://vk.com/share.php?url=" + encodeURIComponent(link)+ "&title=" + encodeURIComponent(title)+ "&description=" + encodeURIComponent(text) + "&image=" + encodeURIComponent(image);
					break;
				case "odnoklassniki":
					siteURL = "http://www.odnoklassniki.ru/dk?st.cmd=addShare&st.s=1&st._surl=" + encodeURIComponent(link)+ "&title=" + encodeURIComponent(title)+ "&description=" + encodeURIComponent(text) + "&image=" + encodeURIComponent(image);
					break;
				case "moymir":
					siteURL = "http://connect.mail.ru/share?share_url=" + encodeURIComponent(link)+ "&title=" + encodeURIComponent(title)+ "&description=" + encodeURIComponent(text) + "&image=" + encodeURIComponent(image);
					break;
				case "livejournal":
					siteURL = "http://www.livejournal.com/update.bml?subject=" + encodeURIComponent(title)+ "&event=" + encodeURIComponent(link) + "%0A" + encodeURIComponent(text);
					break;
			}

			navigateToURL(new URLRequest(siteURL), "_blank");
		}
		
		// Перейти по ссылку в интернете
		public static function goTo(url:String):void
		{
			navigateToURL(new URLRequest(url), "_blank");
		}
		
	}

}