#include "mainwindow.h"
#include "ui_mainwindow.h"
#include "qpricedelegate.h"
#include <QFileDialog>
#include <QDebug>
#include <QStandardItemModel>
#include <QFile>
#include <QDateTime>
#include <QMessageBox>
#include <QLocale>

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    connect(ui->action_Open, SIGNAL(triggered()), this, SLOT(onOpen()));
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::onOpen()
{
    QFileDialog dlg(this);
    dlg.setFileMode(QFileDialog::ExistingFile);
    dlg.setNameFilter("CSV files(*.csv)");

    if (dlg.exec() != QDialog::Accepted)
        return;


    QFile csv(dlg.selectedFiles()[0]);
    if (!csv.open(QIODevice::ReadOnly | QIODevice::Text))
        return;

    QStandardItemModel *m = new QStandardItemModel();
    QPriceDelegate  *delegate = new QPriceDelegate();
    ui->priceView->setModel(m);
    ui->priceView->setItemDelegate(delegate);

    QDateTime startDate;
    int prevValue = -1;
    while (!csv.atEnd())
    {
        QByteArray line = csv.readLine();
        if (!line.isEmpty())
        {
            QStringList lst = QString(line).split(",");
            QDateTime dt = QDateTime::fromString(lst[0], Qt::ISODate);
            if (dt.isNull())
                continue;
            if (startDate.isNull())
            {
                startDate = dt;
                startDate = startDate.addDays(-dt.date().dayOfWeek() + 1);
            }
            int row = startDate.daysTo(dt) / 7;
            int col = startDate.daysTo(dt) % 7;
            if (m -> item(row,col))
                continue;
            int val = static_cast<int>(lst[1].toDouble());
            if (-1 == prevValue)
                prevValue = val;
            QStandardItem *item = new QStandardItem(QString::number(val));
            if (-1 != prevValue)
                if (prevValue == val)
                    item -> setData(0);
                else
                {
                    double change = (double)(val - prevValue)/prevValue * 100;
                    item -> setData(change);
                    item -> setData(QString::number(change, 'f', 1) + "%", Qt::ToolTipRole);
                }
            m -> setItem(row,col,item);
            prevValue = val;
        }
    }
    if (!m -> rowCount())
    {
        QMessageBox::warning(this,"Price sheet","No data");
        ui->priceView->reset();
        return;
    }

    QLocale locale;
    for (int i = 1; i <=7;i++)
    {
        QStandardItem *item = new QStandardItem(locale.dayName(i, QLocale::ShortFormat));
        m -> setHorizontalHeaderItem(i - 1, item);
    }
    ui->priceView->horizontalHeader()->setMinimumSectionSize(100);
    ui->priceView->horizontalHeader()->setSectionResizeMode(QHeaderView::Fixed);


    for (int i = 0; i < m -> rowCount();i++)
    {
        QStandardItem *item = new QStandardItem(startDate.addDays(i * 7).date().toString(Qt::ISODate));
        m -> setVerticalHeaderItem(i, item);
    }
}
