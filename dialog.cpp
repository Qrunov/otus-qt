#include <QTimer>
#include "dialog.h"
#include "ui_dialog.h"

Dialog::Dialog(QWidget *parent)
    : QDialog(parent)
    , ui(new Ui::Dialog)
{
    ui->setupUi(this);
    ui->progressBar->setPixmap(":/orig.png");
    //ui->progressBar->setTextVisible(false);


    QTimer  *timer = new QTimer(this);
    connect(timer, SIGNAL(timeout()), this, SLOT(onTimeout()));
    timer->setInterval(1000);
    timer->start();
    ui->progressBar->setValue(0);

}

void Dialog::onTimeout()
{
      ui->progressBar->setValue(ui->progressBar->value()+1);
}

Dialog::~Dialog()
{
    delete ui;
}
