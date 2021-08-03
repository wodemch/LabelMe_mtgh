#include "mainview.h"
#include<QImage>
#include<QMessageBox>
MainView::MainView(QQuickItem *parent) : QQuickPaintedItem(parent)
{
    mScale = 1;
    mimgScale = 1;
    painter = nullptr;
    pix = nullptr;
    ImagePix = nullptr;
    bSelectMode=false;
    mVGraphs.clear();
    setFocus(true);
    mIni = new IniParams(this);
    initPainter(mIni->size().width(),mIni->size().height());
    connect(mIni,&IniParams::ParamsChange,[=](){
        pen->setWidth(mIni->lineWidth());
        pen->setColor(mIni->lineColor());
        selectPen->setWidth(mIni->lineWidth()+1);
        mJson.jsonSaveFormt = mIni->saveFormt();
        drawPix();
    });
    mJson.jsonSaveFormt = mIni->saveFormt();
}
 MainView::~MainView()
{
    delete mIni;
    delete painter;
    delete pen;
    delete selectPen;
    delete pix;
    delete Orcimg;
    delete ImagePix;
}

void MainView::deleteFile(QUrl str)
{
    QFile file(str.toLocalFile());
    file.remove();
}

bool MainView::doSomething(Etype type)
{
    bool bSuccess = true;
    QMessageBox::StandardButton res;
    switch (type) {
    case TYPE_RECT:
    case TYPE_POLYGON:
    case TYPE_CIRCLE:
        mCurrentGraph.Type = EGraphType(type);
        break;
    case TYPE_CLEAR:
        res = QMessageBox::question(NULL,"info","是否删除所有标记？");
        if(res == QMessageBox::Yes)
        {
            mVGraphs.clear();
            mCurrentGraph.reset();
            drawPix();
        }else
            bSuccess = false;
        break;
    case TYPE_MODIFY:
        mIni->showModify();
        break;
    case TYPE_SAVE:
        if(!mJson.writeJson(mImgSize,mOldfilepath,mVGraphs))
        {
            QMessageBox::critical(NULL,"writejson error","writejson error:"+mOldfilepath);
        }
        break;
    }
    return bSuccess;
}

void MainView::openImage(QUrl path)
{
    QString filepath = path.toLocalFile();
    if(mOldfilepath!=filepath)
    {
        if(!mJson.writeJson(mImgSize,mOldfilepath,mVGraphs))
        {
            QMessageBox::critical(NULL,"writejson error","writejson error:"+mOldfilepath);
            return;
        }
        mVGraphs.clear();
        mVGraphs = mJson.readJson(filepath);
        for(int i=0;i<mVGraphs.size();i++)
        {
            emit addLabelName(i,mVGraphs[i].labelName);
        }
    }
    QPixmap map;
    map.load(filepath);
    if(!map.isNull())
    {
        mOldfilepath = filepath;
        //cv::Mat src = QImage2cvMat(img);
        //emit imageChange(path);
        mImgSize = map.size();
        *Orcimg = map;
        mCurrentGraph.reset();
        changeScale(0);
    }
}
void MainView::changeScale(float fscale)
{
    if(fscale==0)
    {
        if(!Orcimg->isNull())
        {
            int w = Orcimg->width();//width();
            int h = Orcimg->height();//height();
            float xs = w / Orcimg->width();
            float ys = h / Orcimg->height();
            mimgScale = xs > ys ? ys : xs;
            setWidth(w);
            setHeight(h);
            *ImagePix = *Orcimg;//->scaled(Orcimg->width()*mimgScale,Orcimg->height()*mimgScale);

            mCurrentGraph.ImgScale = mimgScale;
        }
        drawPix();

    }else
        mScale = fscale;
}
void MainView::keyPressEvent(QKeyEvent* event)
{
    if(event->key() == Qt::Key_Delete)
    {
    }
}
void MainView::mouseEnevt(int button,bool pressed,int x,int y)
{
    switch (button) {
    case LEFT_BUTTON:
        if(mCurrentGraph.addPoint(QPoint(x,y)))
        {
            bSelectMode = false;
            emit showSelectLabelName();
            mVGraphs.push_back(mCurrentGraph);
            mCurrentGraph.reset();
        }
        break;
    case RIGHT_BUTTON:
        mCurrentGraph.deletePoint();
        break;
    case MiddleButton:
        break;
    default:
        break;
    }
    drawPix();
}
void MainView::mouseMove(int button,bool pressed,int x,int y)
{
    if(pressed)return;
    switch (button) {
    case LEFT_BUTTON:
        break;
    case RIGHT_BUTTON:
        break;
    case MiddleButton:
        break;
    default:
        break;
    }
    mCurrentPoint = QPoint(x,y);
    drawPix();
}

void MainView::initPainter(int w,int h)
{
    if(painter == nullptr)
    {
        painter = new QPainter;
        pen = new QPen;
        pen->setStyle(Qt::SolidLine);
        pen->setColor(mIni->lineColor());
        pen->setWidth(mIni->lineWidth());

        selectPen = new QPen;
        selectPen->setStyle(Qt::DotLine);
        selectPen->setColor(Qt::blue);
        selectPen->setWidth(mIni->lineWidth()+1);
        pix = new QPixmap(w,h);
        Orcimg = new QPixmap(w,h);
        Orcimg->fill(Qt::gray);
        ImagePix = new QPixmap(w,h);
    }
}
void MainView::drawPix()
{
    if(painter == nullptr || !painter->begin(pix))
    {
        qDebug()<<"painter->begin(pix) false";
        return;
    }
    pix->fill(Qt::gray);
    painter->drawPixmap(0,0,*ImagePix);
    painter->setRenderHints(QPainter::Antialiasing);
    for(CGraph g:mVGraphs)
    {
        painter->setPen((g.IsSelect & bSelectMode) == true ? *selectPen : *pen);
        switch (g.Type)
        {
        case EG_RECT:
            painter->drawRect(g.getRect());
            break;
        case EG_POLYGON:
            painter->drawPolygon(g.allPoint());
            break;
        case EG_CIRCLE:
            painter->drawEllipse(g.getRect());
            break;
        }
    }
    //draw temp
    painter->setPen(*pen);
    QVector<QPoint> vp;
    if(mCurrentGraph.isDrawing())
    {
        switch (mCurrentGraph.Type)
        {
        case EG_RECT:
            painter->drawRect(QRect(mCurrentGraph.allPoint()[0],mCurrentPoint));
            break;
        case EG_POLYGON:
            //painter->drawPolygon(mCurrentGraph.allPoint());
            vp = mCurrentGraph.allPoint();
            for (int i=0;i<vp.size()-1;i++) {
                painter->drawLine(vp[i],vp[i+1]);
            }
            painter->drawLine(vp.last(),mCurrentPoint);
            break;
        case EG_CIRCLE:
            painter->drawEllipse(QRect(mCurrentGraph.allPoint()[0],mCurrentPoint));
            break;
        }
    }
    painter->end();
    update();
}
void MainView::paint(QPainter *painter)
{
    if(pix!=nullptr)
    {
        painter->drawPixmap(QPoint(0,0),*pix);
    }
}

QPoint MainView::scalePointProc(QPoint point,bool toOne)
{
    if(toOne){
        return QPoint(point.x()/mScale,point.y()/mScale);
    }else{
        return QPoint(point.x()*mScale,point.y()*mScale);
    }
}
QRect MainView::scaleRectProc(QRect rect,bool toOne)
{
    if(toOne){
        return QRect(rect.x()/mScale,rect.y()/mScale,rect.width()/mScale,rect.height()/mScale);
    }else{
        return QRect(rect.x()*mScale,rect.y()*mScale,rect.width()*mScale,rect.height()*mScale);
    }
}
void MainView::modifyLabelName(QString labelName)
{
    if(mVGraphs.size()>0){
        mVGraphs.last().labelName = labelName;
        emit addLabelName(mVGraphs.size()-1,labelName);
    }
    //label 添加保存
    QString allLabel = mIni->labelName();
    if(allLabel.indexOf(labelName)<0){
        mIni->setlabelName(allLabel+","+labelName);
        mIni->saveIni();
    }
}
void MainView::selectOne(int index,QString labelName)
{
    bSelectMode=true;
    for(int i=0;i<mVGraphs.size();i++)
    {
        mVGraphs[i].IsSelect = false;
        if(i==index && mVGraphs[i].labelName == labelName)
            mVGraphs[i].IsSelect = true;
    }
    drawPix();
}
void MainView::deleteOneGraph(int index)
{
    if(mVGraphs.size()>index){
        emit deleteLabelName(index,mVGraphs[index].labelName);
        mVGraphs.remove(index);
    }
    drawPix();
}
QList<QString> MainView::getLabelNameList()
{
    QList<QString> mLString;
    mLString = mIni->labelName().split(',');
    return mLString;
}
