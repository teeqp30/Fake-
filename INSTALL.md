# دليل التثبيت - Location Spoofer

## المتطلبات الأساسية

### على Linux/Debian
```bash
sudo apt-get update
sudo apt-get install -y dpkg fakeroot binutils
```

### على Ubuntu
```bash
sudo apt-get update
sudo apt-get install -y dpkg dpkg-dev fakeroot
```

### على macOS
```bash
brew install dpkg
```

## التثبيت من المصدر

### الخطوة 1: استنساخ المستودع
```bash
git clone https://github.com/teeqp30/Fake-.git
cd Fake-
git checkout deb-package
```

### الخطوة 2: إعداد البيئة
```bash
chmod +x setup.sh
./setup.sh
```

### الخطوة 3: بناء الحزمة

#### الطريقة 1: استخدام Makefile
```bash
make build
```

#### الطريقة 2: استخدام سكريبت البناء مباشرة
```bash
chmod +x build.sh
./build.sh
```

#### الطريقة 3: استخدام dpkg-deb مباشرة
```bash
fakeroot dpkg-deb -b . location-spoofer_1.0.0_iphoneos-arm.deb
```

### الخطوة 4: التحقق من الحزمة
```bash
dpkg-deb --info location-spoofer_1.0.0_iphoneos-arm.deb
```

## التثبيت على النظام

### التثبيت العادي
```bash
sudo dpkg -i location-spoofer_1.0.0_iphoneos-arm.deb
```

### التحقق من التثبيت
```bash
dpkg -l | grep location-spoofer
```

### تشغيل الأداة
```bash
location-spoofer status
```

## الإزالة

### إزالة الحزمة
```bash
sudo dpkg -r location-spoofer
```

### تنظيف كامل
```bash
make clean
rm -f location-spoofer_*.deb
```

## استكشاف الأخطاء

### الخطأ: dpkg-deb: command not found
```bash
# التثبيت على Debian/Ubuntu
sudo apt-get install dpkg

# التثبيت على macOS
brew install dpkg
```

### الخطأ: fakeroot: command not found
```bash
# اختياري - يمكن البناء بدونه
# لكن من الأفضل تثبيته:
sudo apt-get install fakeroot
```

### الخطأ: Permission denied
```bash
# تعيين الأذونات
chmod 755 DEBIAN/postinst DEBIAN/prerm
chmod +x build.sh
```

### الخطأ: ملف DEBIAN/control غير موجود
```bash
# تأكد من أنك في الفرع الصحيح
git checkout deb-package

# تحقق من وجود الملفات
ls -la DEBIAN/
```

## الاختبار

### تشغيل مجموعة الاختبارات
```bash
chmod +x test.sh
./test.sh
```

### الاختبار اليدوي
```bash
# التحقق من محتويات الحزمة
dpkg-deb --contents location-spoofer_1.0.0_iphoneos-arm.deb

# التحقق من المعلومات
dpkg-deb --info location-spoofer_1.0.0_iphoneos-arm.deb

# محاكاة التثبيت
sudo dpkg --simulate -i location-spoofer_1.0.0_iphoneos-arm.deb
```

## الخطوات التالية

بعد التثبيت بنجاح:

```bash
# عرض حالة الأداة
location-spoofer status

# عرض المساعدة
location-spoofer help

# تفعيل تزييف الموقع
location-spoofer enable

# تعيين موقع
location-spoofer set-location 25.2048 55.2708
```

## المرجع السريع

| الأمر | الوصف |
|------|-------|
| `make all` | بناء الحزمة |
| `make build` | بناء DEB |
| `make install` | بناء وتثبيت |
| `make uninstall` | إزالة الحزمة |
| `make verify` | التحقق من الحزمة |
| `make test` | اختبار |
| `make help` | عرض المساعدة |

## الدعم

إذا واجهت مشاكل:
1. تحقق من [BUILD.md](BUILD.md)
2. تحقق من [README-AR.md](README-AR.md)
3. ابحث في [GitHub Issues](https://github.com/teeqp30/Fake-/issues)

---

**آخر تحديث**: 2026-07-15
**الإصدار**: 1.0.0
