#ifndef OFFICEEXPORTER_H
#define OFFICEEXPORTER_H

#include <QObject>
#include <QString>

class OfficeExporter : public QObject {
    Q_OBJECT
public:
    explicit OfficeExporter(QObject *parent = nullptr);

    Q_INVOKABLE bool exportWord(const QString &filePath, const QString &content);

    // 创建并保存 Word 文档
    Q_INVOKABLE bool createAndSaveWordDocument(const QString &filePath, const QString &content);

    Q_INVOKABLE bool createFromTemplate(const QString &templatePath, const QString &outputPath,  const QVariantMap &data);

    bool replaceMultiple(const QString &templatePath, const QString &outputPath, const QMap<QString, QString> &placeholders);

};
#endif // OFFICEEXPORTER_H
