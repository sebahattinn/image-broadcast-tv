# 🖼️ Image Broadcast TV - Discussion Prompts

## 🚀 **Kurulum ve Çalıştırma Talimatları**

### **Ön Gereksinimler**
- .NET 8 SDK
- Flutter SDK (3.0+)
- Android Studio
- SQL Server (LocalDB veya Express)
- Git

### **Adım 1: Projeyi İndirin**
```bash
git clone https://github.com/sebahattinn/ImageBroadcastTV.git
cd ImageBroadcastTV
```

### **Adım 2: API (.NET Backend) Kurulumu**
```bash
cd ImageBroadcastApi
dotnet restore
```

**Veritabanı Bağlantısını Ayarlayın:**
- `appsettings.json` dosyasını açın
- `DefaultConnection` kısmını güncelleyin:
```json
"ConnectionStrings": {
  "DefaultConnection": "Server=(localdb)\\MSSQLLocalDB;Database=BroadcastDb;Trusted_Connection=True;"
}
```

**Veritabanını Oluşturun:**
```bash
dotnet ef migrations add InitialCreate
dotnet ef database update
dotnet run
```
API şu adreste çalışacak: `http://localhost:5125`

### **Adım 3: Flutter Mobil Uygulama Kurulumu**
```bash
cd ../image_broadcast_app
flutter pub get
```

**IP Adresini Ayarlayın:**
- `lib/services/image_service.dart` dosyasını açın
- Base URL'i güncelleyin:
```dart
static const String baseUrl = "http://192.168.x.x:5125/api/images";
```
- Emülatör için: `10.0.2.2`
- Gerçek cihaz için: Bilgisayarınızın IP adresi

**Uygulamayı Çalıştırın:**
```bash
flutter run
```

### **Adım 4: Android TV Uygulaması Kurulumu**
1. Android Studio'yu açın
2. `ImageBroadcastTV` klasörünü açın
3. `MainActivity.kt` dosyasında IP adresini güncelleyin:
```kotlin
private val serverIp = "192.168.x.x"
```
4. Android TV cihazına veya emülatöre yükleyin

### **Test Etmek İçin:**
1. API'nin çalıştığını kontrol edin: `http://localhost:5125/api/images/active`
2. Flutter uygulamasından görsel yükleyin
3. TV ekranında görselin görüntülendiğini kontrol edin

---

## 🎯 **Project Overview & Vision**
1. What problem does this Image Broadcast TV system solve that existing solutions don't address?
2. How do you envision pharmacies and stores using this system in their daily operations?
3. What makes the 10-second refresh rate optimal for this use case?
4. How might this system evolve beyond static image broadcasting?

## 🏗️ **Technical Architecture**
5. What influenced the decision to use Flutter for mobile, .NET for API, and Kotlin for TV?
6. How does the system handle multiple users trying to broadcast simultaneously?
7. What are the potential scalability challenges with the current architecture?
8. How would you implement user permissions or content moderation?

## 📱 **User Experience & Design**
9. What's the typical user journey from opening the app to seeing content on TV?
10. How intuitive is the upload and broadcast process for non-technical users?
11. What feedback mechanisms exist for users to know their content is live?
12. How would you handle poor network conditions or upload failures?

## 🔧 **Implementation & Deployment**
13. What were the biggest technical challenges during development?
14. How do you handle IP address configuration for different network environments?
15. What testing strategies would you recommend for this multi-platform system?
16. How would you approach setting up this system in a real pharmacy or store?

## 📊 **Business & Use Cases**
17. What metrics would you track to measure the system's success?
18. How could this system generate revenue or provide ROI for businesses?
19. What additional features would make this more valuable for retail environments?
20. How might this integrate with existing POS or inventory systems?

## 🛡️ **Security & Reliability**
21. What security measures protect against inappropriate content being broadcast?
22. How does the system handle database failures or API downtime?
23. What backup or recovery mechanisms exist for critical broadcasts?
24. How would you prevent unauthorized access to broadcast controls?

## 🚀 **Future Development**
25. What would version 2.0 of this system include?
26. How could AI/ML enhance the content management or display experience?
27. What other platforms (web, desktop) might be valuable to support?
28. How might this system integrate with social media or content management platforms?

## 🤝 **Collaboration & Feedback**
29. What aspects of the project are you most proud of?
30. Where do you see the biggest opportunities for improvement?
31. What would you do differently if starting this project today?
32. How can contributors best help advance this project?

---

## 💡 **Quick Discussion Starters**
- **For Technical Teams**: "Let's dive into the API architecture - how does the broadcast state management work?"
- **For Business Stakeholders**: "What's the ROI timeline for a pharmacy implementing this system?"
- **For Users**: "Walk me through uploading your first image - what feels intuitive or confusing?"
- **For Contributors**: "What's the most impactful feature we could add with minimal complexity?"
