package com.example.flutter_download_media

import android.content.ContentResolver
import android.content.ContentUris
import android.content.ContentValues
import android.net.Uri
import android.os.Build
import android.provider.CalendarContract.Attendees.query
import android.provider.CalendarContract.EventDays.query
import android.provider.CalendarContract.Reminders.query
import android.provider.MediaStore
import android.provider.MediaStore.Video.query
import androidx.annotation.NonNull
import androidx.core.content.ContentResolverCompat.query
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.OutputStream
import java.util.concurrent.TimeUnit


class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.code4func/method1").setMethodCallHandler {
            call, result ->
            if (call.method.equals("getDeviceInfoString")) {
                data class Video(val uri: Uri,
                                 val name: String,
                                 val duration: Int,
                                 val size: Int
                )
                val videoList = mutableListOf<Video>()

                val collection =
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                            MediaStore.Video.Media.getContentUri(
                                    MediaStore.VOLUME_EXTERNAL
                            )
                        } else {
                            MediaStore.Video.Media.EXTERNAL_CONTENT_URI
                        }

                val projection = arrayOf(
                        MediaStore.Video.Media._ID,
                        MediaStore.Video.Media.DISPLAY_NAME,
                        MediaStore.Video.Media.DURATION,
                        MediaStore.Video.Media.SIZE
                )

// Show only videos that are at least 5 minutes in duration.
                val selection = "${MediaStore.Video.Media.DURATION} >= ?"
                val selectionArgs = arrayOf(
                        TimeUnit.MILLISECONDS.convert(5, TimeUnit.MINUTES).toString()
                )

// Display videos in alphabetical order based on their display name.
                val sortOrder = "${MediaStore.Video.Media.DISPLAY_NAME} ASC"

                val query = applicationContext.contentResolver.query(
                        collection,
                        projection,
                        selection,
                        selectionArgs,
                        sortOrder
                )
                query.use { cursor ->
                    // Cache column indices.
                    val idColumn = cursor?.getColumnIndexOrThrow(MediaStore.Video.Media._ID)
                    val nameColumn =
                            cursor?.getColumnIndexOrThrow(MediaStore.Video.Media.DISPLAY_NAME)
                    val durationColumn =
                            cursor?.getColumnIndexOrThrow(MediaStore.Video.Media.DURATION)
                    val sizeColumn = cursor?.getColumnIndexOrThrow(MediaStore.Video.Media.SIZE)

                    while (cursor!!.moveToNext()) {
                        // Get values of columns for a given video.
                        val id = cursor.getLong(idColumn!!)
                        val name = cursor.getString(nameColumn!!)
                        val duration = cursor.getInt(durationColumn!!)
                        val size = cursor.getInt(sizeColumn!!)

                        val contentUri: Uri = ContentUris.withAppendedId(
                                MediaStore.Video.Media.EXTERNAL_CONTENT_URI,
                                id
                        )

                        // Stores column values and the contentUri in a local object
                        // that represents the media file.
                        videoList += Video(contentUri, name, duration, size)
                    }
                }


            }
            // Note: this method is invoked on the main thread.
            // TODO
        }



    }

}

