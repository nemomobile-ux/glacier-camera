/*
 * Copyright (C) 2017-2024 Chupligin Sergey <neochapay@gmail.com>
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public License
 * along with this library; see the file COPYING.LIB.  If not, write to
 * the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1301, USA.
 */

#ifdef QT_QML_DEBUG
#include <QtQuick>
#endif
#include <QtGui/QGuiApplication>

#include <QCoreApplication>
#include <QtQml>
#include <QQuickView>

#include <glacierapp.h>

Q_DECL_EXPORT int main(int argc, char* argv[])
{
    QGuiApplication* app = GlacierApp::app(argc, argv);
    app->setOrganizationName("NemoMobile");

    QString imageDir = QStandardPaths::writableLocation(QStandardPaths::PicturesLocation);
    QQmlApplicationEngine* engine = GlacierApp::engine(app);
    engine->rootContext()->setContextProperty("imageDir", imageDir);

    QQuickWindow* window = GlacierApp::showWindow();

    window->setTitle(QObject::tr("Camera"));
    window->setIcon(QIcon("/usr/share/glacier-camera/images/glacier-camera.png"));

    return app->exec();
}
