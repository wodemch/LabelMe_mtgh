#ifndef INIPARAMS_H
#define INIPARAMS_H

#include<QObject>
#include<QQuickView>
#include<QString>
#include<QSize>
typedef  struct Params_
{
    QSize  PixSize;
    bool AutoSave;
    /* 0- labelmeWin 1-labelme*/
    int SaveFormt;
    int LineWidth;
    QColor LineColor;
}Params;

class IniParams: public QObject
{
    Q_OBJECT

    Q_PROPERTY(QSize size READ size WRITE setSize NOTIFY sizeChange)
    Q_PROPERTY(bool autoSave READ autoSave WRITE setautoSave NOTIFY autoSaveChange)
    Q_PROPERTY(int saveFormt READ saveFormt WRITE setsaveFormt NOTIFY saveFormtChange)
    Q_PROPERTY(int lineWidth READ lineWidth WRITE setlineWidth NOTIFY lineWidthChange)
    Q_PROPERTY(QColor lineColor READ lineColor WRITE setlineColor NOTIFY lineColorChange)
public:
    explicit IniParams(QObject *parent = nullptr);
    bool readIni();
    bool saveIni();
    void showModify();

    QSize size(){return mParams.PixSize;}
    void setSize(QSize s){mParamsEdit.PixSize = s;}
    bool autoSave(){return mParams.AutoSave;}
    void setautoSave(bool s){mParamsEdit.AutoSave = s;}
    int saveFormt(){return mParams.SaveFormt;}
    void setsaveFormt(int s){mParamsEdit.SaveFormt = s;}
    int lineWidth(){return mParams.LineWidth;}
    void setlineWidth(int s){mParamsEdit.LineWidth = s;}
    QColor lineColor(){return mParams.LineColor;}
    void setlineColor(QColor s){mParamsEdit.LineColor = s;}

    Q_INVOKABLE void updataParams();
signals:
    void sizeChange(QSize s);
    void autoSaveChange(bool s);
    void saveFormtChange(int s);
    void lineWidthChange(int s);
    void lineColorChange(QColor s);
    void ParamsChange();
private:
    QString mfileName;
    QQuickView *view ;
    Params mParams;
    Params mParamsEdit;
};

#endif // INIPARAMS_H
