package game.utils 
{
	import flash.net.*;
	
	/**
	 * ...
	 * @author Monkgol
	 */	 
	public class Utils 
	{		
		
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