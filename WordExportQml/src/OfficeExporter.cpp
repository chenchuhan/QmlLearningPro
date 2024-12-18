#include "OfficeExporter.h"
#include <QFile>
#include <QTextStream>
#include <QAxObject>
#include <QDebug>

OfficeExporter::OfficeExporter(QObject *parent)
    : QObject(parent) {}

bool OfficeExporter::exportWord(const QString &filePath, const QString &content) {
    // 使用 Qt-Office 或 QTextDocument API 生成文档
    QFile file(filePath);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        return false;
    }

    QTextStream stream(&file);
    stream << content;
    file.close();
    return true;
}

//测试：创造和保存
bool OfficeExporter::createAndSaveWordDocument(const QString &filePath, const QString &content)
{
    // 创建 Word 应用程序对象
    QAxObject *wordApp = new QAxObject("Word.Application");
    if (!wordApp->isNull()) {
        wordApp->setProperty("Visible", false); // 隐藏 Word 窗口

        // 创建一个新的文档
        QAxObject *documents = wordApp->querySubObject("Documents");
        QAxObject *document = documents->querySubObject("Add()");

        // 获取文档中的选择区域（光标位置）
        QAxObject *selection = wordApp->querySubObject("Selection");

        // 插入内容
        selection->dynamicCall("TypeText(const QString&)", content);
        selection->dynamicCall("TypeParagraph()");  // 换行

        // 保存文件
        document->dynamicCall("SaveAs(const QString&)", filePath);

        // 关闭文档
        document->dynamicCall("Close()");
        wordApp->dynamicCall("Quit()");
        delete wordApp;

        return true;
    }

    delete wordApp;
    return false;
}

//测试：替换
bool OfficeExporter::createFromTemplate(const QString &templatePath, const QString &outputPath, const QVariantMap &data)  //const QMap<QString, QString> &placeholder)
{
    qDebug() << "Received data:" << data;

    // 转换 QVariantMap 为 QMap<QString, QString>
    QMap<QString, QString> placeholders;
    for (auto it = data.begin(); it != data.end(); ++it) {
        placeholders[it.key()] = it.value().toString();
    }

    qDebug() << "Template Path:" << templatePath;
    qDebug() << "Output Path:" << outputPath;


    // 检查文件路径
    if (!QFile::exists(templatePath)) {
        qDebug() << "Template file does not exist:" << templatePath;
        return false;
    }

    qDebug() << "QFile::exists ok" ;

    // 创建 Word 应用程序对象
    QAxObject *wordApp = new QAxObject("Word.Application");
    if (wordApp->isNull()) {
        qDebug() << "Failed to initialize Word.Application.";
        delete wordApp;
        return false;
    }

    qDebug() << "wordApp ok" ;
    wordApp->setProperty("Visible", false); // 隐藏 Word 窗口

    // 打开模板文件
    QAxObject *documents = wordApp->querySubObject("Documents");
    QAxObject *document = documents->querySubObject("Open(const QString&)", templatePath);

    // 查找占位符并替换
    //使用 Find.Execute 查找占位符，使用 TypeText 方法替换为新内容
    QAxObject *selection = wordApp->querySubObject("Selection");

    qDebug() << "selection ok" ;

    // 获取 Find 对象
    QAxObject *find = selection->querySubObject("Find");

    qDebug() << "start placeholde";
    // 遍历占位符键值对, 替换未成功，则有问题
    for(auto it = placeholders.begin(); it != placeholders.end(); ++it) {
        QString placeholder = it.key();
        QString newContent = it.value();

        // 重置光标到文档开头
//        selection->dynamicCall("HomeKey(Unit:=6)"); // Move to the start of the document
        //适应于多目标的查找，全部替换
        bool isFound = true;

        //可替换多个，且重复的
        while (isFound) {
            // 查找目标文本并替换
//            isFound = find->dynamicCall("Execute(const QString&)", placeholder).toBool();
            isFound = find->dynamicCall("Execute(QString, bool, bool, bool, bool, bool, bool, int)",
                                        placeholder,  // 要查找的字符串
                                        false,        // 区分大小写
                                        false,        // 完整单词
                                        false,        // 使用通配符
                                        false,        // 忽略标点符号
                                        false,        // 忽略空格
                                        true,         // 向前查找
                                        1).toBool();   // 查找范围：整个文档

            if (isFound) {
                // 替换文本
                selection->dynamicCall("TypeText(const QString&)", newContent);
            }
        }
    }

    qDebug() << "All Find operation succeed!";

    document->dynamicCall("SaveAs(const QString&)", outputPath);
    // 关闭文档
    document->dynamicCall("Close()");
    wordApp->dynamicCall("Quit()");

    delete wordApp;
    return true;
}
