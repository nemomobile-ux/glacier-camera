#ifndef CAMERASETTINGS_H
#define CAMERASETTINGS_H

#include <QObject>
#include <QSettings>

class CameraSettings : public QObject
{
    Q_OBJECT
public:
    explicit CameraSettings(QObject *parent = 0);
    ~CameraSettings();
    QSettings *settings;

signals:

public slots:
    Q_INVOKABLE void setValue(const QString &key, const QVariant &value);
    Q_INVOKABLE QVariant value(const QString &key, const QVariant &defaultValue = QVariant());
    Q_INVOKABLE void sync();
};

#endif // CAMERASETTINGS_H
