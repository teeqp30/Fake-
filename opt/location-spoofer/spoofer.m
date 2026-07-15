/**
 * الدالة المزيفة التي تحل محل دالة coordinate الأصلية في كلاس CLLocation
 * تعيد هيكل CLLocationCoordinate2D يحتوي على خط الطول والعرض
 */
- (CLLocationCoordinate2D)zsp_coordinate {
    
    // 1. التحقق أولاً ما إذا كان خيار تزييف الموقع مفعلاً من قبل المستخدم
    // يتم استدعاء دالة داخلية ZIsSpoofEnabled() التي تقرأ من ملف الإعدادات
    if (ZIsSpoofEnabled()) {
        
        // 2. جلب الإحداثيات المزيفة المخزنة في NSUserDefaults
        // يتم استخدام مفاتيح مشفرة يتم فكها وقت التشغيل (مثل "saved_lat" و "saved_lon")
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        double fakeLatitude = [defaults doubleForKey:@"zsp_lat"];
        double fakeLongitude = [defaults doubleForKey:@"zsp_lon"];
        
        // 3. بناء الهيكل الجغرافي بالقيم المزيفة
        CLLocationCoordinate2D fakeLocation = CLLocationCoordinate2DMake(fakeLatitude, fakeLongitude);
        
        // 4. التحقق من أن القيم المزيفة صالحة (ليست صفراً أو غير منطقية)
        if (CLLocationCoordinate2DIsValid(fakeLocation)) {
            return fakeLocation; // إرجاع الموقع المزيف للتطبيق
        }
    }
    
    // 5. في حال كان التزييف معطلاً أو القيم غير صالحة:
    // يتم استدعاء "نفس الدالة" ولكن بسبب عملية الـ Swizzling، 
    // هذا الاستدعاء سيوجهنا فعلياً إلى الدالة الأصلية في النظام (Original Implementation)
    return [self zsp_coordinate]; 
}
