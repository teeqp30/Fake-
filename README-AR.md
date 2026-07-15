# 📍 أداة تزييف الموقع الجغرافي - Location Spoofer

حزمة DEB لتزييف إحداثيات GPS على أجهزة iOS والأنظمة الأخرى.

## 🎯 الميزات

✨ **الميزات الرئيسية:**
- ✅ تزييف إحداثيات GPS (خط العرض والطول)
- ✅ حفظ مواقع مفضلة
- ✅ تشفير البيانات المخزنة
- ✅ واجهة سطر أوامر سهلة الاستخدام
- ✅ دعم النصوص العربية
- ✅ تفعيل/تعطيل سريع

## 📥 التثبيت

### المتطلبات

```bash
# على Linux/Debian
sudo apt-get install dpkg fakeroot

# على macOS
brew install dpkg
```

### خطوات التثبيت

```bash
# 1. تحميل الملفات
git clone https://github.com/teeqp30/Fake-.git
cd Fake-
git checkout deb-package

# 2. بناء الحزمة
fakeroot dpkg-deb -b . location-spoofer_1.0.0_iphoneos-arm.deb

# 3. التثبيت
sudo dpkg -i location-spoofer_1.0.0_iphoneos-arm.deb

# 4. التحقق
location-spoofer status
```

## 🚀 الاستخدام

### أوامر أساسية

```bash
# تفعيل التزييف
location-spoofer enable

# تعطيل التزييف
location-spoofer disable

# تعيين موقع محدد
location-spoofer set-location 25.2048 55.2708

# عرض الموقع الحالي
location-spoofer get-location

# عرض حالة الأداة
location-spoofer status

# عرض المساعدة
location-spoofer help
```

### أمثلة عملية

```bash
# تعيين موقع دبي
location-spoofer set-location 25.2048 55.2708

# تعيين موقع لندن
location-spoofer set-location 51.5074 -0.1278

# تعيين موقع طوكيو
location-spoofer set-location 35.6762 139.6503

# تعيين خط العرض فقط
location-spoofer set-lat 40.7128

# تعيين خط الطول فقط
location-spoofer set-lon -74.0060
```

## 📊 معلومات الحزمة

| البيان | القيمة |
|------|--------|
| الاسم | location-spoofer |
| الإصدار | 1.0.0 |
| المعمارية | iphoneos-arm |
| الحجم | ~1 MB |
| النوع | Tweak/أداة |
| الترخيص | MIT |
| المطور | تطوير التطبيقات |

## 📁 هيكل الملفات

```
location-spoofer/
├── DEBIAN/                          # ملفات الحزمة
│   ├── control                      # البيانات الوصفية
│   ├── postinst                     # سكريبت التثبيت
│   ├── prerm                        # سكريبت الإزالة
│   └── md5sums                      # تجزئات التحقق
│
├── opt/location-spoofer/            # الملفات الرئيسية
│   └── spoofer.m                    # الكود الأساسي (Method Swizzling)
│
├── usr/local/bin/                   # أدوات سطر الأوامر
│   └── location-spoofer.sh          # واجهة CLI
│
├── var/mobile/Library/LocationSpoofer/  # مجلد البيانات
│
├── BUILD.md                         # دليل البناء
└── README-AR.md                     # هذا الملف
```

## 🔧 التكوين

### ملف الإعدادات

يتم تخزين الإعدادات في:
```
/var/mobile/Library/Preferences/com.locationspoofer.plist
```

### الإعدادات الافتراضية

```xml
<?xml version="1.0" encoding="UTF-8"?>
<plist version="1.0">
<dict>
    <key>SpoofEnabled</key>
    <false/>
    <key>LastUpdated</key>
    <date>2026-07-15T00:00:00Z</date>
    <key>SavedLatitude</key>
    <real>25.2048</real>
    <key>SavedLongitude</key>
    <real>55.2708</real>
</dict>
</plist>
```

## 🔐 الأمان والخصوصية

### إجراءات الأمان

🔒 **الحماية:**
- تشفير البيانات المخزنة
- عزل البيانات عن تطبيقات أخرى
- حذف البيانات عند الإزالة
- سجلات آمنة

### ملاحظات مهمة

⚠️ **تحذيرات:**
- مخصصة للاختبار والتطوير فقط
- قد تنتهك سياسات متاجر التطبيقات
- استخدمها على مسؤوليتك الخاصة
- لا تستخدمها للأغراض غير القانونية

## 🐛 استكشاف الأخطاء

### المشكلة: الأداة لا تعمل بعد التثبيت

```bash
# التحقق من التثبيت
dpkg -l | grep location-spoofer

# عرض معلومات التثبيت
dpkg -s location-spoofer

# عرض السجلات
dpkg --configure location-spoofer
```

### المشكلة: الموقع لا ينعكس على التطبيقات

```bash
# إعادة تشغيل الخدمات
killall -9 locationd

# التحقق من الإعدادات
cat /var/mobile/Library/Preferences/com.locationspoofer.plist

# تفعيل الأداة مرة أخرى
location-spoofer enable
```

### المشكلة: خطأ في القيم المدخلة

```bash
# التحقق من صيغة الأرقام
# خط العرض: -90 إلى 90
# خط الطول: -180 إلى 180

location-spoofer set-location 25.2048 55.2708  # صحيح
location-spoofer set-location 125.2048 55.2708 # خطأ (العرض أكبر من 90)
```

## 📚 الموارد الإضافية

- [دليل البناء](BUILD.md)
- [معايير إحداثيات GPS](https://en.wikipedia.org/wiki/Decimal_degrees)
- [قائمة المدن والإحداثيات](https://www.latlong.net/)

## 🤝 المساهمة

نرحب بالمساهمات! يرجى:
1. عمل Fork للمشروع
2. إنشاء فرع للميزة الجديدة
3. تقديم Pull Request

## 📝 التاريخ والإصدارات

### الإصدار 1.0.0 (2026-07-15)
- ✅ الإصدار الأول
- ✅ دعم تزييف الإحداثيات الأساسي
- ✅ واجهة سطر الأوامر
- ✅ دعم العربية

## 📞 التواصل والدعم

- **المشاكل والأخطاء**: [GitHub Issues](https://github.com/teeqp30/Fake-/issues)
- **المقترحات**: [GitHub Discussions](https://github.com/teeqp30/Fake-/discussions)

## ⚖️ الترخيص

هذا المشروع مرخص تحت رخصة MIT. انظر [LICENSE](LICENSE) للتفاصيل.

---

**ملخص الكود:**

يستخدم هذا المشروع تقنية **Method Swizzling** في Objective-C لاستبدال دالة `coordinate` الأصلية في فئة `CLLocation` بدالة مزيفة تعيد إحداثيات مخزنة بدلاً من الموقع الفعلي.

```objective-c
// آلية العمل:
1. التحقق من تفعيل التزييف
2. جلب الإحداثيات المزيفة من NSUserDefaults
3. التحقق من صحة الإحداثيات
4. إرجاع الموقع المزيف أو الموقع الحقيقي
```

---

**تم الإنشاء بواسطة**: GitHub Copilot  
**التاريخ**: 2026-07-15  
**الحالة**: ✅ نشط
