#ifndef QQMLCIRCLEPROGRESS_H
#define QQMLCIRCLEPROGRESS_H

#include <QQuickPaintedItem>
#include <QColor>
#include <QProgressBar>


class QQmlCircleProgress : public QQuickPaintedItem
{
    Q_OBJECT
public:
    QQmlCircleProgress();

    void setPixmap(QString path)
    {
        m_pic  = QPixmap(path);
    }
public slots:
    void onUpdate();
private:
    QPixmap m_pic;

    // QQuickPaintedItem interface
public:
    void paint(QPainter *painter);
};


#endif // QQMLCIRCLEPROGRESS_H
