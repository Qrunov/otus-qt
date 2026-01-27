#ifndef QPRICEDELEGATE_H
#define QPRICEDELEGATE_H

#include <QAbstractItemDelegate>
#include <QObject>

class QPriceDelegate : public QAbstractItemDelegate
{
    Q_OBJECT
public:
    QPriceDelegate();

    // QAbstractItemDelegate interface
public:
    void paint(QPainter *painter, const QStyleOptionViewItem &option, const QModelIndex &index) const;
    QSize sizeHint(const QStyleOptionViewItem &option, const QModelIndex &index) const;
};

#endif // QPRICEDELEGATE_H
