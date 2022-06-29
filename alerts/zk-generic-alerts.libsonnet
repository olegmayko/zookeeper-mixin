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
            severity: 'warning',
          },
          annotations: {
            summary: 'Instance {{ $labels.instance }} create too many znodes',
            description: '{{ $labels.instance }} ZooKeeper server create too many znodes: [{{ $value }}].',
          },
        },
        {
          alert: 'ZK_LEADER_ELECTION',
          expr: 'increase(election_time_count{%(prefixedNamespaceSelector)s%(labelSelector)s}[5m]) > 0' % $._config,
          'for': $._config.prefixedDuration,
          labels: {
            severity: 'warning',
          },
          annotations: {
            summary: 'ZooKeeper leader election happens',
            description: 'ZooKeeper a leader election happens: [{{ $value }}].',
          },
        },
        {
          // Idea that cluster size should not be hardcoded
          alert: 'ZK_MISSING_QUORUM',
          expr: 'max(quorum_size{%(prefixedNamespaceSelector)s%(labelSelector)s}) - sum(up{%(prefixedNamespaceSelector)s%(labelSelector)s}) == 0' % $._config,
          'for': $._config.prefixedDuration,
          labels: {
            severity: 'critical',
          },
          annotations: {
            summary: 'ZooKeeper missing quorum',
            description: 'The quorum is not the same as number of zookeeper instances',
          },
        },
        {
          alert: 'ZK_JVM_MEMORY_FILLING_UP',
          expr: 'jvm_memory_bytes_used{%(prefixedNamespaceSelector)s%(labelSelector)s} / jvm_memory_bytes_max{area="heap",%(prefixedNamespaceSelector)s%(labelSelector)s} > 0.9' % $._config,
          'for': $._config.prefixedDuration,
          labels: {
            severity: 'warning',
          },
          annotations: {
            summary: 'JVM memory filling up (instance {{ $labels.instance }})',
            description: 'JVM memory is filling up (> 80%)\n labels: {{ $labels }}  value = {{ $value }}\n',
          },
        },
        {
          alert: 'FSYNC_TIME_IS_TOO_LONG',
          expr: 'rate(fsynctime_sum{%(prefixedNamespaceSelector)s%(labelSelector)s}[5m]) > 100' % $._config,
          'for': $._config.prefixedDuration,
          labels: {
            severity: 'warning',
          },
          annotations: {
            summary: 'Instance {{ $labels.instance }} fsync time is too long',
            description: '{{ $labels.instance }} of job {{$labels.job}} fsync time is too long: [{{ $value }}].',
          },
        },
        {
          alert: 'AVERAGE_LATENCY_IS_TOO_HIGH',
          expr: 'avg_latency{%(prefixedNamespaceSelector)s%(labelSelector)s} > 100' % $._config,
          'for': $._config.prefixedDuration,
          labels: {
            severity: 'warning',
          },
          annotations: {
            summary: 'Instance {{ $labels.instance }} avg latency is too high',
            description: '{{ $labels.instance }} of job {{$labels.job}} avg latency is too high: [{{ $value }}].',
          },
        },
      ],
    }],
  },
}
