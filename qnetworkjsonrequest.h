#ifndef QNETWORKJSONREQUEST_H
#define QNETWORKJSONREQUEST_H

#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QTimer>
#include <QEventLoop>
#include <unistd.h>


class QNetworkJsonRequest : public QObject
{
    Q_OBJECT
public:
    explicit QNetworkJsonRequest(QObject *parent = nullptr) : QObject(parent) {}
    QNetworkAccessManager netMan;

signals:
    void processingFinished(const QString result);

public slots:

    void processStringAsync(const QString &request);

};


#endif // QNETWORKJSONREQUEST_H
