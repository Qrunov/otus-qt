#ifndef QCIRCLEPROGRESSBAR_H
#define QCIRCLEPROGRESSBAR_H

#include <QProgressBar>

class QPixmap;

class QCircleProgressBar : public QProgressBar
{
    Q_OBJECT
public:
    QCircleProgressBar ( QWidget * parent = 0 ):
        QProgressBar(parent)    {}
    void setPixmap(QString path)
    {
        m_pic = QSharedPointer<QPixmap>(new QPixmap(path));
    }
protected:
    void paintEvent ( QPaintEvent * );
private:
    QSharedPointer<QPixmap>    m_pic;
};

#endif // QCIRCLEPROGRESSBAR_H
