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
  Q_PROPERTY(int maxWindows READ maxWindows NOTIFY configChanged)

public:
  explicit ConfigManager(QObject *parent = nullptr);

  QString terminal() const;
  QString folderManager() const;
  QString browser() const;
  QString codeRedactor() const;
  QString wofi() const;
  QString telegram() const;

  QString keyTerminal() const;
  QString keyFolderManager() const;
  QString keyBrowser() const;
  QString keyCodeRedactor() const;
  QString keyWofi() const;
  QString keyCloseWindow() const;
  QString keyTelegram() const;

  QString backgroundColor() const;
  QString focusColor() const;
  int windowSpacing() const;
  int borderSize() const;
  QString backgroundImage() const;

  int maxWindows() const;

  QString configPath() const;

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
