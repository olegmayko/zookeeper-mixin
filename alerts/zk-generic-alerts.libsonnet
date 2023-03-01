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
            summary: '[{{ $labels.%(envLabel)s | toUpper }}]: Instance {{ $labels.instance }} ZooKeeper server is down' % $._config,
            description: '{{ $labels.instance }} ZooKeeper server is down: [{{ $value }}].',
          },
        },
        {
          alert: 'ZK_CREATE_TOO_MANY_ZNODES',
          expr: 'znode_count{%(prefixedNamespaceSelector)s%(labelSelector)s} > 1000000' % $._config,
          'for': $._config.prefixedDuration,
          labels: {
            severity: 'warning',
          },
          annotations: {
            summary: '[{{ $labels.%(envLabel)s | toUpper }}]: Instance {{ $labels.instance }} create too many znodes' % $._config,
            description: '[{{ $labels.%(envLabel)s | toUpper }}]: {{ $labels.instance }} ZooKeeper server create too many znodes: [{{ $value }}].' % $._config,
          },
        },
        {
          alert: 'ZK_LEADER_ELECTION',
          expr: 'sum by (%(groupByLabels)s) (increase(election_time_count{%(prefixedNamespaceSelector)s%(labelSelector)s}[5m])) > 0' % $._config,
          'for': $._config.prefixedDuration,
          labels: {
            severity: 'warning',
          },
          annotations: {
            summary: '[{{ $labels.%(envLabel)s | toUpper }}]: ZooKeeper leader election happens' % $._config,
            description: 'ZooKeeper a leader election happens: [{{ $value }}]',
          },
        },
        {
          // Idea that cluster size should not be hardcoded
          alert: 'ZK_MISSING_QUORUM',
          expr: 'max by (%(groupByLabels)s) (quorum_size{%(prefixedNamespaceSelector)s%(labelSelector)s}) - sum by (%(groupByLabels)s) (up{%(prefixedNamespaceSelector)s%(labelSelector)s}) != 0' % $._config,
          'for': $._config.prefixedDuration,
          labels: {
            severity: 'critical',
          },
          annotations: {
            summary: '[{{ $labels.%(envLabel)s | toUpper }}] ZooKeeper missing quorum' % $._config,
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
            summary: '[{{ $labels.%(envLabel)s | toUpper }}]: ZooKeeper JVM memory filling up (instance {{ $labels.instance }})' % $._config,
            description: 'JVM memory is filling up (> 80%)\n labels: {{ $labels }}  value = {{ $value }}\n',
          },
        },
        {
          alert: 'ZK_FSYNC_TIME_IS_TOO_LONG',
          expr: 'rate(fsynctime_sum{%(prefixedNamespaceSelector)s%(labelSelector)s}[5m]) > 100' % $._config,
          'for': $._config.prefixedDuration,
          labels: {
            severity: 'warning',
          },
          annotations: {
            summary: '[{{ $labels.%(envLabel)s | toUpper }}]: ZooKeeper Instance {{ $labels.instance }} fsync time is too long' % $._config,
            description: '{{ $labels.instance }} of job {{$labels.job}} fsync time is too long: [{{ $value }}].',
          },
        },
        {
          alert: 'ZK_AVERAGE_LATENCY_IS_TOO_HIGH',
          expr: 'avg_latency{%(prefixedNamespaceSelector)s%(labelSelector)s} > 100' % $._config,
          'for': $._config.prefixedDuration,
          labels: {
            severity: 'warning',
          },
          annotations: {
            summary: '[{{ $labels.%(envLabel)s | toUpper }}]: ZooKeeper Instance {{ $labels.instance }} avg latency is too high' % $._config,
            description: '{{ $labels.instance }} of job {{$labels.job}} avg latency is too high: [{{ $value }}].',
          },
        },
        {
          alert: 'ZK_LEADER_UNAVAILABLE',
          expr: 'sum by (%(groupByLabels)s) (changes(leader_unavailable_time{%(prefixedNamespaceSelector)s%(labelSelector)s}[5m])) > 0' % $._config,
          'for': $._config.prefixedDuration,
          labels: {
            severity: 'critical',
          },
          annotations: {
            summary: '[{{ $labels.%(envLabel)s | toUpper }}]: ZooKeeper Leader {{ $labels.%(envLabel)s }} is not available' % $._config,
            description: 'ZooKeeper {{ $labels.%(envLabel)s }} leader is not available' % $._config,
          },
        },
      ],
    }],
  },
}
