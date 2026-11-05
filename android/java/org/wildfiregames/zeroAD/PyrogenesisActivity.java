package org.wildfiregames.zeroAD;

import android.content.pm.ActivityInfo;
import android.graphics.Color;
import android.os.Build;
import android.os.Bundle;
import android.view.Gravity;
import android.view.KeyEvent;
import android.widget.Button;
import android.widget.FrameLayout;
import android.window.OnBackInvokedDispatcher;

import org.libsdl.app.SDLActivity;

import java.io.File;

/**
 * Minimal SDL2 host for Pyrogenesis. SDL2's nativeRunMain dlopen()s the
 * engine library and calls the exported pyrogenesis_main(...).
 */
public class PyrogenesisActivity extends SDLActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        // SDL otherwise asks for FULL_USER because the window is resizable,
        // which lets the foldable rotate into portrait and corrupts the GL
        // surface. Keep the game in a fixed landscape orientation.
        setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE);
        super.onCreate(savedInstanceState);
        setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE);

        // The native engine reads this instead of a hard-coded package path,
        // so the APK can be rebuilt/renamed without touching C++.
        SDLActivity.nativeSetenv("ZEROAD_ANDROID_DATA",
            new File(getFilesDir(), "0ad").getAbsolutePath());

        if (Build.VERSION.SDK_INT >= 33) {
            getOnBackInvokedDispatcher().registerOnBackInvokedCallback(
                OnBackInvokedDispatcher.PRIORITY_DEFAULT, this::sendBack);
        }

        addMenuButton();
    }

    private int dp(int value) {
        return Math.round(value * getResources().getDisplayMetrics().density);
    }

    private void addMenuButton() {
        // The in-game Menu GUI button is unreliable with synthetic touch on the
        // Flip 6, so provide a small hardware-style overlay that sends the
        // normal F10 "session.gui.menu.toggle" hotkey.
        Button menu = new Button(this);
        menu.setText("\u2630");
        menu.setTextColor(Color.WHITE);
        menu.setTextSize(22);
        menu.setAlpha(0.82f);
        menu.setBackgroundColor(0x66000000);
        menu.setPadding(0, 0, 0, 0);
        menu.setOnClickListener(v -> {
            SDLActivity.onNativeKeyDown(KeyEvent.KEYCODE_F10);
            SDLActivity.onNativeKeyUp(KeyEvent.KEYCODE_F10);
        });

        FrameLayout.LayoutParams params = new FrameLayout.LayoutParams(
            dp(58), dp(46), Gravity.TOP | Gravity.LEFT);
        params.setMargins(dp(8), dp(8), 0, 0);
        addContentView(menu, params);
    }

    @Override
    public void setOrientationBis(int w, int h, boolean resizable, String hint) {
        setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE);
    }

    private void sendEscape() {
        SDLActivity.onNativeKeyDown(KeyEvent.KEYCODE_ESCAPE);
        SDLActivity.onNativeKeyUp(KeyEvent.KEYCODE_ESCAPE);
    }

    private void sendBack() {
        // The 0 A.D. setup/map-browser pages expose a Back button in the
        // bottom-right corner but do not bind a global cancel hotkey. Click
        // that button for the system Back gesture so the player is not stuck
        // on Match Setup.
        int w = getWindow().getDecorView().getWidth();
        int h = getWindow().getDecorView().getHeight();
        float x = w * 0.90f;
        float y = h * 0.92f;
        SDLActivity.onNativeMouse(1, android.view.MotionEvent.ACTION_DOWN, x, y, false);
        SDLActivity.onNativeMouse(1, android.view.MotionEvent.ACTION_UP, x, y, false);
    }

    @Override
    public void onBackPressed() {
        sendBack();
    }

    @Override
    protected String getMainSharedObject() {
        return "libpyrogenesis.so";
    }

    @Override
    protected String getMainFunction() {
        return "pyrogenesis_main";
    }

    @Override
    protected String[] getArguments() {
        return new String[] { "pyrogenesis" };
    }
}
