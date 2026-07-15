# إنشاء حزمة DEB - أداة تزييف الموقع

## 📋 المتطلبات

```bash
# تثبيت الأدوات المطلوبة
apt-get install dpkg-dev fakeroot devscripts build-essential
```

## 🔨 خطوات البناء

### الطريقة 1: استخدام dpkg-deb المباشر

```bash
# 1. استنساخ المشروع
git clone https://github.com/teeqp30/Fake-.git
cd Fake-
git checkout deb-package

# 2. بناء الحزمة
dpkg-deb --build . location-spoofer_1.0.0_iphoneos-arm.deb

# 3. التحقق من الحزمة
dpkg-deb --info location-spoofer_1.0.0_iphoneos-arm.deb
dpkg-deb --contents location-spoofer_1.0.0_iphoneos-arm.deb
```

### الطريقة 2: استخدام fakeroot (الموصى به)

```bash
# بناء آمن دون الحاجة لصلاحيات root
fakeroot dpkg-deb -b . location-spoofer_1.0.0_iphoneos-arm.deb
```

### الطريقة 3: استخدام debuild

```bash
# إعداد بيئة Debian
debuild -us -uc -b

# سيتم إنشاء الحزمة تلقائياً
```

## 📦 هيكل الحزمة

```
location-spoofer/
├── DEBIAN/
│   ├── control          (معلومات الحزمة)
│   ├── postinst         (سكريبت التثبيت)
│   ├── prerm            (سكريبت الإزالة)
│   └── md5sums          (تجزئات التحقق)
├── opt/location-spoofer/
│   └── spoofer.m        (الكود الأساسي)
├── usr/local/bin/
│   └── location-spoofer.sh  (أداة سطر الأوامر)
└── var/mobile/Library/
    └── LocationSpoofer/ (مجلد البيانات)
```

## ✅ التحقق من الحزمة

```bash
# عرض معلومات الحزمة
dpkg-deb --info location-spoofer_1.0.0_iphoneos-arm.deb

# عرض محتويات الحزمة
dpkg-deb --contents location-spoofer_1.0.0_iphoneos-arm.deb

# فحص التبعيات
dpkg-deb -I location-spoofer_1.0.0_iphoneos-arm.deb depends

# التحقق من البيانات الوصفية
ar x location-spoofer_1.0.0_iphoneos-arm.deb
tar tzf control.tar.gz | head -20
```

## 🚀 التثبيت والاختبار

### على جهاز Linux/Debian

```bash
# التثبيت
sudo dpkg -i location-spoofer_1.0.0_iphoneos-arm.deb

# التحقق من التثبيت
dpkg -l | grep location-spoofer

# تشغيل الأداة
location-spoofer status

# الإزالة
sudo dpkg -r location-spoofer
```

### على جهاز iOS (Jailbreak)

```bash
# نقل الحزمة إلى الجهاز
scp location-spoofer_1.0.0_iphoneos-arm.deb root@<IP>:/tmp/

# الاتصال بالجهاز والتثبيت
ssh root@<IP>
dpkg -i /tmp/location-spoofer_1.0.0_iphoneos-arm.deb
```

## 🐛 استكشاف الأخطاء

### الخطأ: "no such file or directory"

```bash
# تأكد من وجود جميع الملفات
ls -la DEBIAN/
ls -la opt/
ls -la usr/

# تحقق من الأذونات
chmod 755 DEBIAN/postinst
chmod 755 DEBIAN/prerm
chmod 755 usr/local/bin/location-spoofer.sh
```

### الخطأ: "ar: command not found"

```bash
# تثبيت binutils
apt-get install binutils
```

### فحص ملفات md5sums

```bash
# توليد ملف md5sums
find . -type f ! -path './DEBIAN/*' -exec md5sum {} \; > DEBIAN/md5sums.new
mv DEBIAN/md5sums.new DEBIAN/md5sums
```

## 📊 معلومات الحزمة

- **الحزمة**: location-spoofer
- **الإصدار**: 1.0.0
- **المعمارية**: iphoneos-arm (iOS)
- **الحجم**: ~1 MB
- **التبعيات**: firmware >= 12.0

## 🔐 التوقيع الرقمي

```bash
# إنشاء مفتاح GPG (إذا لم يكن موجوداً)
gpg --gen-key

# توقيع الحزمة
dpkg-sig --sign builder location-spoofer_1.0.0_iphoneos-arm.deb

# التحقق من التوقيع
dpkg-sig --verify location-spoofer_1.0.0_iphoneos-arm.deb
```

## 📝 ملاحظات مهمة

⚠️ **تحذيرات أمنية:**
- هذه الحزمة مخصصة فقط للاختبار والتطوير
- لا تستخدمها مع تطبيقات الإنتاج
- قد تنتهك سياسات متاجر التطبيقات
- استخدمها على مسؤوليتك الخاصة

✅ **نصائح:**
- احتفظ بنسخة احتياطية من بيانات الموقع الأصلية
- اختبر على جهاز افتراضي أولاً
- راقب السجلات بحثاً عن أخطاء

---

**تم الإنشاء بواسطة**: Copilot
**التاريخ**: 2026-07-15
**الترخيص**: MIT
