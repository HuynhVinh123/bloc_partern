package vn.tpos.tposmobile;

import io.flutter.app.FlutterApplication;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback;
import io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingBackgroundService;

public class Application extends FlutterApplication implements PluginRegistrantCallback {
    @Override
    public void onCreate() {
        super.onCreate();
       //FlutterFirebaseMessagingService.setPluginRegistrant(this);
        FlutterFirebaseMessagingBackgroundService.setPluginRegistrant(this);
    }

    @Override
    public void registerWith(PluginRegistry registry) {
        //GeneratedPluginRegistrant.registerWith((FlutterEngine) registry);
    }
}