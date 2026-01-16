#include "qcircleprogressbar.h"
#include <QPainter>
#include <QBitmap>
#include <QPainterPath>
void QCircleProgressBar::paintEvent ( QPaintEvent *e)
{
    QPainter p(this);

    int d = qMin(width(), height());
    QRect r((rect().width() - d) /2, (rect().height() - d) /2, d, d);

    if (m_pic)
    {
        QPainterPath path;
        path.addEllipse(r);
        p.setClipPath(path);
        p.drawPixmap(r, m_pic->scaled(d, d,Qt::KeepAspectRatio,Qt::SmoothTransformation));
    }
    p.setPen(Qt::NoPen);
    double fraction =  static_cast<double>((value() - minimum())) / (maximum() - minimum());


    QColor clr1(Qt::gray);
    clr1 = clr1.darker();
    clr1.setAlpha(50);

    p.setBrush(clr1);
    int startAngle,endAngle;
    if (!invertedAppearance())
    {
        fraction = 1 - fraction;
        startAngle = 16 * 90;
        endAngle = 16 * 360 * fraction;
    }
    else
    {
        startAngle = 16 * 90 + 16 * 360 * fraction;
        if (startAngle > 16 * 360)
            startAngle -= 16 * 360;
        endAngle = 16 * 360 * (1 - fraction);
    }

    p.drawPie(rect(),startAngle,endAngle);

    if (isTextVisible())
    {
        p.setPen(Qt::black);
        p.drawText(r, Qt::AlignHCenter | Qt::AlignVCenter, text());
    }
}
