TARGET = ru.template.dbus

CONFIG += \
    auroraapp
QT += dbus

PKGCONFIG += \

SOURCES += \
    src/main.cpp \
    src/resolution.cpp

DISTFILES += \
    rpm/ru.template.dbus.spec \

AURORAAPP_ICONS = 86x86 108x108 128x128 172x172

CONFIG += auroraapp_i18n

TRANSLATIONS += \
    translations/ru.template.dbus.ts \
    translations/ru.template.dbus-ru.ts \

HEADERS += \
    src/resolution.h
