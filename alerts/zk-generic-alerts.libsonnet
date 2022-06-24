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
          expr: 'up{%(prefixedNamespaceSelector)s%(labelSelector)s} == 0' % $._config,
          'for': $._config.prefixedDuration,
          labels: {
            severity: 'critical',
          },
          annotations: {
            summary: 'Instance {{ $labels.instance }} ZooKeeper server is down',
            description: '{{ $labels.instance }} ZooKeeper server is down: [{{ $value }}].',
          },
        },
        {
          alert: 'CREATE_TOO_MANY_ZNODES',
          expr: 'znode_count{%(prefixedNamespaceSelector)s%(labelSelector)s} > 1000000' % $._config,
          'for': $._config.prefixedDuration,
          labels: {
            severity: 'critical',
          },
          annotations: {
            summary: 'Instance {{ $labels.instance }} create too many znodes',
            description: '{{ $labels.instance }} ZooKeeper server create too many znodes: [{{ $value }}].',
          },
        },
        {
          alert: 'FREQUENT_LEADER_ELECTION',
          expr: 'increase(election_time_count{%(prefixedNamespaceSelector)s%(labelSelector)s}[5m]) > 0' % $._config,
          'for': $._config.prefixedDuration,
          labels: {
            severity: 'warning',
          },
          annotations: {
            summary: 'Instance {{ $labels.instance }}  a leader election happens',
            description: '{{ $labels.instance }} ZooKeeper a leader election happens: [{{ $value }}].',
          },
        },
      ],
    }],
  },
}
