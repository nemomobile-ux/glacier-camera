#include <QSettings>

#include "camerasettings.h"


CameraSettings::CameraSettings(QObject *parent) : QObject(parent)
{
    settings = new QSettings();
}

CameraSettings::~CameraSettings()
{

}

void CameraSettings::setValue(const QString &key, const QVariant &value)
{
    settings->setValue(key, value);
}

QVariant CameraSettings::value(const QString &key, const QVariant &defaultValue)
{
    return settings->value(key, defaultValue);
}

void CameraSettings::sync()
{
    settings->sync();
}
