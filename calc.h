#ifndef CALC_H
#define CALC_H

#include <QDialog>
#include  <QMap>
#include <functional>

QT_BEGIN_NAMESPACE
namespace Ui {
class Calc;
}
QT_END_NAMESPACE


using longType = qulonglong;

class Calc : public QDialog
{
    Q_OBJECT
    enum    class operation {NOP,OR,AND,XOR,NOT};



public:
    Calc(QWidget *parent = nullptr);
    ~Calc();

    void    doOperation();


public slots:
    void    onDigit();



private:
    Ui::Calc    *ui;
    operation       m_op{operation::NOP};
    longType   m_prev{0};


    QMap<operation,std::function<qlonglong(longType, longType)>> m_opMap;
};
#endif // CALC_H
