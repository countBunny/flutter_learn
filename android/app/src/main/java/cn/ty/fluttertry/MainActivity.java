package cn.ty.fluttertry;

import android.content.Intent;
import android.os.Bundle;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  String sharedText;
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
    Intent intent = getIntent();
    String action = intent.getAction();
    String type = intent.getType();
    if (Intent.ACTION_SEND.equals(action) && type!=null) {
      if ("text/plain".equals(type)) {
        //handle text being send
        handleSendText(intent);
      }
    }

    new MethodChannel(getFlutterView(), "app.channel.shared.data")
            .setMethodCallHandler(new MethodChannel.MethodCallHandler() {
              @Override
              public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
                if (methodCall.method.contentEquals("getSharedText")) {
                  result.success(sharedText);
                  sharedText = null;
                }
              }
            });
  }

  private void handleSendText(Intent intent) {
    sharedText = intent.getStringExtra(Intent.EXTRA_TEXT);
  }
}
