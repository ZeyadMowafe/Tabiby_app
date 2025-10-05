package com.tabiby.tabiby;

import android.content.Intent;
import android.net.Uri;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "app_links";

    @Override
    public void configureFlutterEngine(FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler((call, result) -> {
                    switch (call.method) {
                        case "getInitialLink":
                            String initialLink = getInitialLink();
                            result.success(initialLink);
                            break;
                        default:
                            result.notImplemented();
                            break;
                    }
                });
    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        handleIntent(intent);
    }

    private String getInitialLink() {
        Intent intent = getIntent();
        Uri data = intent.getData();
        return data != null ? data.toString() : null;
    }

    private void handleIntent(Intent intent) {
        Uri data = intent.getData();
        if (data != null) {
            new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), CHANNEL)
                    .invokeMethod("onNewLink", data.toString());
        }
    }
}