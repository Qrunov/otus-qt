#ifndef RESOLUTION_H
#define RESOLUTION_H

#include <QObject>

class resoluton: public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString resolution READ getResolution())
public:
    // Методы, доступные в QML
    Q_INVOKABLE QString getResolution();

};

#endif // RESOLUTION_H
