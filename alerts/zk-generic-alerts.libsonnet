{
  _config+:: {
    labelSelector: error 'must provide selector for zookeeper',
    duration: null,
    prefixedDuration: if self.duration != null then self.duration else '5m',
    namespaceSelector: null,
    prefixedNamespaceSelector: if self.namespaceSelector != null then self.namespaceSelector + ',' else '',
  },

  prometheusAlerts+:: {
    groups+: [{
      name: 'zk-generic',
      rules: [
        {
          alert: 'ZK_INSTANCE_IS_DOWN',
          expr: 'up == 0{%(prefixedNamespaceSelector)s%(labelSelector)s}' % $._config,
          'for': $._config.prefixedDuration,
          labels: {
            severity: 'critical',
          },
          annotations: {
            summary: 'Instance {{ $labels.instance }} ZooKeeper server is down',
            description: '{{ $labels.instance }} of job {{$labels.job}} ZooKeeper server is down: [{{ $value }}].',
          },
        },
        {
          alert: 'CREATE_TOO_MANY_ZNODES',
          expr: 'znode_count > 1000000 ',
          'for': $._config.prefixedDuration,
          labels: {
            severity: 'critical',
          },
          annotations: {
            summary: 'Instance {{ $labels.instance }} ZooKeeper server is down',
            description: '{{ $labels.instance }} of job {{$labels.job}} ZooKeeper server is down: [{{ $value }}].',
          },
        },

      ],
    }],
  },
}
