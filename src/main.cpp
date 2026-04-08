#include <QtQuick>
#include <auroraapp.h>
#include <src/resolution.h>
int main(int argc, char *argv[])
{
    QScopedPointer<QGuiApplication> application(Aurora::Application::application(argc, argv));
    application->setOrganizationName(QStringLiteral("ru.template"));
    application->setApplicationName(QStringLiteral("dbus"));

    qmlRegisterType<resoluton>("ru.template.resolution", 1, 0, "Resolution");
    QScopedPointer<QQuickView> view(Aurora::Application::createView());
    view->setSource(Aurora::Application::pathTo(QStringLiteral("qml/dbus.qml")));
    view->show();


    return application->exec();
}
