#ifndef COMPOSITORMODEL_HPP
#define COMPOSITORMODEL_HPP

#include <QAbstractListModel>
#include <QObject>
#include <QWaylandXdgSurface>
#include <qstringview.h>

class CompositorModel : public QAbstractListModel {
  Q_OBJECT
  Q_PROPERTY(int count READ count NOTIFY countChanged FINAL)
public:
  enum Roles { ShellSurfaceRole = Qt::UserRole + 1 };

  CompositorModel(QObject *parent = nullptr);
  int rowCount(const QModelIndex &parent) const override;
  QVariant data(const QModelIndex &index,
                int role = Qt::DisplayRole) const override;
  QHash<int, QByteArray> roleNames() const override;
  int count() const { return m_surfaces.size(); }
  Q_INVOKABLE void append(QWaylandXdgSurface *surface);
  Q_INVOKABLE void remove(int index);
  Q_INVOKABLE QWaylandXdgSurface *at(int index) const;
  Q_INVOKABLE void activate(int index);
  Q_INVOKABLE void swichTile(int index);

signals:
  void countChanged();
  void layoutUpdated();

  void requestActivate(QWaylandXdgSurface *surface, int index);

private:
  QList<QWaylandXdgSurface *> m_surfaces;
};

Q_DECLARE_METATYPE(QWaylandXdgSurface *)

#endif // COMPOSITORMODEL_HPP
