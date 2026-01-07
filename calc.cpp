#include <QRegularExpression>
#include "calc.h"
#include "ui_calc.h"

Calc::Calc(QWidget *parent)
    : QDialog(parent)
    , ui(new Ui::Calc)
{
    ui->setupUi(this);

    m_opMap[operation::AND] = [](auto op1, auto op2) {return op1 & op2;};
    m_opMap[operation::OR] = [](auto op1, auto op2) {return op1 | op2;};
    m_opMap[operation::XOR] = [](auto op1, auto op2) {return op1 ^ op2;};

    auto buttons = findChildren<QPushButton *>(QRegularExpression(R"(pb\d)"));

    for(auto e: buttons)
        connect(e,SIGNAL(clicked()),this,SLOT(onDigit()));

    connect(ui->pbClear,&QPushButton::clicked,this,[this]()
            {
                ui ->output->clear();
            }
            );


    connect(ui->pbEq, &QPushButton::clicked, this, [this]() {doOperation();});

    connect(ui->pbNOT, &QPushButton::clicked, this, [this]() {m_op = operation::NOT; doOperation();});

    connect(ui->pbAND, &QPushButton::clicked, this, [this]() {doOperation();ui ->output->clear();  m_op = operation::AND;});
    connect(ui->pbOR, &QPushButton::clicked, this, [this]() {doOperation();ui ->output->clear();  m_op = operation::OR;});
    connect(ui->pbXOR, &QPushButton::clicked, this, [this]() {doOperation();ui ->output->clear();  m_op = operation::XOR;});
}


void   Calc::onDigit()
{
    auto snd = sender() -> objectName();
    auto xDigit = QString::number(snd.right(snd.length() - 2).toULongLong(),16);
    if (ui ->output->text().length() < ui -> output ->maxLength())
        ui ->output->setText(QString(ui ->output->text() + xDigit).toUpper());
}


void    Calc::doOperation()
{

    longType operand = ui ->output->text().toULongLong(nullptr,16);
    if (operation::NOT == m_op)
        operand = ~operand;
    else if (m_opMap.contains(m_op))
        operand = m_opMap[m_op](m_prev, operand);

    m_prev = operand;
    ui ->output->setText(QString::number(operand,16).toUpper());
    m_op = operation::NOP;
}




Calc::~Calc()
{
    delete ui;
}
