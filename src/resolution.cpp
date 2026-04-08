#include "resolution.h"
#include <QDebug>

#include <QDBusConnection>
#include <QDBusInterface>
#include <QDBusReply>

namespace {
const QString DBUS_SERVICE = QStringLiteral("ru.omp.deviceinfo");
const QString DBUS_PATH = QStringLiteral("/ru/omp/deviceinfo/Features");
const QString DBUS_IFACE = QStringLiteral("ru.omp.deviceinfo.Features");
}


QString resoluton::getResolution()
{
    QDBusInterface* m_iface = new QDBusInterface(DBUS_SERVICE, DBUS_PATH, DBUS_IFACE, QDBusConnection::systemBus());
    if (!m_iface->isValid()) {
        delete m_iface;
        // before Aurora OS 4.1.0:
        m_iface = new QDBusInterface(DBUS_SERVICE, DBUS_PATH, DBUS_IFACE,
                                     QDBusConnection::sessionBus());
    }
    if (!m_iface->isValid()) {
        qDebug() << "FAILED FAILED FAILED" ;
        delete m_iface;
        return "unknown";
    }
    QDBusReply<QString> res = m_iface -> call("getScreenResolution");
    if (res.isValid()) {
        qDebug() << "Resolution:" << res.value();
        return res.value();
    } else {
        qDebug() << "Error getting screen resolution:" << m_iface -> lastError().message();
    }
    qDebug() << "OK OK OK OK OK OK OK OK OK OK OK OK OK OK OK OK OK OK OK OK OK OK OK OK ";
    delete m_iface;
    return "unknown";

}
