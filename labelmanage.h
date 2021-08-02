#ifndef LABELMANAGE_H
#define LABELMANAGE_H

#include <QObject>
#include <QUrl>
class LabelManage : public QObject
{
    Q_OBJECT
public:
    explicit LabelManage(QObject *parent = nullptr);

signals:

public slots:
    void testSlot(QString str="");
    void DeleteFile(QUrl str);

private:
};

#endif // LABELMANAGE_H
