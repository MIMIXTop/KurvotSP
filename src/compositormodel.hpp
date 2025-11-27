#ifndef COMPOSITORMODEL_HPP
#define COMPOSITORMODEL_HPP

#include <QAbstractListModel>
#include <QObject>
#include <QWaylandXdgSurface>

class CompositorModel : public QAbstractListModel {
  Q_OBJECT
  Q_PROPERTY(int count READ count NOTIFY countChanged FINAL)
  Q_PROPERTY(QVariantList allButFirst READ allButFirst NOTIFY countChanged)
  Q_PROPERTY(QVariantList first READ first NOTIFY countChanged)
public:
  CompositorModel(QObject *parent = nullptr);
  int rowCount(const QModelIndex &parent) const override;
  QVariant data(const QModelIndex &index,
                int role = Qt::DisplayRole) const override;
  int count() const { return m_surfaces.size(); }
  Q_INVOKABLE void append(QWaylandXdgSurface *surface);
  Q_INVOKABLE void remove(int index);
  Q_INVOKABLE QVariantList allButFirst() const;
  Q_INVOKABLE QVariantList first() const;
  Q_INVOKABLE QWaylandXdgSurface *at(int index) const;
signals:
  void countChanged();

private:
  QList<QWaylandXdgSurface *> m_surfaces;
};

Q_DECLARE_METATYPE(QWaylandXdgSurface *)

#endif // COMPOSITORMODEL_HPP
