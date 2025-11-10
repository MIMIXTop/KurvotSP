#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QWaylandXdgSurface>

#include "launcher.hpp"
#include "loger.hpp"
#include "compositormodel.hpp"

int main(int argc, char *argv[])
{
    Loger::log("Starting Wayland Compositor application");
    
    QCoreApplication::setAttribute(Qt::AA_ShareOpenGLContexts, true);
    QGuiApplication app(argc, argv);

    qRegisterMetaType<QWaylandXdgSurface*>("QWaylandXdgSurface*");
    qmlRegisterType<Launcher>("Launcher", 1, 0, "Launcher");
    qmlRegisterType<CompositorModel>("MyModel", 1, 0, "MyModel");
    
    QQmlApplicationEngine engine;
    
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { 
            Loger::log("QML object creation failed, exiting application");
            QCoreApplication::exit(-1); 
        },
        Qt::QueuedConnection);
        
    engine.loadFromModule("TemplateWaylandCompositor", "Main");

    return app.exec();
}
