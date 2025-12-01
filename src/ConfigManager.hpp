#ifndef CONFIGMANAGER_HPP
#define CONFIGMANAGER_HPP

#include <QDebug>
#include <QFile>
#include <QMap>
#include <QObject>
#include <QString>
#include <QTextStream>

#include <QFileSystemWatcher>
#include <qcontainerfwd.h>
#include <qtmetamacros.h>

class ConfigManager : public QObject {
  Q_OBJECT
  // Programs
  Q_PROPERTY(QString terminal READ terminal NOTIFY configChanged)
  Q_PROPERTY(QString folderManager READ folderManager NOTIFY configChanged)
  Q_PROPERTY(QString browser READ browser NOTIFY configChanged)
  Q_PROPERTY(QString codeRedactor READ codeRedactor NOTIFY configChanged)
  Q_PROPERTY(QString wofi READ wofi NOTIFY configChanged)
  Q_PROPERTY(QString telegram READ telegram NOTIFY configChanged)

  // Shortcuts
  Q_PROPERTY(QString keyTerminal READ keyTerminal NOTIFY configChanged)
  Q_PROPERTY(
      QString keyFolderManager READ keyFolderManager NOTIFY configChanged)
  Q_PROPERTY(QString keyBrowser READ keyBrowser NOTIFY configChanged)
  Q_PROPERTY(QString keyCodeRedactor READ keyCodeRedactor NOTIFY configChanged)
  Q_PROPERTY(QString keyWofi READ keyWofi NOTIFY configChanged)
  Q_PROPERTY(QString keyCloseWindow READ keyCloseWindow NOTIFY configChanged)
  Q_PROPERTY(QString keyTelegram READ keyTelegram NOTIFY configChanged)

  // Visuals
  Q_PROPERTY(QString backgroundColor READ backgroundColor NOTIFY configChanged)
  Q_PROPERTY(QString focusColor READ focusColor NOTIFY configChanged)
  Q_PROPERTY(int windowSpacing READ windowSpacing NOTIFY configChanged)
  Q_PROPERTY(int borderSize READ borderSize NOTIFY configChanged)
  Q_PROPERTY(QString backgroundImage READ backgroundImage NOTIFY configChanged)
  Q_PROPERTY(QString configPath READ configPath NOTIFY configChanged)

public:
  explicit ConfigManager(QObject *parent = nullptr);

  QString terminal() const { return m_config.value("terminal"); }
  QString folderManager() const { return m_config.value("folderManager"); }
  QString browser() const { return m_config.value("browser"); }
  QString codeRedactor() const { return m_config.value("codeRedactor"); }
  QString wofi() const { return m_config.value("wofi"); }
  QString telegram() const { return m_config.value("telegram"); }

  QString keyTerminal() const { return m_config.value("key_terminal"); }
  QString keyFolderManager() const {
    return m_config.value("key_folderManager");
  }
  QString keyBrowser() const { return m_config.value("key_browser"); }
  QString keyCodeRedactor() const { return m_config.value("key_codeRedactor"); }
  QString keyWofi() const { return m_config.value("key_wofi"); }
  QString keyCloseWindow() const { return m_config.value("key_closeWindow"); }
  QString keyTelegram() const { return m_config.value("key_telegram"); }

  QString backgroundColor() const {
    QString v = m_config.value("backgroundColor");
    return v.isEmpty() ? "#333333" : v;
  }
  QString focusColor() const {
    QString v = m_config.value("focusColor");
    return v.isEmpty() ? "#00FF00" : v;
  }
  int windowSpacing() const {
    QString v = m_config.value("windowSpasing");
    return v.isEmpty() ? 20 : v.toInt();
  }
  int borderSize() const {
    QString v = m_config.value("borderSize");
    return v.isEmpty() ? 4 : v.toInt();
  }
  QString backgroundImage() const {
    QString v = m_config.value("backgroundImage");
    return v.isEmpty() ? "qrc:/src/Resource/background.jpg" : v;
  }

  QString configPath() const { return m_configPath; }

signals:
  void configChanged();

private slots:
  void onFileChanged(const QString &path);

private:
  void loadConfig();
  QMap<QString, QString> m_config;
  QFileSystemWatcher *m_watcher;
  QString m_configPath;
};

#endif // CONFIGMANAGER_HPP
