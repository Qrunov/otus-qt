#include "qnetworkjsonrequest.h"

void QNetworkJsonRequest::processStringAsync(const QString &request) {
    QUrl url(request);
    QNetworkRequest req(url);
    req.setTransferTimeout(10000);

    QNetworkReply* reply = netMan.get(req);
    QByteArray buffer;

    // Чтение чанками
    QObject::connect(reply, &QNetworkReply::readyRead, [&]() {
        buffer.append(reply->readAll());
        qDebug() << "Chunk:" << buffer.size();
    });

    // Завершение
    QObject::connect(reply, &QNetworkReply::finished, [this, &buffer, reply]() {
        // Всегда читаем остаток
        buffer.append(reply->readAll());

        if (reply->error() == QNetworkReply::NoError) {
            QString result = QString::fromUtf8(buffer);
            emit processingFinished(result);
        } else {
            qDebug() << "Error:" << reply->errorString();
            emit processingFinished("");
        }

        reply->deleteLater();
    });
}
