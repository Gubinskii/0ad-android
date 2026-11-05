package org.wildfiregames.zeroAD;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.Gravity;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.util.Log;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;

/**
 * First-run bootstrap: the 0 A.D. data tree is shipped as assets/0ad-data.zip
 * and extracted into the app's private files directory. The engine then reads
 * /data/data/<package>/files/0ad, which is always accessible without storage
 * permissions on modern Android.
 */
public class LauncherActivity extends Activity {
    private static final String TAG = "0ad-bootstrap";
    private static final String MARKER = ".data-audio1";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        final File root = new File(getFilesDir(), "0ad");
        final File marker = new File(root, MARKER);
        final File maps = new File(root, "data/mods/public/maps.zip");
        if (marker.isFile() && maps.isFile()) {
            startGame();
            return;
        }

        LinearLayout layout = new LinearLayout(this);
        layout.setOrientation(LinearLayout.VERTICAL);
        layout.setGravity(Gravity.CENTER);
        layout.setPadding(64, 64, 64, 64);
        TextView text = new TextView(this);
        text.setText("Preparing 0 A.D. data…");
        text.setTextSize(22);
        ProgressBar progress = new ProgressBar(this, null, android.R.attr.progressBarStyleHorizontal);
        progress.setIndeterminate(true);
        layout.addView(text);
        layout.addView(progress);
        setContentView(layout);

        new Thread(() -> {
            try {
                extract(root, marker);
                runOnUiThread(this::startGame);
            } catch (Throwable t) {
                Log.e(TAG, "data extraction failed", t);
                runOnUiThread(() -> {
                    text.setText("Data extraction failed:\n" + t);
                });
            }
        }, "0ad-data-extract").start();
    }

    private void startGame() {
        startActivity(new Intent(this, PyrogenesisActivity.class));
        finish();
    }

    private void extract(File root, File marker) throws Exception {
        File data = new File(root, "data");
        data.mkdirs();
        try (InputStream raw = getAssets().open("0ad-data.zip");
             ZipInputStream zin = new ZipInputStream(new BufferedInputStream(raw, 1 << 20))) {
            byte[] buf = new byte[1 << 20];
            ZipEntry entry;
            int count = 0;
            while ((entry = zin.getNextEntry()) != null) {
                String name = entry.getName();
                if (name.contains("..")) {
                    continue;
                }
                File out = new File(data, name);
                if (entry.isDirectory()) {
                    out.mkdirs();
                    continue;
                }
                File parent = out.getParentFile();
                if (parent != null) parent.mkdirs();
                try (BufferedOutputStream fos = new BufferedOutputStream(new FileOutputStream(out), 1 << 20)) {
                    int n;
                    while ((n = zin.read(buf)) > 0) {
                        fos.write(buf, 0, n);
                    }
                }
                if ((++count % 2000) == 0) {
                    Log.i(TAG, "extracted " + count + " files");
                }
            }
        }
        FileOutputStream fos = new FileOutputStream(marker);
        fos.write("ok\n".getBytes());
        fos.close();
        Log.i(TAG, "data extraction complete");
    }
}
