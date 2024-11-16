package com.serchservice.user

import io.flutter.embedding.android.FlutterFragmentActivity
import io.getstream.video.flutter.stream_video_flutter.service.PictureInPictureHelper

class MainActivity: FlutterFragmentActivity() {
    override fun onUserLeaveHint() {
        super.onUserLeaveHint()
        PictureInPictureHelper.enterPictureInPictureIfInCall(this)
    }
}
