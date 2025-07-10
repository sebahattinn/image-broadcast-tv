package com.example.imagebroadcasttv

import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.widget.ImageView
import androidx.appcompat.app.AppCompatActivity
import com.squareup.picasso.Picasso
import okhttp3.OkHttpClient
import okhttp3.Request
import org.json.JSONObject

class MainActivity : AppCompatActivity() {

    private lateinit var imageView: ImageView
    private val handler = Handler(Looper.getMainLooper())

    private val serverIp = "192.168.0.110"
    private val apiUrl = "http://$serverIp:5125/api/images/broadcasted"
    private val refreshInterval = 10_000L // 10 saniye

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        imageView = ImageView(this).apply {
            scaleType = ImageView.ScaleType.FIT_CENTER
        }

        setContentView(imageView)
        fetchAndDisplayImage()
    }

    private fun fetchAndDisplayImage() {
        handler.post(object : Runnable {
            override fun run() {
                Thread {
                    try {
                        val client = OkHttpClient()
                        val request = Request.Builder().url(apiUrl).build()
                        val response = client.newCall(request).execute()

                        if (response.isSuccessful) {
                            val body = response.body?.string()
                            Log.d("ImageBroadcast", "✅ JSON Body: $body")

                            val json = JSONObject(body ?: "")
                            val imageUrl = "http://$serverIp:5125" + json.getString("filePath")
                            Log.d("ImageBroadcast", "📷 Yüklenecek görsel URL: $imageUrl")

                            runOnUiThread {
                                Picasso.get()
                                    .load(imageUrl)
                                    .error(android.R.drawable.stat_notify_error)
                                    .into(imageView, object : com.squareup.picasso.Callback {
                                        override fun onSuccess() {
                                            Log.d("ImageBroadcast", "✅ Picasso ile görsel yüklendi")
                                        }

                                        override fun onError(e: Exception?) {
                                            Log.e("ImageBroadcast", "❌ Picasso görsel yüklemede hata", e)
                                        }
                                    })
                            }
                        } else {
                            Log.e("ImageBroadcast", "❌ Sunucu başarısız cevap verdi: ${response.code}")
                        }
                    } catch (e: Exception) {
                        Log.e("ImageBroadcast", "❌ HATA oluştu", e)
                    }
                }.start()

                handler.postDelayed(this, refreshInterval)
            }
        })
    }
}
