package com.arrahmah.app

import android.content.Context
import android.content.pm.PackageManager

/** LaunchExternalAppPlugin */
public class AppLauncher(private val context: Context) {

    fun isAppInstalled(packageName: String): Boolean {
        return try {
            context.packageManager.getPackageInfo(packageName, 0)
            true
        } catch (ignored: PackageManager.NameNotFoundException) {
            false
        }
    }

    fun launchApp(packageName: String): Boolean {
        val launchIntent = context.packageManager.getLaunchIntentForPackage(packageName)
        if (launchIntent != null) {
            context.startActivity(launchIntent)
            return true
        }
        return false
    }
}
