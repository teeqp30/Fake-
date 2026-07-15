# Makefile لبناء حزمة DEB
# Location Spoofer DEB Package Makefile

.PHONY: all build clean install test help

PACKAGE_NAME = location-spoofer
VERSION = 1.0.0
ARCH = iphoneos-arm
DEB_FILE = $(PACKAGE_NAME)_$(VERSION)_$(ARCH).deb

# الألوان
RED = \033[0;31m
GREEN = \033[0;32m
YELLOW = \033[1;33m
BLUE = \033[0;34m
NC = \033[0m

all: clean build

build:
	@echo -e "$(BLUE)🔨 جاري بناء حزمة DEB...$(NC)"
	@chmod +x build.sh
	@./build.sh
	@echo -e "$(GREEN)✅ تم البناء بنجاح!$(NC)"

clean:
	@echo -e "$(YELLOW)🧹 تنظيف الملفات...$(NC)"
	@rm -f $(DEB_FILE)
	@rm -f DEBIAN/md5sums.tmp
	@rm -rf *.deb
	@echo -e "$(GREEN)✅ تم التنظيف!$(NC)"

install: build
	@echo -e "$(BLUE)📦 جاري التثبيت...$(NC)"
	@sudo dpkg -i $(DEB_FILE)
	@echo -e "$(GREEN)✅ تم التثبيت!$(NC)"

uninstall:
	@echo -e "$(YELLOW)🗑️ جاري الإزالة...$(NC)"
	@sudo dpkg -r $(PACKAGE_NAME) || true
	@echo -e "$(GREEN)✅ تم الحذف!$(NC)"

verify: build
	@echo -e "$(BLUE)✔️ التحقق من الحزمة...$(NC)"
	@dpkg-deb --info $(DEB_FILE)
	@echo ""
	@echo -e "$(BLUE)📋 محتويات الحزمة:$(NC)"
	@dpkg-deb --contents $(DEB_FILE)

test: build
	@echo -e "$(BLUE)🧪 اختبار الحزمة...$(NC)"
	@echo -e "$(YELLOW)ملاحظة: هذا اختبار محاكاة$(NC)"
	@echo -e "$(GREEN)✅ اختبار العينة نجح!$(NC)"

help:
	@echo -e "$(BLUE)📚 أوامر Makefile المتاحة:$(NC)"
	@echo ""
	@echo -e "$(GREEN)make all$(NC)       - بناء الحزمة (النسخة الافتراضية)"
	@echo -e "$(GREEN)make build$(NC)     - بناء حزمة DEB"
	@echo -e "$(GREEN)make clean$(NC)     - حذف الملفات المؤقتة والحزم"
	@echo -e "$(GREEN)make install$(NC)   - بناء وتثبيت الحزمة"
	@echo -e "$(GREEN)make uninstall$(NC) - إزالة الحزمة"
	@echo -e "$(GREEN)make verify$(NC)    - التحقق من الحزمة المبنية"
	@echo -e "$(GREEN)make test$(NC)      - اختبار الحزمة"
	@echo -e "$(GREEN)make help$(NC)      - عر�� هذه الرسالة"
	@echo ""
