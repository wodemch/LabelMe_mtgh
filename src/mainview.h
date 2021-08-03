#ifndef MAINVIEW_H
#define MAINVIEW_H
#include<QQuickPaintedItem>
#include <QPainter>
#include<QDebug>
#include<QString>
#include<QUrl>
#include<QMouseEvent>
#include<QKeyEvent>
#include"cgraph.h"
#include"iniparams.h"
#include<jsonparse.h>
class MainView : public QQuickPaintedItem
{
    Q_OBJECT
    Q_ENUMS(Etype)
    Q_PROPERTY(QSize ImgSize READ getImgSize)
public:
    explicit MainView(QQuickItem *parent = nullptr);
    ~MainView();

public:
    enum Etype
    {
        TYPE_RECT = 0,
        TYPE_POLYGON,
        TYPE_CIRCLE,
        TYPE_CLEAR = 10,
        TYPE_MODIFY,
        TYPE_SAVE
    };

    QSize getImgSize(){
        return ImagePix->size();
    }
signals:
    void showSelectLabelName();
    void addLabelName(int index,QString labelName);
    void deleteLabelName(int index,QString labelName);
    void labelNameChange(QString labelName);
public slots:
    void changeScale(float fscale);
    bool doSomething(Etype type);
    void openImage(QUrl path);
    void deleteFile(QUrl str);
    void deleteOneGraph(int index);
    QList<QString> getLabelNameList();
    /*绘图相关*/
public:
    enum EButtons
    {
        LEFT_BUTTON = 1,
        RIGHT_BUTTON = 2,
        MiddleButton = 4
    };
    virtual void paint(QPainter *painter) override;
    virtual void keyPressEvent(QKeyEvent* event) override;
    void drawPix();
    QPoint scalePointProc(QPoint point,bool toOne=false);
    QRect scaleRectProc(QRect rect,bool toOne=false);

public slots:
    void initPainter(int w,int h);
    void mouseEnevt(int button,bool pressed,int x,int y);
    void mouseMove(int button,bool pressed,int x,int y);
    void modifyLabelName(QString labelName);
    void selectOne(int index,QString labelName);
private:
    QPoint mCurrentPoint;
    CGraph mCurrentGraph;
    QVector<CGraph> mVGraphs;

    QPixmap* pix;
    QPainter* painter;
    QPen* pen;
    QPen* selectPen;

    QPixmap* Orcimg;
    QPixmap* ImagePix;
    QSize mImgSize;
    float mScale;
    float mimgScale;

    bool bSelectMode;
    IniParams* mIni;
    QString mOldfilepath;

    jsonParse mJson;
};

#endif // MAINVIEW_H
