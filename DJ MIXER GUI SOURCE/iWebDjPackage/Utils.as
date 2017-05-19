
package iWebDjPackage {

	import flash.external.ExternalInterface;
	import flash.system.Capabilities;

	public class Utils {

		public static function checkWorker():Boolean {
			var ver:Array = Capabilities.version.match(/[\d]+/g);

			var pepperWorker:Boolean = (Capabilities.manufacturer == "Google Pepper");
			pepperWorker &&= (int(ver[0]) > 11) || (int(ver[0]) == 11 && int(ver[1]) >= 8);
			
			var legacyWorker:Boolean = (Capabilities.manufacturer != "Google Pepper" && Capabilities.manufacturer != "Adobe Linux");
			legacyWorker &&= (int(ver[0]) > 11) || (int(ver[0]) == 11 && int(ver[1]) >= 4);

			return !Capabilities.isDebugger && (pepperWorker || legacyWorker);
		}
	}

}
