#include "qpricedelegate.h"
#include <QPainter>


QPriceDelegate::QPriceDelegate() {}

void QPriceDelegate::paint(QPainter *painter, const QStyleOptionViewItem &option, const QModelIndex &index) const
{
    painter-> save();
    double change = index.data(Qt::UserRole + 1).toDouble();

    if (0 != change)
    {
        if (change > 0)
            painter ->setBrush(QBrush(QColor(Qt::green).darker(100 + change * 10)));
        else if (change < 0)
            painter ->setBrush(QBrush(QColor(Qt::red).darker(100 - change * 10)));

        painter ->drawRect(option.rect);

        painter ->drawText(option.rect, Qt::AlignLeft | Qt::AlignVCenter,index.data().toString());

        QFont font =  painter -> font();
        font.setPointSize(6);
        font.setWeight(QFont::Bold);
        painter->setFont(font);
        painter ->drawText(option.rect, Qt::AlignRight | Qt::AlignBottom,QString::number(change, 'f', 1) + QString("%"));
    }
    else
        painter ->drawText(option.rect, Qt::AlignLeft | Qt::AlignVCenter,index.data().toString());

    painter-> restore();
}

QSize QPriceDelegate::sizeHint(const QStyleOptionViewItem &option, const QModelIndex &index) const
{
    return QSize(20, 100);
}
