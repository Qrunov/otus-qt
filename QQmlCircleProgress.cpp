#include "QQmlCircleProgress.h"
#include <QPainter>
#include <QProgressBar>
#include <QPainterPath>
#include <QPixmap>

void QQmlCircleProgress::onUpdate()
{
    update();
}


QQmlCircleProgress::QQmlCircleProgress() {
    connect(this, SIGNAL(valueChanged()), this, SLOT(update()));
}

void QQmlCircleProgress::paint(QPainter *painter)
{

    if (!m_pic)
        m_pic = QPixmap(":/Qt_logo_2016.png");


    int d = qMin(width(), height());
    QRect r((width() - d) /2, (height() - d) /2, d, d);

    painter ->setPen(Qt::NoPen);
    painter ->save();
    if (!m_pic.isNull())
    {
        QPainterPath path;
        path.addEllipse(r);
        painter -> setClipPath(path);
        painter ->drawPixmap(r, m_pic.scaled(d, d,Qt::KeepAspectRatio,Qt::SmoothTransformation));
    }

    double value = property("value").toDouble();
    double from = property("from").toDouble();
    double to = property("to").toDouble();

    QColor clr1(Qt::gray);
    clr1 = clr1.darker();
    clr1.setAlpha(50);
    double fraction =  static_cast<double>(value - from) / (to - from);

    painter -> setBrush(clr1);
    int startAngle,endAngle;
    fraction = 1 - fraction;
    startAngle = 16 * 90;
    endAngle = 16 * 360 * fraction;


    painter -> drawPie(x(), y(), x() + width(), y() + height(),startAngle,endAngle);

    painter ->restore();
}
