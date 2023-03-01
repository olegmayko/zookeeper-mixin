{
  _config+:: {
    //duration: '1m',  // for statetement in the config for easier override
    labelSelector: 'app="zookeeper"',
    // namespaceSelector: 'namespace="default"', // provide k8s namespace where zookeeper is deployed
    groupByLabels: 'env,namespace',  // group by env, multilabels are supported
    //  envLabel: 'env',  // optional label
  },
}
