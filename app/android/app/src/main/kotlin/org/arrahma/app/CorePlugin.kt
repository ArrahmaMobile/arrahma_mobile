package  com.arrahmah.app

import android.app.Activity
import android.content.Context
import android.view.WindowManager
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result


/** CorePlugin */
public class CorePlugin(private val context: Context) : MethodCallHandler {

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (call.method == "isAppInstalled") {
            val packageName: String? = call.argument("packageName")
            result.success(if (packageName != null) AppLauncher(context!!).isAppInstalled(packageName) else false)
        } else if (call.method == "launchApp") {
            val packageName: String? = call.argument("packageName")
            result.success(if (packageName != null) AppLauncher(context!!).launchApp(packageName) else false)
        } else {
            result.notImplemented()
        }
    }
}
